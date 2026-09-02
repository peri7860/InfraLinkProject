package util;

public class DBTest {

	public static void main(String[] args) {
		
		if(DBManager.getInstance() != null) {
			System.out.println("성공");
		}else {
			System.out.println("실패");
		}
	}
}
