package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 전자결재 DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 ApprovalDTO 만 있고 테이블·DAO·서비스가 전혀 없어서
 *   approval / approval-write / approval-view 화면이 전부 하드코딩이었다.
 *   → approval 테이블과 함께 새로 구현했다.
 *
 * 상태 흐름
 *   待機(대기) ──승인──▶ 承認
 *          └──반려──▶ 却下
 *          └──회수──▶ 回収   (기안자가 직접 취소)
 * </pre>
 */
public class ApprovalDAO {

	/** 결재 상태 상수 (문자열 오타를 막기 위해 상수로 관리) */
	public static final String STATUS_WAITING = "待機";
	public static final String STATUS_APPROVED = "承認";
	public static final String STATUS_REJECTED = "却下";
	public static final String STATUS_WITHDRAWN = "回収";

	private static final String SELECT_COLUMNS =
			"  a.approval_no, a.employee_id, a.approval_id, a.doc_type, a.doc_title, a.status, "
			+ "TO_CHAR(a.req_date,  'YYYY-MM-DD') AS req_date, "
			+ "TO_CHAR(a.proc_date, 'YYYY-MM-DD') AS proc_date, "
			+ "a.proc_comment, "
			+ "e.emp_name, d.dept_name, ap.emp_name AS approver_name ";

	private static final String FROM_JOIN =
			"FROM approval a "
			+ "  LEFT JOIN employee   e  ON a.employee_id = e.employee_id "
			+ "  LEFT JOIN department d  ON e.dept_code   = d.dept_code "
			+ "  LEFT JOIN employee   ap ON a.approval_id = ap.employee_id ";

