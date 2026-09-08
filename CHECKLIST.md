# InfraLink 수정 체크리스트

> 작성 2026-09-07 / 원본 백업 위치 : `_backup_original_20260907/` (123개 파일 전량)
> 진행 표기 : `[x]` 완료 · `[ ]` 미완료

---

## 0. 사전 작업

- [x] 원본 전체 백업 (`_backup_original_20260907/`)
- [x] 웹 루트에 노출돼 있던 zip 6개 삭제 (`pages.zip`, `components.zip`, `index.zip`, `pages (2).zip` 등)
- [x] 웹 루트의 중복 `webapp/lib/ojdbc6.jar` 삭제 (브라우저로 다운로드 가능했음)
- [x] 사용하지 않는 `(필요없음)register.jsp` 삭제
- [x] 오래된 빌드 산출물 `build/classes` 삭제

---

## A. 실행 시 즉시 터지던 버그 (500)

- [x] `pages.java` — `getPathInfo()` null 일 때 `switch(null)` NPE
- [x] `pages.java` — `/system-status.do` 가 없는 JSP 를 가리킴
- [x] `pages.java` — `/webapp/index.jsp` 잘못된 경로 (`index.java` 는 삭제)
- [x] `NoticeDAO.updateNotice()` — **if/else 가 서로 뒤바뀐 버그** 수정
- [x] `pages` 서블릿에 `@MultipartConfig` 없어 `getPart()` 가 예외
- [x] `ChangePasswordService` / `UpdateMyInfoService` — `loginUser` null 체크 추가
- [x] `PasswordUtil.checkPassword()` — bcrypt 아닌 값에도 예외 대신 false 반환

## B. 만들어놓고 화면에 연결 안 된 기능

- [x] 로그인 서비스 (`LoginService` 재작성 — 검증·세션 재발급·PRG)
- [x] 로그아웃 (`LogoutService` **신규**)
- [x] 마이페이지 조회 (`MyPageService` **신규**)
- [x] 개인정보 수정 (`UpdateMyInfoService` 재작성)
- [x] 비밀번호 변경 (`ChangePasswordService` 재작성 — 정책 검사 추가)
- [x] 공지 등록 (`NoticeInsertService` 재작성 — 세션 키 오류·업로드·리다이렉트 경로 수정)
- [x] 사원 수정 (`EmployeeUpdateService` **신규** — 기존엔 수정이 신규 INSERT 였음)
- [x] 사원 편집 폼 데이터 바인딩 (`EmployeeEditService` 재작성)
- [x] `login.jsp` 실제 폼으로 교체 (POST · name 속성 · 오류 메시지)
- [ ] 나머지 JSP 연결 (mypage.jsp, notice-write.jsp 폼 · JS 수정)

## C. 라우팅 / 링크

- [x] `admin-approval-rules.do` 라우트 누락 (404) — 2곳
- [ ] `board-*.jsp` 의 `.html` 링크 7곳
- [ ] `index.jsp:214` 검색 폼 action (`/pages/employee-list.html`)
- [ ] `notice-view.do` 링크 15곳에 `?no=` 파라미터 추가
- [ ] JSP 31개의 `../css/` 상대경로 → `${pageContext.request.contextPath}` 통일

## D. 로그인 / 권한 / 보안

- [x] `LoginFilter` — 미로그인 접근 차단 (web.xml 에 순서 지정 등록)
- [x] `AdminFilter` — `auth_role=ADMIN` 확인
- [x] 세션 고정 공격 방어 (로그인 시 세션 재발급 — `RequestUtil.setLoginUser`)
- [x] 세션에 비밀번호 해시를 넣지 않도록 제거
- [ ] XSS — EL 출력을 `<c:out>` 로 이스케이프
- [x] DB 계정 하드코딩 제거 → `db.properties` 외부화 (`AppConfig`)
- [x] 업로드 경로 하드코딩(`C:\upload2`) 제거 + 확장자 화이트리스트 + 용량 제한 (`FileUtil`)
- [x] 첨부파일 다운로드 시 경로 조작 차단 (파일명 대신 글번호로 조회 — `FileDownloadService`)
- [x] 초기 비밀번호 정책 (`pwd_reset_yn` — 최초 로그인 시 변경 유도)
- [x] 권한 검사를 DB WHERE 절에도 반영 (남의 글/댓글/결재 조작 차단)

## E. 설정 / 빌드 / 형상관리

