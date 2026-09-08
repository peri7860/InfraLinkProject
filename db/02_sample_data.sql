-- =====================================================================
-- InfraLink 샘플 데이터
-- ---------------------------------------------------------------------
-- [신규 생성] 2026-09-07
--   화면이 대부분 하드코딩 더미였기 때문에, DB 연동으로 바꾼 뒤
--   바로 확인할 수 있도록 실제 데이터를 넣어 둔다.
--
-- 실행 : 01_schema.sql 을 먼저 실행한 뒤 @db/02_sample_data.sql
--
-- ★ 로그인 계정 (비밀번호는 BCrypt 해시로 저장되어 있음)
--   관리자 : ADM-2026-001 / admin1234
--   일반   : DEV-2026-002 / DEV-2026-002   (초기 비밀번호 = 사번)
--            그 외 사원도 "비밀번호 = 사번" 규칙
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. 부서
-- ---------------------------------------------------------------------
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('ADM', '経営企画部', 1);
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('DEV', '開発部',     2);
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('SAL', '営業部',     3);
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('HRM', '人事部',     4);
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('GAF', '総務部',     5);
INSERT INTO department (dept_code, dept_name, sort_order) VALUES ('ITS', 'IT支援部',   6);


-- ---------------------------------------------------------------------
-- 2. 사원
--    password 는 실제 BCrypt 해시 (평문을 넣으면 로그인 시 예외 발생)
-- ---------------------------------------------------------------------
INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('ADM-2026-001', '$2a$10$rWdeOTe2SnY/7dTBP3xLEueaK5anZGc1fNe/lg2S2cH4pd3/LBrfG',
        '山田 太郎', 'ADM', '部長', 't.yamada@infralink.co.jp', '100', '090-1111-0001',
        TO_DATE('2018-04-01', 'YYYY-MM-DD'), '在職', 'ADMIN', 'N');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('DEV-2026-002', '$2a$10$WUB/BKJymbug/RZh29ydqOWzyvTbtZ/xZtKjkVjBS.q2zWMMCbfYO',
        '佐藤 花子', 'DEV', '課長', 'h.sato@infralink.co.jp', '210', '090-1111-0002',
        TO_DATE('2019-07-01', 'YYYY-MM-DD'), '在職', 'USER', 'N');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('DEV-2026-003', '$2a$10$MnRhVhuIIyjBG0DeDjaQLO9feXZnYN4BC1ZDt3pNEYoaHXLsMXnku',
        '鈴木 一郎', 'DEV', '主任', 'i.suzuki@infralink.co.jp', '211', '090-1111-0003',
        TO_DATE('2021-04-01', 'YYYY-MM-DD'), '在職', 'USER', 'N');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('SAL-2026-004', '$2a$10$xz7KPfC3plLZOi7200NVZuBvPK.N2BetV4uNKlu/mebpidSyKkolG',
        '田中 美咲', 'SAL', '代理', 'm.tanaka@infralink.co.jp', '310', '090-1111-0004',
        TO_DATE('2020-10-01', 'YYYY-MM-DD'), '在職', 'USER', 'N');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('SAL-2026-005', '$2a$10$jgNfiDoztlyZwiLEKLTYHOKk3RBhjwjGiuI9vlvBw5Fnh5ns5s6mG',
        '高橋 健', 'SAL', '社員', 'k.takahashi@infralink.co.jp', '311', '090-1111-0005',
        TO_DATE('2023-04-01', 'YYYY-MM-DD'), '在職', 'USER', 'Y');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('HRM-2026-006', '$2a$10$uhP8ppWCHG7GOA.8y5n5w.lhUN71fc8akeMGgcnJK4tw4ZS4AuPHu',
        '伊藤 さくら', 'HRM', '課長', 's.ito@infralink.co.jp', '410', '090-1111-0006',
        TO_DATE('2017-04-01', 'YYYY-MM-DD'), '在職', 'ADMIN', 'N');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('GAF-2026-007', '$2a$10$xKwzxbSrtwImgkZ5ZThIu.dXvNTI7pULf8oy5/dH2ZG3cjSX.T5Xa',
        '渡辺 修', 'GAF', '主任', 'o.watanabe@infralink.co.jp', '510', '090-1111-0007',
        TO_DATE('2022-01-04', 'YYYY-MM-DD'), '在職', 'USER', 'Y');

INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn)
VALUES ('ITS-2026-008', '$2a$10$POAEq9IOHzK4jeB5PeR3t.vix20eekSCZsruVoSQFupiGDMkXuHt2',
        '中村 亮', 'ITS', '社員', 'r.nakamura@infralink.co.jp', '110', '090-1111-0008',
        TO_DATE('2024-04-01', 'YYYY-MM-DD'), '休職', 'USER', 'Y');


-- ---------------------------------------------------------------------
-- 3. 시퀀스를 샘플 데이터 다음 번호로 맞춘다.
--    (사번 8명을 직접 INSERT 했으므로 emp_id_seq 를 8까지 소모시킨다)
-- ---------------------------------------------------------------------
DECLARE
    v_dummy NUMBER;
BEGIN
    FOR i IN 1 .. 8 LOOP
        SELECT emp_id_seq.NEXTVAL INTO v_dummy FROM dual;
    END LOOP;
END;
/


-- ---------------------------------------------------------------------
-- 4. 공지사항
-- ---------------------------------------------------------------------
INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'HRM-2026-006', '人事', 'ALL',
        '2026年 夏季休暇および勤務制度のご案内',
        '2026年度の夏季休暇について下記のとおりご案内いたします。' || CHR(10) ||
        '取得期間: 2026年8月1日 ～ 2026年9月30日' || CHR(10) ||
        '申請方法: 電子決裁 > 休暇申請 から申請してください。',
        128, 'Y', TO_DATE('2026-07-15', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'ITS-2026-008', 'IT', 'ALL',
        '社内システム定期点検のお知らせ（8/16 2:00〜5:00）',
        '下記の日程で社内システムの定期点検を実施します。' || CHR(10) ||
        '点検中はイントラネットをご利用いただけません。',
        96, 'Y', TO_DATE('2026-08-10', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'GAF-2026-007', '総務', 'ALL',
        '第3四半期 社内サークル支援金申請のご案内',
        '第3四半期のサークル支援金の申請を受け付けます。締切は8/31です。',
        54, 'N', TO_DATE('2026-08-05', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'HRM-2026-006', '人事', 'ALL',
        '新入社員オリエンテーション日程のお知らせ',
        '9月入社の新入社員向けオリエンテーションを実施します。',
        41, 'N', TO_DATE('2026-08-20', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'GAF-2026-007', '総務', 'ALL',
        '本社駐車場利用案内の変更事項',
        '9月より本社駐車場の利用ルールが変更となります。',
        33, 'N', TO_DATE('2026-08-25', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'GAF-2026-007', '一般', 'ALL',
        '社内食堂メニュー変更のお知らせ（9月分）',
        '9月の社内食堂メニューを更新しました。',
        27, 'N', TO_DATE('2026-08-28', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'ITS-2026-008', 'IT', 'ALL',
        '社内セキュリティ研修（e-ラーニング）受講案内',
        '全社員必須のセキュリティ研修を9月末までに受講してください。',
        19, 'N', TO_DATE('2026-09-01', 'YYYY-MM-DD'));

INSERT INTO notice (notice_no, employee_id, category, visibility, title, content, read_count, pin_yn, reg_date)
VALUES (notice_seq.NEXTVAL, 'ADM-2026-001', '一般', 'ALL',
        '7月度 優秀社員表彰式のご案内',
        '7月度の優秀社員表彰式を開催します。',
        12, 'N', TO_DATE('2026-09-03', 'YYYY-MM-DD'));


-- ---------------------------------------------------------------------
-- 5. 자유게시판 + 댓글
-- ---------------------------------------------------------------------
INSERT INTO board (board_no, employee_id, category, title, content, read_count, reg_date)
VALUES (board_seq.NEXTVAL, 'DEV-2026-003', '質問',
        'Git のブランチ運用ルールについて質問です',
        '現在のプロジェクトで feature ブランチの命名規則はありますか？', 42,
        TO_DATE('2026-09-01', 'YYYY-MM-DD'));

INSERT INTO board (board_no, employee_id, category, title, content, read_count, reg_date)
VALUES (board_seq.NEXTVAL, 'SAL-2026-004', '情報',
        '営業部おすすめのランチスポットまとめ',
        '本社周辺のおすすめランチをまとめました。', 88,
        TO_DATE('2026-09-02', 'YYYY-MM-DD'));

INSERT INTO board (board_no, employee_id, category, title, content, read_count, reg_date)
VALUES (board_seq.NEXTVAL, 'DEV-2026-002', 'サークル',
        'フットサル部 新メンバー募集中！',
        '毎週水曜19時から活動しています。初心者歓迎です。', 65,
        TO_DATE('2026-09-04', 'YYYY-MM-DD'));

INSERT INTO board_comment (comment_no, board_no, employee_id, content, reg_date)
VALUES (comment_seq.NEXTVAL, 1, 'DEV-2026-002', 'feature/{チケット番号}-{概要} で統一しています。', TO_DATE('2026-09-01', 'YYYY-MM-DD'));

INSERT INTO board_comment (comment_no, board_no, employee_id, content, reg_date)
VALUES (comment_seq.NEXTVAL, 1, 'ITS-2026-008', '補足すると、リリース用は release/ を使います。', TO_DATE('2026-09-02', 'YYYY-MM-DD'));

INSERT INTO board_comment (comment_no, board_no, employee_id, content, reg_date)
VALUES (comment_seq.NEXTVAL, 3, 'SAL-2026-005', '参加希望です！', TO_DATE('2026-09-05', 'YYYY-MM-DD'));


-- ---------------------------------------------------------------------
-- 6. 전자결재
-- ---------------------------------------------------------------------
INSERT INTO approval (approval_no, employee_id, approval_id, doc_type, doc_title, content, status, req_date)
VALUES (approval_seq.NEXTVAL, 'DEV-2026-003', 'DEV-2026-002', '休暇申請',
        '夏季休暇申請（9/14〜9/16）', '夏季休暇を3日間取得したくお願いいたします。', '待機',
        TO_DATE('2026-09-05', 'YYYY-MM-DD'));

INSERT INTO approval (approval_no, employee_id, approval_id, doc_type, doc_title, content, status, req_date, proc_date, proc_comment)
VALUES (approval_seq.NEXTVAL, 'SAL-2026-005', 'SAL-2026-004', '経費精算',
        '8月分 交通費精算', '8月の営業活動にかかる交通費の精算申請です。', '承認',
        TO_DATE('2026-09-01', 'YYYY-MM-DD'), TO_DATE('2026-09-02', 'YYYY-MM-DD'), '確認しました。');

INSERT INTO approval (approval_no, employee_id, approval_id, doc_type, doc_title, content, status, req_date, proc_date, proc_comment)
VALUES (approval_seq.NEXTVAL, 'DEV-2026-002', 'ADM-2026-001', '購買稟議',
        '開発用ノートPC 3台 購入稟議', '開発環境更新のため3台の購入を申請します。', '却下',
        TO_DATE('2026-08-20', 'YYYY-MM-DD'), TO_DATE('2026-08-22', 'YYYY-MM-DD'), '来期予算での再申請をお願いします。');

INSERT INTO approval (approval_no, employee_id, approval_id, doc_type, doc_title, content, status, req_date)
VALUES (approval_seq.NEXTVAL, 'SAL-2026-004', 'ADM-2026-001', '出張申請',
        '大阪支社 出張申請（9/20〜9/21）', '大阪支社との合同会議のため出張します。', '待機',
        TO_DATE('2026-09-06', 'YYYY-MM-DD'));


-- ---------------------------------------------------------------------
-- 7. 일정
-- ---------------------------------------------------------------------
INSERT INTO schedule (schedule_no, employee_id, title, content, start_time, end_time, location, visibility)
VALUES (schedule_seq.NEXTVAL, 'DEV-2026-002', '開発部 定例ミーティング', '週次進捗の共有',
        TO_DATE('2026-09-08 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2026-09-08 11:00', 'YYYY-MM-DD HH24:MI'),
        '第1会議室', 'DEPT');

INSERT INTO schedule (schedule_no, employee_id, title, content, start_time, end_time, location, visibility)
VALUES (schedule_seq.NEXTVAL, 'ADM-2026-001', '全社朝礼', '月初の全社朝礼です。',
        TO_DATE('2026-09-01 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2026-09-01 09:30', 'YYYY-MM-DD HH24:MI'),
        '大会議室', 'ALL');

INSERT INTO schedule (schedule_no, employee_id, title, content, start_time, end_time, location, visibility)
VALUES (schedule_seq.NEXTVAL, 'SAL-2026-004', '顧客訪問（株式会社サンプル）', '新規提案の打ち合わせ',
        TO_DATE('2026-09-10 14:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2026-09-10 16:00', 'YYYY-MM-DD HH24:MI'),
        '先方オフィス', 'PRIVATE');


-- ---------------------------------------------------------------------
-- 8. 회의실 + 예약
-- ---------------------------------------------------------------------
INSERT INTO room (room_code, room_name, capacity, location, equipment) VALUES ('R101', '第1会議室',  8, '5F', 'プロジェクター / ホワイトボード');
INSERT INTO room (room_code, room_name, capacity, location, equipment) VALUES ('R102', '第2会議室',  6, '5F', 'ホワイトボード');
INSERT INTO room (room_code, room_name, capacity, location, equipment) VALUES ('R201', '大会議室',  30, '6F', 'プロジェクター / 音響設備');
INSERT INTO room (room_code, room_name, capacity, location, equipment) VALUES ('R202', 'ミーティングブースA', 4, '6F', 'モニター');

INSERT INTO room_reserve (reserve_no, room_code, employee_id, meeting_title, attendees, start_time, end_time, status)
VALUES (reserve_seq.NEXTVAL, 'R101', 'DEV-2026-002', '開発部 定例ミーティング', '開発部 全員',
        TO_DATE('2026-09-08 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2026-09-08 11:00', 'YYYY-MM-DD HH24:MI'), '予約');

INSERT INTO room_reserve (reserve_no, room_code, employee_id, meeting_title, attendees, start_time, end_time, status)
VALUES (reserve_seq.NEXTVAL, 'R201', 'ADM-2026-001', '全社朝礼', '全社員',
        TO_DATE('2026-09-08 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2026-09-08 09:30', 'YYYY-MM-DD HH24:MI'), '予約');


-- ---------------------------------------------------------------------
-- 9. 근태 (최근 3일)
-- ---------------------------------------------------------------------
INSERT INTO attendance (att_no, employee_id, work_date, in_time, out_time, work_type)
VALUES (attendance_seq.NEXTVAL, 'DEV-2026-002', TRUNC(SYSDATE) - 2,
        TRUNC(SYSDATE) - 2 + 9/24, TRUNC(SYSDATE) - 2 + 18/24, '出勤');
INSERT INTO attendance (att_no, employee_id, work_date, in_time, out_time, work_type)
VALUES (attendance_seq.NEXTVAL, 'DEV-2026-002', TRUNC(SYSDATE) - 1,
        TRUNC(SYSDATE) - 1 + 8.5/24, TRUNC(SYSDATE) - 1 + 19/24, '在宅');
INSERT INTO attendance (att_no, employee_id, work_date, in_time, out_time, work_type)
VALUES (attendance_seq.NEXTVAL, 'ADM-2026-001', TRUNC(SYSDATE) - 1,
        TRUNC(SYSDATE) - 1 + 8/24, TRUNC(SYSDATE) - 1 + 18/24, '出勤');


-- ---------------------------------------------------------------------
-- 10. 알림
-- ---------------------------------------------------------------------
INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn)
VALUES (notification_seq.NEXTVAL, 'DEV-2026-002', 'APPROVAL', '承認待ちの決裁が1件あります', '/pages/approval.do', 'N');
INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn)
VALUES (notification_seq.NEXTVAL, 'DEV-2026-002', 'NOTICE', '新しいお知らせが登録されました', '/pages/notice.do', 'N');
INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn)
VALUES (notification_seq.NEXTVAL, 'DEV-2026-002', 'ROOM', '会議室の予約が確定しました', '/pages/room.do', 'Y');
INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn)
VALUES (notification_seq.NEXTVAL, 'ADM-2026-001', 'APPROVAL', '承認待ちの決裁が2件あります', '/pages/approval.do', 'N');


COMMIT;

-- =====================================================================
-- 확인
-- =====================================================================
SELECT '부서'   AS gubun, COUNT(*) AS cnt FROM department
UNION ALL SELECT '사원',   COUNT(*) FROM employee
UNION ALL SELECT '공지',   COUNT(*) FROM notice
UNION ALL SELECT '게시판', COUNT(*) FROM board
UNION ALL SELECT '결재',   COUNT(*) FROM approval
UNION ALL SELECT '일정',   COUNT(*) FROM schedule
UNION ALL SELECT '회의실', COUNT(*) FROM room
UNION ALL SELECT '예약',   COUNT(*) FROM room_reserve
UNION ALL SELECT '근태',   COUNT(*) FROM attendance
UNION ALL SELECT '알림',   COUNT(*) FROM notification;
