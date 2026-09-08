package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * DB 접속 점검용 실행 클래스.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전
 *   getInstance() 가 null 인지만 보고 "성공/실패"를 출력했다.
 *   실패해도 왜 실패했는지(계정? URL? 드라이버?) 알 수 없었다.
 *
 * 변경 후
 *   - 설정 파일이 제대로 읽혔는지
 *   - 실제로 접속되는지 (DB 버전 출력)
 *   - 스키마(테이블/시퀀스)가 설치되어 있는지
 *   까지 한 번에 점검해서 알려준다.
 *
 * 실행 방법
 *   Eclipse 에서 이 파일 우클릭 → Run As → Java Application
 *   (WEB-INF/lib 의 ojdbc jar 이 빌드패스에 잡혀 있어야 한다)
 * </pre>
 */
public class DBTest {

	/** 설치되어 있어야 하는 테이블 목록 */
	private static final String[] REQUIRED_TABLES = {
			"DEPARTMENT", "EMPLOYEE", "NOTICE", "BOARD", "BOARD_COMMENT",
			"APPROVAL", "SCHEDULE", "ROOM", "ROOM_RESERVE", "ATTENDANCE", "NOTIFICATION"
	};

	public static void main(String[] args) {

		System.out.println("==============================================");
		System.out.println(" InfraLink DB 점검");
		System.out.println("==============================================");

		// -------------------------------------------------------------
		// 1. 설정 파일 확인
		// -------------------------------------------------------------
		if (AppConfig.getLoadError() != null) {
			System.out.println("[1/3] 설정 파일   : 실패");
			System.out.println("      " + AppConfig.getLoadError());
			return;
		}
		System.out.println("[1/3] 설정 파일   : OK");
		System.out.println("      url  = " + AppConfig.get("db.url", "(미설정)"));
		System.out.println("      user = " + AppConfig.get("db.username", "(미설정)"));

		// -------------------------------------------------------------
		// 2. 접속 확인
		// -------------------------------------------------------------
		try (Connection conn = DBManager.getConnection()) {

			System.out.println("[2/3] DB 접속     : OK");
			System.out.println("      " + conn.getMetaData().getDatabaseProductName()
					+ " " + conn.getMetaData().getDatabaseProductVersion());

			// ---------------------------------------------------------
			// 3. 스키마 설치 여부 확인
			// ---------------------------------------------------------
			System.out.println("[3/3] 스키마 확인 :");

			String sql = "SELECT COUNT(*) FROM user_tables WHERE table_name = ?";
			int missing = 0;

			for (String table : REQUIRED_TABLES) {
				try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
					pstmt.setString(1, table);
					try (ResultSet rs = pstmt.executeQuery()) {
						boolean exists = rs.next() && rs.getInt(1) > 0;
						System.out.println("      " + (exists ? "  OK  " : " 없음 ") + " " + table);
						if (!exists) {
							missing++;
						}
					}
				}
			}

			if (missing > 0) {
				System.out.println();
				System.out.println("  → 누락된 테이블이 " + missing + "개 있습니다.");
				System.out.println("    db/01_schema.sql 과 db/02_sample_data.sql 을 실행하세요.");
			} else {
				System.out.println();
				System.out.println("  → 모든 테이블이 정상적으로 설치되어 있습니다.");
			}

		} catch (Exception e) {
			System.out.println("[2/3] DB 접속     : 실패");
			System.out.println("      " + e.getClass().getSimpleName() + " : " + e.getMessage());
			System.out.println();
			System.out.println("  확인할 것");
			System.out.println("   1) 오라클 서비스(OracleServiceXE)가 실행 중인가");
			System.out.println("   2) db.properties 의 계정/비밀번호가 맞는가");
			System.out.println("   3) WEB-INF/lib 에 ojdbc jar 이 있고 빌드패스에 추가되어 있는가");
		}

		System.out.println("==============================================");
	}
}
