package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DB 커넥션 관리 클래스.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 계정/비밀번호가 소스에 하드코딩 ("infralink" / "infra1234")
 *     → Git 에 올라가면 그대로 유출
 *  2) 드라이버 클래스가 oracle.jdbc.driver.OracleDriver (deprecated)
 *  3) 접속 실패 시 e.printStackTrace() 만 하고 null 을 반환
 *     → 호출한 DAO 에서 conn.prepareStatement() 하는 순간 NPE 로 터지는데
 *       정작 로그에는 "왜 못 붙었는지"가 묻혀버린다.
 *  4) 드라이버를 매번 Class.forName() 으로 로딩
 *
 * 변경 후
 *  1) 접속 정보를 db.properties (AppConfig) 로 분리
 *  2) 드라이버명도 설정값으로. 기본값은 oracle.jdbc.OracleDriver
 *  3) 실패 시 RuntimeException 으로 명확히 던진다.
 *     (DAO 는 try-with-resources 로 감싸므로 원인이 로그에 그대로 남는다)
 *  4) 드라이버 로딩은 static 블록에서 1회만
 *
 * 하위 호환
 *  - 기존 코드가 쓰던 getInstance() / close(...) 메서드는 그대로 남겨두었다.
 *    (@Deprecated 로 표시만 해두고 동작은 동일)
 * </pre>
 */
public class DBManager {

	/** 드라이버 로딩은 클래스 최초 사용 시 1회만 수행한다. */
	static {
		String driver = AppConfig.get("db.driver", "oracle.jdbc.OracleDriver");
		try {
			Class.forName(driver);
			System.out.println("[DBManager] JDBC 드라이버 로딩 완료 : " + driver);
		} catch (ClassNotFoundException e) {
			// ojdbc jar 이 WEB-INF/lib 에 없을 때 여기로 온다.
			System.err.println("[DBManager] JDBC 드라이버를 찾을 수 없습니다 : " + driver
					+ " / WEB-INF/lib 에 ojdbc jar 이 있는지 확인하세요.");
		}
	}

	private DBManager() {
	}

	/**
	 * 새 커넥션을 반환한다.
	 *
	 * <p>
	 * 반드시 try-with-resources 로 사용할 것.
	 * </p>
	 *
	 * <pre>
	 * try (Connection conn = DBManager.getConnection();
	 *      PreparedStatement pstmt = conn.prepareStatement(sql)) { ... }
	 * </pre>
	 *
	 * @throws SQLException 접속 실패 시 (호출부에서 처리하거나 그대로 전파)
	 */
	public static Connection getConnection() throws SQLException {

		String url = AppConfig.get("db.url", "jdbc:oracle:thin:@localhost:1521:xe");
		String user = AppConfig.get("db.username", "infralink");
		String password = AppConfig.get("db.password", "");

		return DriverManager.getConnection(url, user, password);
	}

	/**
	 * 기존 코드 호환용 메서드.
	 *
	 * @deprecated 예외를 삼키고 null 을 반환하는 구조라 원인 추적이 어렵다.
	 *             신규 코드는 {@link #getConnection()} 을 쓸 것.
	 */
	@Deprecated
	public static Connection getInstance() {
		try {
			return getConnection();
		} catch (SQLException e) {
			System.err.println("[DBManager] DB 접속 실패 : " + e.getMessage());
			return null;
		}
	}

	// =================================================================
	// 자원 반납
	//  - try-with-resources 를 쓰면 아래 메서드는 필요 없지만,
	//    기존 DAO 호환을 위해 남겨 둔다.
	// =================================================================

	/** PreparedStatement + Connection 닫기 */
	public static void close(PreparedStatement pstmt, Connection conn) {
		close(null, pstmt, conn);
	}

	/** ResultSet + PreparedStatement + Connection 닫기 */
	public static void close(ResultSet rs, Statement stmt, Connection conn) {
		// 각각 별도 try 로 감싼다.
		// (하나가 실패해도 나머지는 반드시 닫히도록. 기존 코드는 하나로 묶여 있어서
		//  rs.close() 가 실패하면 conn 이 영영 반납되지 않았다 → 커넥션 누수)
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				System.err.println("[DBManager] ResultSet close 실패 : " + e.getMessage());
			}
		}
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				System.err.println("[DBManager] Statement close 실패 : " + e.getMessage());
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				System.err.println("[DBManager] Connection close 실패 : " + e.getMessage());
			}
		}
	}

	/**
	 * 트랜잭션 롤백 (예외를 삼키지 않고 로그만 남긴다).
	 * 여러 테이블을 함께 갱신하는 DAO 에서 사용한다.
	 */
	public static void rollback(Connection conn) {
		if (conn != null) {
			try {
				conn.rollback();
			} catch (SQLException e) {
				System.err.println("[DBManager] rollback 실패 : " + e.getMessage());
			}
		}
	}

	/** autoCommit 을 원복하고 커넥션을 닫는다. (트랜잭션 처리 후 finally 용) */
	public static void closeWithAutoCommit(Connection conn) {
		if (conn != null) {
			try {
				conn.setAutoCommit(true);
			} catch (SQLException e) {
				System.err.println("[DBManager] autoCommit 복구 실패 : " + e.getMessage());
			}
			try {
				conn.close();
			} catch (SQLException e) {
				System.err.println("[DBManager] Connection close 실패 : " + e.getMessage());
			}
		}
	}
}
