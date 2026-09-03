package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	//비밀번호 암호화
	public static String hashPasswrod(String plainPasswor) {
		return BCrypt.hashpw(plainPasswor, BCrypt.gensalt());
	}
	
	//비밀번호 비교
	public static boolean checkPasswrod(String plainPasswor, String hashePassword) {
		return BCrypt.checkpw(plainPasswor, hashePassword);
	}
}
