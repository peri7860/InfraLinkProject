package util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.Part;

/**
 * 첨부파일 업로드 / 다운로드 공통 처리.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 NoticeInsertService 안에 있던 업로드 로직의 문제
 *  1) 저장 경로가 "C:\\upload2" 로 하드코딩
 *  2) 확장자 검증이 전혀 없음
 *     → .jsp / .exe 를 올릴 수 있고, 저장 위치가 웹 경로였다면
 *       그대로 실행되는 심각한 취약점(웹셸 업로드)이 된다.
 *  3) 용량 제한 없음
 *  4) 원본 파일명을 DB 에 저장하지 않아 다운로드 시 UUID 이름으로 받게 됨
 *  5) 경로 조작(../../) 방어 없음
 *
 * 변경 후
 *  - 저장 경로/최대 용량/허용 확장자를 db.properties 로 분리
 *  - 확장자 화이트리스트 + 용량 검사
 *  - 저장명은 UUID, 원본명은 DB 에 따로 보관
 *  - 파일명에서 경로 구분자를 제거해 디렉터리 탈출을 막는다
 * </pre>
 */
public class FileUtil {

	private FileUtil() {
	}

	/** 업로드 결과를 담는 작은 값 객체 */
	public static class UploadResult {

		/** 서버에 저장된 파일명 (UUID_원본명) — DB 의 file_path 컬럼 */
		public final String savedName;
		/** 사용자에게 보여줄 원본 파일명 — DB 의 file_name 컬럼 */
		public final String originalName;

		public UploadResult(String savedName, String originalName) {
			this.savedName = savedName;
			this.originalName = originalName;
		}
	}

	/** 첨부파일이 잘못됐을 때 던지는 예외 (서비스에서 잡아 화면에 메시지 표시) */
	public static class UploadException extends Exception {
		private static final long serialVersionUID = 1L;

		public UploadException(String message) {
			super(message);
		}
	}

	/** 업로드 루트 디렉터리 (없으면 만든다) */
	public static File getUploadDir() {

		String dirPath = AppConfig.get("upload.dir", "C:/infralink-upload");
		File dir = new File(dirPath);

		if (!dir.exists() && !dir.mkdirs()) {
			System.err.println("[FileUtil] 업로드 폴더 생성 실패 : " + dir.getAbsolutePath());
		}
		return dir;
	}

	/** 허용 확장자 집합 (소문자) */
	private static Set<String> getAllowedExtensions() {

		String raw = AppConfig.get("upload.allowExt",
				"jpg,jpeg,png,gif,bmp,pdf,doc,docx,xls,xlsx,ppt,pptx,txt,csv,zip,hwp");

		Set<String> set = new HashSet<>();
		for (String ext : raw.split(",")) {
			String trimmed = ext.trim().toLowerCase(Locale.ROOT);
			if (!trimmed.isEmpty()) {
				set.add(trimmed);
			}
		}
		return set;
	}