	private ApprovalDTO mapRow(ResultSet rs) throws SQLException {

		ApprovalDTO dto = new ApprovalDTO();

		dto.setApproval_no(rs.getInt("approval_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setApproval_id(rs.getString("approval_id"));
		dto.setDoc_type(rs.getString("doc_type"));
		dto.setDoc_title(rs.getString("doc_title"));
		dto.setStatus(rs.getString("status"));
		dto.setReq_date(rs.getString("req_date"));
		dto.setProc_date(rs.getString("proc_date"));
		dto.setProc_comment(rs.getString("proc_comment"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));
		dto.setApprover_name(rs.getString("approver_name"));

		return dto;
	}

	// =================================================================
	// 기안
	// =================================================================

	/** 결재 문서 기안 */
	public int insertApproval(ApprovalDTO dto) {

		String sql = "INSERT INTO approval "
				+ "(approval_no, employee_id, approval_id, doc_type, doc_title, content, status, req_date) "
				+ "VALUES (approval_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getEmployee_id());
			pstmt.setString(2, dto.getApproval_id());
			pstmt.setString(3, dto.getDoc_type());
			pstmt.setString(4, dto.getDoc_title());
			pstmt.setString(5, dto.getContent());
			pstmt.setString(6, STATUS_WAITING);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] insertApproval 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 조회
	// =================================================================

	/** 결재 문서 1건 (본문 포함) */
	public ApprovalDTO selectByNo(int approvalNo) {

		String sql = "SELECT " + SELECT_COLUMNS + ", a.content " + FROM_JOIN
				+ "WHERE a.approval_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, approvalNo);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					ApprovalDTO dto = mapRow(rs);
					dto.setContent(rs.getString("content"));
					return dto;
				}
			}

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] selectByNo 실패 : " + e.getMessage());
		}
		return null;
	}

	/**
	 * 결재 문서 목록 (검색 + 페이징).
	 *
	 * @param employeeId 기안자 사번 (내가 올린 문서만 볼 때)
	 * @param approverId 결재자 사번 (내가 결재할 문서만 볼 때)
	 * @param status     상태 필터 (null 이면 전체)
	 */
	public List<ApprovalDTO> selectApprovalPage(String employeeId, String approverId,
			String status, int startRow, int endRow) {

		List<ApprovalDTO> list = new ArrayList<>();
		List<Object> params = new ArrayList<>();
		String where = buildWhere(employeeId, approverId, status, params);

		String sql = "SELECT * FROM ( "
				+ "  SELECT ROWNUM rn, x.* FROM ( "
				+ "    SELECT " + SELECT_COLUMNS + FROM_JOIN + where
				+ "    ORDER BY a.approval_no DESC "
				+ "  ) x WHERE ROWNUM <= ? "
				+ ") WHERE rn >= ?";

		params.add(endRow);
		params.add(startRow);

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			bind(pstmt, params);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] selectApprovalPage 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 목록 전체 건수 */
	public int countApproval(String employeeId, String approverId, String status) {

		List<Object> params = new ArrayList<>();
		String where = buildWhere(employeeId, approverId, status, params);

		String sql = "SELECT COUNT(*) " + FROM_JOIN + where;

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			bind(pstmt, params);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] countApproval 실패 : " + e.getMessage());
		}
		return 0;
	}

	/**
	 * 내가 결재해야 할 대기 문서 수.
	 * 헤더의 알림 배지 / 대시보드 위젯에서 사용한다.
	 */
	public int countWaitingForApprover(String approverId) {
		return countApproval(null, approverId, STATUS_WAITING);
	}

	// =================================================================
	// 결재 처리
	// =================================================================

	/**
	 * 승인 / 반려 처리.
	 *
	 * <pre>
	 * WHERE 절에 approval_id 와 status='待機' 를 함께 넣는 이유
	 *  1) 지정된 결재자가 아닌 사람이 URL 로 직접 호출해도 처리되지 않는다.
	 *  2) 이미 처리된 문서를 두 번 처리하는 것을 막는다(중복 클릭 방어).
	 * → 처리 건수가 0 이면 "권한 없음 또는 이미 처리됨" 으로 판단하면 된다.
	 * </pre>
	 *
	 * @param newStatus {@link #STATUS_APPROVED} 또는 {@link #STATUS_REJECTED}
	 */
	public int processApproval(int approvalNo, String approverId, String newStatus, String comment) {

		String sql = "UPDATE approval "
				+ "SET status = ?, proc_date = SYSDATE, proc_comment = ? "
				+ "WHERE approval_no = ? AND approval_id = ? AND status = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, newStatus);
			pstmt.setString(2, comment);
			pstmt.setInt(3, approvalNo);
			pstmt.setString(4, approverId);
			pstmt.setString(5, STATUS_WAITING);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] processApproval 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 기안자의 문서 회수 (대기 상태일 때만 가능).
	 */
	public int withdraw(int approvalNo, String employeeId) {

		String sql = "UPDATE approval SET status = ?, proc_date = SYSDATE "
				+ "WHERE approval_no = ? AND employee_id = ? AND status = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, STATUS_WITHDRAWN);
			pstmt.setInt(2, approvalNo);
			pstmt.setString(3, employeeId);
			pstmt.setString(4, STATUS_WAITING);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ApprovalDAO] withdraw 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 내부 헬퍼
	// =================================================================

	private String buildWhere(String employeeId, String approverId, String status, List<Object> params) {

		StringBuilder where = new StringBuilder(" WHERE 1 = 1 ");

		if (employeeId != null && !employeeId.trim().isEmpty()) {
			where.append(" AND a.employee_id = ? ");
			params.add(employeeId.trim());
		}
		if (approverId != null && !approverId.trim().isEmpty()) {
			where.append(" AND a.approval_id = ? ");
			params.add(approverId.trim());
		}
		if (status != null && !status.trim().isEmpty()) {
			where.append(" AND a.status = ? ");
			params.add(status.trim());
		}
		return where.toString();
	}

	private void bind(PreparedStatement pstmt, List<Object> params) throws SQLException {

		for (int i = 0; i < params.size(); i++) {
			Object value = params.get(i);
			if (value instanceof Integer) {
				pstmt.setInt(i + 1, (Integer) value);
			} else {
				pstmt.setString(i + 1, String.valueOf(value));
			}
		}
	}
}
