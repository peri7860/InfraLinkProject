package util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * 애플리케이션 설정 로더.
 *
 * <p>
 * [신규 생성] 2026-09-07
 * </p>
 *
 * <pre>
 * 변경 이유
 *  - 기존 DBManager.java 안에 DB 계정/비밀번호가 하드코딩되어 있었다.
 *    (소스가 Git 에 올라가면 계정이 그대로 유출된다)
 *  - 업로드 경로도 NoticeInsertService 안에 "C:\\upload2" 로 박혀 있었다.
 *  → 두 가지를 모두 클래스패스의 db.properties 로 빼고,
 *    이 클래스가 한 번만 읽어서 캐싱한다.
 *
 * 파일 위치
 *  - 소스     : src/main/java/db.properties
 *  - 배포 후  : WEB-INF/classes/db.properties  (클래스패스 루트)
 * </pre>
 */
public class AppConfig {

	/** 설정 파일명 (클래스패스 루트 기준) */
	private static final String CONFIG_FILE = "db.properties";

	/**
	 * 읽어 들인 설정.
	 * static 초기화 블록에서 클래스 로딩 시 딱 한 번만 읽는다.
	 */
	private static final Properties PROPS = new Properties();

	/** 설정 파일을 못 읽었을 때의 원인 (기동 진단용) */
	private static String loadError = null;

	static {
		load();
	}

	/** 인스턴스를 만들 필요가 없는 유틸리티 클래스 */
	private AppConfig() {
	}

	/**
	 * 클래스패스에서 db.properties 를 읽는다.
	 * <p>
	 * 한글/일본어 주석이 들어갈 수 있으므로 UTF-8 Reader 로 읽는다.
	 * (Properties.load(InputStream) 은 ISO-8859-1 로 읽어서 주석이 깨진다)
	 * </p>
	 */
	private static void load() {

		ClassLoader cl = Thread.currentThread().getContextClassLoader();
		if (cl == null) {
			cl = AppConfig.class.getClassLoader();
		}

		try (InputStream in = cl.getResourceAsStream(CONFIG_FILE)) {

			if (in == null) {
				loadError = CONFIG_FILE + " 를 클래스패스에서 찾을 수 없습니다. "
						+ "src/main/java/db.properties 가 있는지, "
						+ "빌드 후 WEB-INF/classes 로 복사되었는지 확인하세요.";
				System.err.println("[AppConfig] " + loadError);
				return;
			}

			PROPS.load(new InputStreamReader(in, StandardCharsets.UTF_8));
			System.out.println("[AppConfig] 설정 로드 완료 (" + PROPS.size() + "건)");

		} catch (IOException e) {
			loadError = CONFIG_FILE + " 읽기 실패 : " + e.getMessage();
			System.err.println("[AppConfig] " + loadError);
		}
	}

	/**
	 * 문자열 설정값 조회.
	 *
	 * @param key          설정 키
	 * @param defaultValue 값이 없을 때 사용할 기본값
	 */
	public static String get(String key, String defaultValue) {
		String value = PROPS.getProperty(key);
		if (value == null || value.trim().isEmpty()) {
			return defaultValue;
		}
		return value.trim();
	}

	/**
	 * 문자열 설정값 조회 (기본값 없음).
	 *
	 * @throws IllegalStateException 설정이 없으면 즉시 알려준다.
	 *                               (null 을 반환해서 나중에 NPE 로 터지는 것보다 낫다)
	 */
	public static String get(String key) {
		String value = get(key, null);
		if (value == null) {
			throw new IllegalStateException(
					"설정값이 없습니다 : " + key
							+ (loadError != null ? " / " + loadError : ""));
		}
		return value;
	}

	/** 숫자 설정값 조회. 값이 없거나 숫자가 아니면 기본값을 돌려준다. */
	public static int getInt(String key, int defaultValue) {
		try {
			return Integer.parseInt(get(key, String.valueOf(defaultValue)));
		} catch (NumberFormatException e) {
			System.err.println("[AppConfig] " + key + " 값이 숫자가 아닙니다. 기본값 사용 : " + defaultValue);
			return defaultValue;
		}
	}

	/** 설정 파일 로딩 실패 사유 (정상이면 null) */
	public static String getLoadError() {
		return loadError;
	}
}
