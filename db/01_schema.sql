-- =====================================================================
-- InfraLink 사내 인트라넷 - 테이블/시퀀스 생성 스크립트 (Oracle)
-- ---------------------------------------------------------------------
-- [신규 생성] 2026-09-07
--   기존 저장소에는 DDL 이 한 줄도 없어서, 코드가 참조하는 테이블
--   (employee / department / notice, emp_id_seq / notice_seq)을
--   다른 사람이 재현할 방법이 없었다.
--   → 기존 코드가 쓰던 테이블 + 이번에 새로 구현한 기능의 테이블을
--     전부 이 파일 하나로 만들 수 있게 정리했다.
--
-- 실행 방법 (SQL*Plus / SQL Developer 에서 infralink 계정으로 접속 후)
--   @db/01_schema.sql
--   @db/02_sample_data.sql
--
-- 주의 : 아래 DROP 문은 기존 데이터를 모두 지웁니다.
--        최초 1회 설치가 아니라면 DROP 구간을 건너뛰세요.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. 기존 객체 삭제 (없으면 에러가 나지만 무시하고 진행됨)
--    자식 → 부모 순서로 지운다.
-- ---------------------------------------------------------------------
DROP TABLE notification      CASCADE CONSTRAINTS;
DROP TABLE attendance        CASCADE CONSTRAINTS;
DROP TABLE room_reserve      CASCADE CONSTRAINTS;
DROP TABLE room              CASCADE CONSTRAINTS;
DROP TABLE schedule          CASCADE CONSTRAINTS;
DROP TABLE approval          CASCADE CONSTRAINTS;
DROP TABLE board_comment     CASCADE CONSTRAINTS;
DROP TABLE board            CASCADE CONSTRAINTS;
DROP TABLE notice            CASCADE CONSTRAINTS;
DROP TABLE employee          CASCADE CONSTRAINTS;
DROP TABLE department        CASCADE CONSTRAINTS;

DROP SEQUENCE emp_id_seq;
DROP SEQUENCE notice_seq;
DROP SEQUENCE board_seq;
DROP SEQUENCE comment_seq;
DROP SEQUENCE approval_seq;
DROP SEQUENCE schedule_seq;
DROP SEQUENCE reserve_seq;
DROP SEQUENCE attendance_seq;
DROP SEQUENCE notification_seq;


-- =====================================================================
-- 1. 부서 (department)
-- =====================================================================
CREATE TABLE department (
    dept_code   VARCHAR2(10)  NOT NULL,   -- 부서 코드 (사번 앞자리로도 사용)
    dept_name   VARCHAR2(60)  NOT NULL,   -- 부서명
    sort_order  NUMBER(3)     DEFAULT 99, -- 화면 정렬 순서
    CONSTRAINT pk_department PRIMARY KEY (dept_code)
);
COMMENT ON TABLE  department            IS '부서 마스터';
COMMENT ON COLUMN department.dept_code  IS '부서코드 (사번 생성 시 접두어로 사용)';


-- =====================================================================
-- 2. 사원 (employee)
--    - password 는 반드시 BCrypt 해시(60자)를 저장한다. 평문 저장 금지.
--      (평문이 들어 있으면 로그인 시 BCrypt.checkpw 가 예외를 던진다)
-- =====================================================================
CREATE TABLE employee (
    employee_id  VARCHAR2(20)  NOT NULL,   -- 사번 : DEPT-YYYY-NNN 형식
    password     VARCHAR2(100) NOT NULL,   -- BCrypt 해시 (60자, 여유 100)
    emp_name     VARCHAR2(60)  NOT NULL,   -- 성명
    dept_code    VARCHAR2(10),             -- 부서코드 (FK)
    position     VARCHAR2(40),             -- 직위 (사원/주임/대리/과장/부장/이사)
    email        VARCHAR2(120),
    ext_no       VARCHAR2(20),             -- 내선번호
    phone        VARCHAR2(30),
    hire_date    DATE          DEFAULT SYSDATE,
    emp_status   VARCHAR2(20)  DEFAULT '在職',  -- 在職 / 休職 / 退職
    auth_role    VARCHAR2(20)  DEFAULT 'USER',  -- USER / ADMIN
    pwd_reset_yn CHAR(1)       DEFAULT 'Y',     -- Y: 초기비밀번호(변경 필요)
    reg_date     DATE          DEFAULT SYSDATE,
    CONSTRAINT pk_employee     PRIMARY KEY (employee_id),
    CONSTRAINT fk_emp_dept     FOREIGN KEY (dept_code) REFERENCES department (dept_code),
    CONSTRAINT ck_emp_role     CHECK (auth_role IN ('USER', 'ADMIN')),
    CONSTRAINT ck_emp_reset    CHECK (pwd_reset_yn IN ('Y', 'N'))
);
CREATE INDEX ix_employee_name ON employee (emp_name);
CREATE INDEX ix_employee_dept ON employee (dept_code);