	/**
	 * multipart 요청의 Part 를 검증하고 서버에 저장한다.
	 *
	 * @param part 파일 파트 (null 이거나 크기 0이면 첨부 없음 → null 반환)
	 * @return 저장 결과. 첨부가 없으면 null
	 * @throws UploadException 확장자/용량 위반
	 * @throws IOException     저장 실패
	 */
	public static UploadResult save(Part part) throws UploadException, IOException {

		// ---------------------------------------------------------
		// 1. 첨부 없음 판정
		//    - part 자체가 null (폼에 file 필드가 없음)
		//    - 크기 0 (파일을 고르지 않고 제출)
		// ---------------------------------------------------------
		if (part == null || part.getSize() <= 0) {
			return null;
		}

		String submitted = part.getSubmittedFileName();
		if (submitted == null || submitted.trim().isEmpty()) {
			return null;
		}

		// ---------------------------------------------------------
		// 2. 파일명 정리 (디렉터리 탈출 방지)
		//    "../../webapps/ROOT/shell.jsp" 같은 값이 올 수 있으므로
		//    경로 부분을 모두 버리고 마지막 파일명만 취한다.
		// ---------------------------------------------------------
		String originalName = Paths.get(submitted).getFileName().toString();
		originalName = originalName.replaceAll("[\\\\/:*?\"<>|]", "_");

		// ---------------------------------------------------------
		// 3. 용량 검사
		// ---------------------------------------------------------
		long maxSize = AppConfig.getInt("upload.maxSize", 10 * 1024 * 1024);
		if (part.getSize() > maxSize) {
			throw new UploadException(
					"添付ファイルが大きすぎます。最大 " + (maxSize / 1024 / 1024) + "MB までです。");
		}

		// ---------------------------------------------------------
		// 4. 확장자 화이트리스트 검사
		// ---------------------------------------------------------
		String ext = getExtension(originalName);
		if (ext.isEmpty() || !getAllowedExtensions().contains(ext)) {
			throw new UploadException(
					"許可されていないファイル形式です（." + (ext.isEmpty() ? "?" : ext) + "）。");
		}

		// ---------------------------------------------------------
		// 5. 저장 (같은 이름이 겹치지 않도록 UUID 접두)
		// ---------------------------------------------------------
		String savedName = UUID.randomUUID().toString() + "_" + originalName;
		File target = new File(getUploadDir(), savedName);

		part.write(target.getAbsolutePath());

		System.out.println("[FileUtil] 업로드 완료 : " + target.getAbsolutePath()
				+ " (" + part.getSize() + " bytes)");

		return new UploadResult(savedName, originalName);
	}

	/**
	 * 저장된 첨부파일을 삭제한다. (글 삭제/수정 시 사용)
	 *
	 * @param savedName DB 의 file_path 값
	 */
	public static void delete(String savedName) {

		if (savedName == null || savedName.trim().isEmpty()) {
			return;
		}

		// 파일명만 사용 (경로가 섞여 들어와도 업로드 폴더 밖은 건드리지 않는다)
		String safeName = new File(savedName).getName();
		File target = new File(getUploadDir(), safeName);

		if (target.exists() && !target.delete()) {
			System.err.println("[FileUtil] 파일 삭제 실패 : " + target.getAbsolutePath());
		}
	}

	/**
	 * 다운로드용 실제 파일 객체를 얻는다.
	 *
	 * @return 파일이 없으면 null
	 */
	public static File resolve(String savedName) {

		if (savedName == null || savedName.trim().isEmpty()) {
			return null;
		}

		String safeName = new File(savedName).getName();
		File target = new File(getUploadDir(), safeName);

		return target.exists() ? target : null;
	}

	/** 확장자를 소문자로 반환 (점 제외). 없으면 빈 문자열 */
	public static String getExtension(String fileName) {

		if (fileName == null) {
			return "";
		}
		int dot = fileName.lastIndexOf('.');
		if (dot < 0 || dot == fileName.length() - 1) {
			return "";
		}
		return fileName.substring(dot + 1).toLowerCase(Locale.ROOT);
	}

	/** 화면 표시용 파일 크기 문자열 (예: 1.2 MB) */
	public static String formatSize(long bytes) {

		if (bytes < 1024) {
			return bytes + " B";
		}
		String[] units = { "KB", "MB", "GB" };
		double size = bytes / 1024.0;
		int idx = 0;

		while (size >= 1024 && idx < units.length - 1) {
			size /= 1024.0;
			idx++;
		}
		return String.format(Locale.ROOT, "%.1f %s", size, units[idx]);
	}

	/** 설정된 허용 확장자 목록 (화면 안내용) */
	public static String getAllowedExtensionText() {
		return String.join(", ", new java.util.TreeSet<>(getAllowedExtensions()));
	}

	/** 허용 확장자 배열 (테스트/검증용) */
	public static String[] getAllowedExtensionArray() {
		Set<String> set = getAllowedExtensions();
		String[] arr = set.toArray(new String[0]);
		Arrays.sort(arr);
		return arr;
	}
}
