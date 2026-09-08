# InfraLink — 社内統合業務ポータル

사내 인트라넷 포털. 공지사항 · 자유게시판 · 전자결재 · 일정 · 회의실 예약 ·
근태 · 사원 관리를 한 곳에서 처리합니다.

| | |
|---|---|
| 언어 / 런타임 | Java 17 |
| 서블릿 | Servlet 4.0 (javax.servlet) |
| WAS | Apache Tomcat 9 |
| DB | Oracle XE 11g 이상 |
| 화면 | JSP + JSTL 1.2 + Bootstrap 5.3 |
| 빌드 | Eclipse Dynamic Web Project (별도 빌드 도구 없음) |

---

## 1. 실행 준비

### 1-1. 오라클 계정 생성

`SYSTEM` 계정으로 접속해 애플리케이션용 계정을 만듭니다.

```sql
CREATE USER infralink IDENTIFIED BY infra1234;
GRANT CONNECT, RESOURCE TO infralink;
ALTER USER infralink QUOTA UNLIMITED ON USERS;
```

### 1-2. 스키마 · 샘플 데이터 생성

`infralink` 계정으로 접속한 뒤 **순서대로** 실행합니다.

```sql
@db/01_schema.sql
@db/02_sample_data.sql
```

- `01_schema.sql` — 테이블 11개 + 시퀀스 9개
- `02_sample_data.sql` — 부서 6 · 사원 8 · 공지 8 · 게시글 3 · 결재 4 등

> `01_schema.sql` 맨 앞에 `DROP` 문이 있습니다. 최초 설치가 아니라면 그 구간을 건너뛰세요.

### 1-3. 접속 정보 설정

`src/main/java/db.properties.sample` 을 복사해 `db.properties` 를 만들고 값을 채웁니다.

```properties
db.url=jdbc:oracle:thin:@localhost:1521:xe
db.username=infralink
db.password=infra1234
upload.dir=C:/infralink-upload
```

> `db.properties` 는 `.gitignore` 에 등록되어 있어 Git 에 올라가지 않습니다.
> 계정 정보를 소스에 넣지 마세요.

### 1-4. 라이브러리 확인

`src/main/webapp/WEB-INF/lib` 에 아래 jar 이 있어야 합니다.

| jar | 용도 |
|---|---|
| `ojdbc6.jar` (또는 ojdbc8/11) | 오라클 JDBC 드라이버 |
| `jstl.jar`, `standard.jar` | JSTL 1.2 |
| `jbcrypt-0.4.jar` | 비밀번호 해싱 |
| `gson-2.12.1.jar`, `json-20231013.jar` | JSON 처리 |

---

## 2. 실행

1. Eclipse 에서 프로젝트를 열고 **F5(Refresh)**
2. **Project ▸ Clean… ▸ Clean all projects**
   - 빌드 후 `build/classes/db.properties` 가 생겼는지 확인하세요.
     없으면 설정 파일을 읽지 못합니다.
3. `src/main/java/util/DBTest.java` 우클릭 → **Run As ▸ Java Application**
   - 설정 / 접속 / 스키마 설치 여부를 단계별로 점검합니다.
4. 프로젝트 우클릭 → **Run As ▸ Run on Server** → Apache Tomcat v9.0
5. 브라우저에서 <http://localhost:8080/InfraLinkProject/>

### 로그인 계정 (샘플 데이터 기준)

| 구분 | 사번 | 비밀번호 |
|---|---|---|
| 관리자 | `ADM-2026-001` | `admin1234` |
| 관리자 | `HRM-2026-006` | `HRM-2026-006` |
| 일반 사원 | `DEV-2026-002` | `DEV-2026-002` |

> 신규 등록 사원의 **초기 비밀번호는 사번과 동일**합니다.
> 최초 로그인 시 마이페이지에서 변경하도록 안내됩니다.

---

## 3. 구조

```
src/main/java
├── controler/     프론트 컨트롤러
│   ├── Home.java      루트("/") — 정적 자원 위임 + 메인 화면
│   └── pages.java     "/pages/*" — 라우트 표(Command 47 · View 10)
├── filter/        서블릿 필터 (web.xml 에 순서 지정 등록)
│   ├── EncodingFilter  UTF-8
│   ├── LoginFilter     로그인 확인
│   └── AdminFilter     관리자 권한 확인
├── service/       비즈니스 로직 (Command 인터페이스 구현, 48개)
├── model/         DTO · DAO
└── util/          AppConfig · DBManager · PasswordUtil
                   FileUtil · Paging · RequestUtil
```

### 요청이 지나가는 길

```
요청
 → EncodingFilter (UTF-8)
 → LoginFilter    (미로그인 → 로그인 화면. 정적 자원·공개 경로는 통과)
 → AdminFilter    (/pages/* 중 관리자 경로만 auth_role 확인)
 → pages 서블릿   (라우트 표에서 Command 또는 JSP 결정)
 → Service        (DAO 호출 후 JSP 로 forward, 또는 PRG 리다이렉트)
```

### 라우트 추가하는 법

1. `service/` 에 `Command` 를 구현한 클래스를 만든다
2. `controler/pages.java` 의 `COMMANDS` 에 한 줄 추가한다

```java
COMMANDS.put("/example.do", new ExampleService());
```

관리자 전용이라면 `filter/AdminFilter` 의 `ADMIN_PATHS` 에도 경로를 추가합니다.

---

## 4. 개발 시 주의

### 비밀번호

DB 의 `employee.password` 에는 **반드시 BCrypt 해시(60자)** 만 저장합니다.
평문을 넣으면 `PasswordUtil.checkPassword` 가 `false` 를 반환해 로그인할 수 없습니다.

```java
String hashed = PasswordUtil.hashPassword(plain);
```

### 화면 출력

사용자가 입력한 값은 반드시 `<c:out>` 으로 이스케이프합니다.
`${...}` 로 그대로 출력하면 제목에 `<script>` 를 넣어 저장했을 때 실행됩니다.

### 파일 업로드

- 경로 · 최대 크기 · 허용 확장자는 `db.properties` 에서 관리합니다
- 다운로드는 파일명이 아니라 **글 번호**로 요청합니다 (`download.do?type=notice&no=1`)
  경로 조작(`../../`)을 막기 위해서입니다

### JSP 검증

배포 전에 전체 JSP 를 컴파일해 확인할 수 있습니다.
Tomcat 의 `JspC` 를 쓰며, ant 스텁 5개가 필요합니다
(자세한 절차는 `CHECKLIST.md` 참고).

---

## 5. 미구현

| 기능 | 상태 |
|---|---|
| 메신저 | 화면만 존재. 실시간 통신(WebSocket) 서버가 필요해 범위 밖으로 판단 |
| 관리자 활동 로그 | 화면만 존재. 감사 로그 테이블 미설계 |
| 역할/결재 규칙 관리 | 화면만 존재. `auth_role` 2단계(USER/ADMIN)로만 운영 중 |

---

## 6. 참고

- 수정 이력과 남은 작업은 [CHECKLIST.md](CHECKLIST.md) 를 보세요.
- 2026-09-07 정비 이전의 원본은 `_backup_original_20260907/` 에 있습니다
  (Git 추적 제외).