COMMENT ON TABLE  employee              IS '사원 마스터';
COMMENT ON COLUMN employee.password     IS 'BCrypt 해시. 평문 저장 절대 금지';
COMMENT ON COLUMN employee.pwd_reset_yn IS 'Y = 초기 비밀번호 상태(최초 로그인 시 변경 유도)';


-- =====================================================================
-- 3. 공지사항 (notice)
-- =====================================================================
CREATE TABLE notice (
    notice_no    NUMBER(10)    NOT NULL,
    employee_id  VARCHAR2(20),             -- 작성자 (FK)
    category     VARCHAR2(30)  DEFAULT '一般',   -- 一般/人事/総務/IT/緊急
    visibility   VARCHAR2(30)  DEFAULT 'ALL',    -- ALL / DEPT
    title        VARCHAR2(300) NOT NULL,
    content      CLOB,
    file_path    VARCHAR2(300),            -- 저장된 파일명 (UUID_원본명)
    file_name    VARCHAR2(300),            -- 사용자에게 보여줄 원본 파일명
    read_count   NUMBER(10)    DEFAULT 0,
    pin_yn       CHAR(1)       DEFAULT 'N',-- Y : 목록 상단 고정
    reg_date     DATE          DEFAULT SYSDATE,
    upd_date     DATE,
    CONSTRAINT pk_notice     PRIMARY KEY (notice_no),
    CONSTRAINT fk_notice_emp FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT ck_notice_pin CHECK (pin_yn IN ('Y', 'N'))
);
CREATE INDEX ix_notice_reg ON notice (reg_date DESC);
COMMENT ON TABLE notice IS '공지사항';


-- =====================================================================
-- 4. 자유게시판 (board) + 댓글 (board_comment)
--    [신규] 기존에는 화면(board-*.jsp)만 있고 테이블/DAO 가 없었다.
-- =====================================================================
CREATE TABLE board (
    board_no     NUMBER(10)    NOT NULL,
    employee_id  VARCHAR2(20),
    category     VARCHAR2(30)  DEFAULT '自由',   -- 自由/質問/情報/サークル
    title        VARCHAR2(300) NOT NULL,
    content      CLOB,
    file_path    VARCHAR2(300),
    file_name    VARCHAR2(300),
    read_count   NUMBER(10)    DEFAULT 0,
    reg_date     DATE          DEFAULT SYSDATE,
    upd_date     DATE,
    CONSTRAINT pk_board     PRIMARY KEY (board_no),
    CONSTRAINT fk_board_emp FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);
CREATE INDEX ix_board_reg ON board (reg_date DESC);

CREATE TABLE board_comment (
    comment_no   NUMBER(10)    NOT NULL,
    board_no     NUMBER(10)    NOT NULL,
    employee_id  VARCHAR2(20),
    content      VARCHAR2(2000) NOT NULL,
    reg_date     DATE          DEFAULT SYSDATE,
    CONSTRAINT pk_comment       PRIMARY KEY (comment_no),
    -- 게시글이 지워지면 댓글도 함께 삭제
    CONSTRAINT fk_comment_board FOREIGN KEY (board_no) REFERENCES board (board_no) ON DELETE CASCADE,
    CONSTRAINT fk_comment_emp   FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);