- [x] `web.xml` 신규 (welcome-file · 에러페이지 · 세션 타임아웃 · JSP 인코딩)
- [x] `.gitignore` 전면 수정 — **`src/main/java` 전체가 제외돼 있던 문제** 해결
- [x] `db.properties` / `db.properties.sample` 분리
- [x] DB 스키마 `db/01_schema.sql` (테이블 11개 + 시퀀스 9개)
- [x] 샘플 데이터 `db/02_sample_data.sql` (실제 BCrypt 해시 포함)
- [ ] `README.md` (설치·실행 순서)
- [x] 스냅샷 커밋 (로컬 브랜치 `backend-refactor-20260907`, 푸시 안 함)

## F. 코드 품질

- [x] `DBManager` — try-with-resources · 커넥션 누수 · 예외 처리 개선
- [x] `PasswordUtil` — 오타 메서드명(`hashPasswrod`) 정정 + 하위호환 유지
- [x] 모든 DAO try-with-resources 전환
- [x] `AdminDAO` — 사번 미리보기 오류(`user_sequences.last_number`) 수정, 부서·연도별 채번, 충돌 재시도
- [x] 모든 서비스가 `Command` 구현하도록 통일
- [x] ~~패키지 `controler` → `controller`~~ — 사용자 결정으로 **그대로 유지**
- [x] 죽은 서블릿 `index.java` 제거

## G. 화면 (JSP / JS)

- [ ] `footer.jsp` 가 `</body>` 뒤에 include 된 페이지 16개 수정
- [x] `header.jsp` — 세션 사용자 표시 · 로그아웃 링크 연결 · 알림 배지 하드코딩 제거
- [ ] `schedule-write.jsp` 3줄 압축 포맷 정리
- [x] 에러 페이지 4종 신규 (`error-400/403/404/500.jsp`)
- [x] `system-status.jsp` 신규
- [ ] 각 목록/상세 화면 DB 연동 (공지·게시판·결재·일정·회의실·근태·알림·사원)

---

## 신규 구현 기능 (없던 것)

| 모듈 | DTO | DAO | Service | JSP 연결 |
|---|---|---|---|---|
| 사원 (검색·수정·퇴사·비밀번호초기화) | [x] | [x] | [x] | [ ] |
| 공지사항 (목록·상세·작성·수정·삭제·다운로드) | [x] | [x] | [x] | [ ] |
| 자유게시판 + 댓글 | [x] | [x] | [x] | [ ] |
| 전자결재 (기안·승인·반려·회수) | [x] | [x] | [x] | [ ] |
| 일정 (월간·상세·등록·수정·삭제) | [x] | [x] | [x] | [ ] |
| 회의실 예약 (중복검사 포함) | [x] | [x] | [x] | [ ] |
| 근태 (출퇴근·월간통계) | [x] | [x] | [x] | [ ] |
| 알림 (DB 기반 읽음처리) | [x] | [x] | [x] | [ ] |
| 부서 / 회의실 마스터 | [x] | [x] | — | [ ] |
| 관리자 대시보드 통계 | — | [x] | [x] | [ ] |
| 메신저 | 미구현 (WebSocket 필요 — 범위 밖으로 판단) | | | |

---

---

## 진행률 (2026-09-07 · 컨트롤러 + 필터 작업 후)

| 계층 | 상태 |
|---|---|
| 설정 · DB 스키마 | 완료 |
| util 공통 | 7 / 7 |
| model DTO · DAO | 21 / 21 |
| service | **48 / 48 완료** |
| **controller · filter** | **완료** — 라우트 52개(Command 35 · View 17) · 필터 3개 |
| JSP · JS | 7 / 42 |

### 검증 결과

- Java 소스 : **69개 / 10,120줄** (원본 23개 / 1,691줄)
- Java 컴파일 : 통과 (`javac -Xlint:all` 무경고)
- **JSP 컴파일 : 42 / 42 통과** (Tomcat `JspC -compile` 로 실제 서블릿 생성까지 확인)
- `web.xml` : well-formed + jsp-config 요소 순서(XSD sequence) 수정 완료
- 라우트 교차검증 : 화면이 참조하는 `.do` 경로 중 미등록 **0건**, 미연결 서비스 **0건**

### 남은 큰 덩어리

1. 서비스 12개 (회의실 4 · 근태 2 · 알림 2 · 일정 2 · 대시보드 1 · 메인 1)
2. JSP 35개 — 하드코딩 데이터를 DB 연동으로 교체
3. JS 5개 — `preventDefault()` 로 막아둔 더미 제출 로직 제거
4. `README.md` · 첫 커밋
