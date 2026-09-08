package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * 비밀번호 암호화 / 검증 유틸.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 메서드명 오타 : hashPasswrod / checkPasswrod (Password → Passwrod)
 *     파라미터명도 plainPasswor 로 오타.
 *  2) checkpw() 에 BCrypt 해시가 아닌 값(평문 등)이 들어오면
 *     IllegalArgumentException("Invalid salt version") 이 터진다.
 *     → LoginService 에서 그대로 500 에러로 이어졌다.
 *        (DB 에 손으로 넣은 평문 비밀번호가 하나라도 있으면 로그인 화면이 죽는다)
 *  3) null 방어가 전혀 없었다.
 *
 * 변경 후
 *  1) 올바른 철자의 hashPassword / checkPassword 를 추가.
 *     기존 이름은 @Deprecated 로 남겨 두어 예전 코드도 계속 동작한다.
 *  2) checkPassword 는 어떤 입력이 와도 예외를 던지지 않고 false 를 반환한다.
 *  3) 해시 형식인지 미리 판별하는 isHashed() 추가.
 * </pre>
 */
public class PasswordUtil {

	/**
	 * BCrypt 강도(cost). 값이 1 오르면 연산량이 2배가 된다.
	 * 10 = 기본값, 12 = 더 안전하지만 로그인이 느려짐.
	 */
	private static final int COST = 10;

	private PasswordUtil() {
	}

	// =================================================================
	// 정상 API (신규 코드는 이쪽을 사용)
	// =================================================================

	/**
	 * 평문 비밀번호를 BCrypt 해시로 변환한다.
	 * 같은 비밀번호라도 매번 다른 salt 가 붙어 결과가 달라진다(정상).
	 *
	 * @param plainPassword 평문 비밀번호 (null 불가)
	 * @return 60자 BCrypt 해시
	 */
	public static String hashPassword(String plainPassword) {

		if (plainPassword == null) {
			throw new IllegalArgumentException("비밀번호가 null 입니다.");
		}
		return BCrypt.hashpw(plainPassword, BCrypt.gensalt(COST));
	}

	/**
	 * 평문 비밀번호가 저장된 해시와 일치하는지 검증한다.
	 *
	 * <p>
	 * <b>어떤 경우에도 예외를 던지지 않는다.</b>
	 * null 이거나 해시 형식이 아니면 그냥 false 를 반환한다.
	 * (로그인 화면이 500 으로 죽지 않게 하기 위한 방어)
	 * </p>
	 *
	 * @param plainPassword  사용자가 입력한 평문
	 * @param hashedPassword DB 에 저장된 해시
	 * @return 일치하면 true
	 */
	public static boolean checkPassword(String plainPassword, String hashedPassword) {

		if (plainPassword == null || hashedPassword == null) {
			return false;
		}

		if (!isHashed(hashedPassword)) {
			// DB 에 평문이 들어 있는 비정상 데이터.
			// 로그로 알려주되, 평문 비교로 통과시키지는 않는다(보안).
			System.err.println("[PasswordUtil] BCrypt 형식이 아닌 비밀번호가 저장되어 있습니다. "
					+ "db/02_sample_data.sql 처럼 해시로 다시 넣어주세요.");
			return false;
		}

		try {
			return BCrypt.checkpw(plainPassword, hashedPassword);
		} catch (IllegalArgumentException e) {
			// 해시 문자열이 깨진 경우 (길이 부족 등)
			System.err.println("[PasswordUtil] 비밀번호 검증 실패 : " + e.getMessage());
			return false;
		}
	}

	/**
	 * BCrypt 해시 형식인지 검사한다.
	 * BCrypt 해시는 "$2a$", "$2b$", "$2y$" 로 시작하고 총 60자다.
	 */
	public static boolean isHashed(String value) {

		if (value == null || value.length() != 60) {
			return false;
		}
		return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
	}

	/**
	 * 비밀번호 정책 검사.
	 * <p>
	 * 8자 이상, 영문자와 숫자를 각각 1개 이상 포함해야 한다.
	 * </p>
	 *
	 * @return 정책에 맞으면 true
	 */
	public static boolean isValidPolicy(String plainPassword) {

		if (plainPassword == null || plainPassword.length() < 8) {
			return false;
		}

		boolean hasLetter = false;
		boolean hasDigit = false;

		for (char c : plainPassword.toCharArray()) {
			if (Character.isLetter(c)) {
				hasLetter = true;
			} else if (Character.isDigit(c)) {
				hasDigit = true;
			}
		}
		return hasLetter && hasDigit;
	}

	// =================================================================
	// 하위 호환용 (오타가 있는 기존 메서드명)
	//  - 예전 코드가 깨지지 않도록 남겨 둔다.
	// =================================================================

	/** @deprecated 오타 있는 예전 이름. {@link #hashPassword(String)} 를 쓸 것. */
	@Deprecated
	public static String hashPasswrod(String plainPasswor) {
		return hashPassword(plainPasswor);
	}

	/** @deprecated 오타 있는 예전 이름. {@link #checkPassword(String, String)} 를 쓸 것. */
	@Deprecated
	public static boolean checkPasswrod(String plainPasswor, String hashePassword) {
		return checkPassword(plainPasswor, hashePassword);
	}
}