CREATE INDEX ix_comment_board ON board_comment (board_no);


-- =====================================================================
-- 5. 전자결재 (approval)
--    [신규] ApprovalDTO 만 있고 테이블/DAO 가 없었다.
-- =====================================================================
CREATE TABLE approval (
    approval_no  NUMBER(10)    NOT NULL,
    employee_id  VARCHAR2(20)  NOT NULL,   -- 기안자
    approval_id  VARCHAR2(20),             -- 결재자 (ApprovalDTO 의 approval_id)
    doc_type     VARCHAR2(40)  NOT NULL,   -- 休暇申請/経費精算/購買稟議/出張申請
    doc_title    VARCHAR2(300) NOT NULL,
    content      CLOB,
    status       VARCHAR2(20)  DEFAULT '待機',  -- 待機/承認/却下/回収
    req_date     DATE          DEFAULT SYSDATE, -- 기안일
    proc_date    DATE,                          -- 처리일
    proc_comment VARCHAR2(1000),                -- 결재 의견
    CONSTRAINT pk_approval       PRIMARY KEY (approval_no),
    CONSTRAINT fk_approval_emp   FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT fk_approval_appr  FOREIGN KEY (approval_id) REFERENCES employee (employee_id),
    CONSTRAINT ck_approval_state CHECK (status IN ('待機', '承認', '却下', '回収'))
);
CREATE INDEX ix_approval_emp  ON approval (employee_id);
CREATE INDEX ix_approval_appr ON approval (approval_id, status);


-- =====================================================================
-- 6. 일정 (schedule)
--    [신규] ScheduleDTO 만 있고 테이블/DAO 가 없었다.
-- =====================================================================
CREATE TABLE schedule (
    schedule_no  NUMBER(10)    NOT NULL,
    employee_id  VARCHAR2(20)  NOT NULL,
    title        VARCHAR2(300) NOT NULL,
    content      VARCHAR2(2000),
    start_time   DATE          NOT NULL,   -- 시작 일시
    end_time     DATE,                     -- 종료 일시
    location     VARCHAR2(200),            -- 장소 또는 회의 URL
    visibility   VARCHAR2(20)  DEFAULT 'PRIVATE', -- PRIVATE/DEPT/ALL
    reg_date     DATE          DEFAULT SYSDATE,
    CONSTRAINT pk_schedule       PRIMARY KEY (schedule_no),
    CONSTRAINT fk_schedule_emp   FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT ck_schedule_vis   CHECK (visibility IN ('PRIVATE', 'DEPT', 'ALL')),
    -- 종료가 시작보다 빠를 수 없다
    CONSTRAINT ck_schedule_time  CHECK (end_time IS NULL OR end_time >= start_time)
);
CREATE INDEX ix_schedule_time ON schedule (start_time);


-- =====================================================================
-- 7. 회의실 (room) / 회의실 예약 (room_reserve)
--    [신규] Room_ReserveDTO 만 있고 테이블/DAO 가 없었다.
-- =====================================================================
CREATE TABLE room (
    room_code   VARCHAR2(20)  NOT NULL,
    room_name   VARCHAR2(60)  NOT NULL,
    capacity    NUMBER(4)     DEFAULT 0,   -- 수용 인원
    location    VARCHAR2(100),             -- 층/위치
    equipment   VARCHAR2(200),             -- 비치 장비
    use_yn      CHAR(1)       DEFAULT 'Y',
    CONSTRAINT pk_room     PRIMARY KEY (room_code),
    CONSTRAINT ck_room_use CHECK (use_yn IN ('Y', 'N'))
);

