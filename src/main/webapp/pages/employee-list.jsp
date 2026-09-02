<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員検索 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="employee">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>
<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-people"></i> 社員検索</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">社員検索</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <!-- ==================== 검색 필터 ==================== -->
        <form class="filter-bar" id="employeeSearchForm">
          <select class="form-select form-select-sm" style="width:150px;">
            <option selected>全部署</option>
            <option>経営企画部</option>
            <option>人事部</option>
            <option>総務部</option>
            <option>開発部</option>
            <option>営業部</option>
          </select>
          <select class="form-select form-select-sm" style="width:130px;">
            <option selected>全職級</option>
            <option>部長</option>
            <option>課長</option>
            <option>主任</option>
            <option>一般社員</option>
          </select>
          <div class="input-group input-group-sm ms-auto" style="max-width:260px;">
            <input type="text" class="form-control" placeholder="名前で検索" name="keyword">
            <button class="btn btn-teal" type="submit"><i class="bi bi-search"></i></button>
          </div>
        </form>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-people"></i> 社員一覧</h5>
            <span class="text-muted" style="font-size:.8rem;">全 128名</span>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:90px;" class="text-center">写真</th>
                  <th>氏名</th>
                  <th>部署</th>
                  <th>役職</th>
                  <th>内線</th>
                  <th>メール</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="text-center"><div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">山</div></td>
                  <td><a href="employee-detail.html?id=1" class="title-link">山田 太郎</a></td>
                  <td>経営企画部</td>
                  <td>部長</td>
                  <td>101</td>
                  <td>t.yamada@infralink.co.jp</td>
                </tr>
                <tr>
                  <td class="text-center"><div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">佐</div></td>
                  <td><a href="employee-detail.html?id=2" class="title-link">佐藤 花子</a></td>
                  <td>開発部</td>
                  <td>課長</td>
                  <td>212</td>
                  <td>h.sato@infralink.co.jp</td>
                </tr>
                <tr>
                  <td class="text-center"><div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">鈴</div></td>
                  <td><a href="employee-detail.html?id=3" class="title-link">鈴木 一郎</a></td>
                  <td>営業部</td>
                  <td>主任</td>
                  <td>305</td>
                  <td>i.suzuki@infralink.co.jp</td>
                </tr>
                <tr>
                  <td class="text-center"><div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">田</div></td>
                  <td><a href="employee-detail.html?id=4" class="title-link">田中 誠</a></td>
                  <td>人事部</td>
                  <td>一般社員</td>
                  <td>120</td>
                  <td>m.tanaka@infralink.co.jp</td>
                </tr>
                <tr>
                  <td class="text-center"><div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">高</div></td>
                  <td><a href="employee-detail.html?id=5" class="title-link">高橋 直子</a></td>
                  <td>総務部</td>
                  <td>一般社員</td>
                  <td>130</td>
                  <td>n.takahashi@infralink.co.jp</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="pagination-wrap">
          <ul class="pagination">
            <li class="page-item disabled"><a class="page-link" href="#">前へ</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">次へ</a></li>
          </ul>
        </div>
      </section>
    </div>
  </div>
</div>

<div id="footer-placeholder"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="../js/common.js"></script>
<script src="../js/employee.js"></script>
</body>
<%@ include file="../components/footer.jsp"%>
</html>