CREATE TABLE room_reserve (
    reserve_no    NUMBER(10)   NOT NULL,
    room_code     VARCHAR2(20) NOT NULL,
    employee_id   VARCHAR2(20) NOT NULL,
    meeting_title VARCHAR2(300) NOT NULL,
    attendees     VARCHAR2(500),           -- 참석자 메모
    start_time    DATE         NOT NULL,
    end_time      DATE         NOT NULL,
    status        VARCHAR2(20) DEFAULT '予約',  -- 予約 / 取消
    reg_date      DATE         DEFAULT SYSDATE,
    CONSTRAINT pk_reserve       PRIMARY KEY (reserve_no),
    CONSTRAINT fk_reserve_room  FOREIGN KEY (room_code)   REFERENCES room (room_code),
    CONSTRAINT fk_reserve_emp   FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT ck_reserve_state CHECK (status IN ('予約', '取消')),
    CONSTRAINT ck_reserve_time  CHECK (end_time > start_time)
);
-- 예약 중복 검사(같은 회의실/시간대)를 자주 하므로 인덱스를 건다.
CREATE INDEX ix_reserve_room_time ON room_reserve (room_code, start_time, end_time);


-- =====================================================================
-- 8. 근태 (attendance)
--    [신규] 화면(attendance.jsp)만 있고 테이블이 없었다.
--    - 사원 1명당 하루 1건 (UNIQUE) : 중복 출근 등록 방지
-- =====================================================================
CREATE TABLE attendance (
    att_no       NUMBER(10)   NOT NULL,
    employee_id  VARCHAR2(20) NOT NULL,
    work_date    DATE         NOT NULL,   -- 날짜(시간 제외, TRUNC 된 값 저장)
    in_time      DATE,                    -- 출근 시각
    out_time     DATE,                    -- 퇴근 시각
    work_type    VARCHAR2(20) DEFAULT '出勤', -- 出勤/在宅/出張/休暇
    note         VARCHAR2(300),
    CONSTRAINT pk_attendance   PRIMARY KEY (att_no),
    CONSTRAINT fk_att_emp      FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT uq_att_emp_date UNIQUE (employee_id, work_date)
);


-- =====================================================================
-- 9. 알림 (notification)
--    [신규] 화면(notifications.jsp)만 있고 테이블이 없었다.
-- =====================================================================
CREATE TABLE notification (
    noti_no      NUMBER(10)   NOT NULL,
    employee_id  VARCHAR2(20) NOT NULL,   -- 수신자
    noti_type    VARCHAR2(30) DEFAULT 'SYSTEM', -- NOTICE/BOARD/APPROVAL/ROOM/SYSTEM
    title        VARCHAR2(300) NOT NULL,
    url          VARCHAR2(300),           -- 클릭 시 이동할 경로
    read_yn      CHAR(1)      DEFAULT 'N',
    reg_date     DATE         DEFAULT SYSDATE,
    CONSTRAINT pk_notification PRIMARY KEY (noti_no),
    CONSTRAINT fk_noti_emp     FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT ck_noti_read    CHECK (read_yn IN ('Y', 'N'))
);
CREATE INDEX ix_noti_emp ON notification (employee_id, read_yn);


-- =====================================================================
-- 10. 시퀀스
--     [중요] emp_id_seq 는 NOCACHE 로 만든다.
--       기존 코드는 사번 "미리보기"를 user_sequences.last_number 로 읽었는데,
--       CACHE 가 걸려 있으면 last_number 는 캐시로 선점한 최대값이라
--       실제 발급될 번호와 어긋난다. (예: CACHE 20 → 첫 조회부터 21)
--       미리보기 정확도를 위해 NOCACHE 로 만들고,
--       애플리케이션에서도 last_number 대신 MAX(사번) 기반으로 계산한다.
-- =====================================================================
CREATE SEQUENCE emp_id_seq       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE notice_seq       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE board_seq        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE comment_seq      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE approval_seq     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE schedule_seq     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE reserve_seq      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE attendance_seq   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE notification_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

COMMIT;

-- =====================================================================
-- 설치 확인
-- =====================================================================
SELECT table_name FROM user_tables ORDER BY table_name;
