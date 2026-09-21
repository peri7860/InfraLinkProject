<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>InfraLink プロジェクト発表</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;400;500;700;900&family=IBM+Plex+Mono:wght@400;500;600;700&display=swap" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com"></script>
<style>
  :root{
    --ink:#0B0F19;
    --ink-2:#141B29;
    --ink-line: rgba(255,255,255,.09);
    --ink-line-soft: rgba(255,255,255,.15);
    --paper:#EDF0F1;
    --paper-2:#FFFFFF;
    --paper-line: rgba(16,21,31,.07);
    --line:#CBD2D8;
    --line-strong:#3B4656;
    --ink-text:#12161F;
    --slate:#5B6676;
    --slate-light:#9AA5B1;
    --amber:#EFA23C;
    --amber-deep:#B9761E;
    --teal:#2FA98E;
    --bug:#D8574B;
    --guard:#8A6BC9;
  }
  *{ box-sizing:border-box; }
  body{ font-family:'Noto Sans JP',sans-serif; margin:0; padding:0; background:#20242c; }
  .mono{ font-family:'IBM Plex Mono', monospace; }
  .sheet{ width:1280px; height:720px; position:relative; overflow:hidden; display:flex; flex-direction:column; margin:0 auto 28px auto; }
  .sheet-dark{ background:var(--ink); color:#E7EAEE; }
  .sheet-light{ background:var(--paper); color:var(--ink-text); }
  .grid-dark, .grid-light{ position:absolute; inset:0; z-index:0; pointer-events:none; }
  .grid-dark{ background-image:linear-gradient(var(--ink-line) 1px,transparent 1px), linear-gradient(90deg,var(--ink-line) 1px,transparent 1px); background-size:38px 38px; }
  .grid-light{ background-image:linear-gradient(var(--paper-line) 1px,transparent 1px), linear-gradient(90deg,var(--paper-line) 1px,transparent 1px); background-size:38px 38px; }
  .corner-marks{ position:absolute; inset:18px; pointer-events:none; z-index:6; }
  .corner-marks::before, .corner-marks::after{ content:''; position:absolute; width:16px; height:16px; }
  .corner-marks::before{ top:0; left:0; border-top:1px solid var(--slate-light); border-left:1px solid var(--slate-light); }
  .corner-marks::after{ bottom:0; right:0; border-bottom:1px solid var(--slate-light); border-right:1px solid var(--slate-light); }
  .corner-marks.on-light::before, .corner-marks.on-light::after{ border-color:var(--slate); opacity:.6; }
  .runhead{ position:relative; z-index:10; display:flex; justify-content:space-between; align-items:center; padding:20px 52px 13px; border-bottom:1px solid var(--ink-line-soft); font-size:11px; letter-spacing:.03em; color:var(--slate-light); }
  .runhead.on-light{ border-color:var(--line); color:var(--slate); }
  .idx-num{ font-weight:700; font-size:118px; line-height:1; color:var(--ink-line-soft); position:absolute; top:2px; left:44px; z-index:1; letter-spacing:-.03em; }
  .idx-num.on-light{ color:rgba(16,21,31,.07); }
  .ruler{ position:absolute; left:0; bottom:0; width:100%; height:6px; z-index:10; background-image:repeating-linear-gradient(90deg, var(--line-strong) 0 1px, transparent 1px 40px); opacity:.45; }
  .ruler.amber{ background-image:repeating-linear-gradient(90deg, var(--amber) 0 1px, transparent 1px 40px); opacity:.85; }
  .spec{ position:relative; background:var(--paper-2); border:1px solid var(--line); padding:18px 20px; }
  .spec::before{ content:''; position:absolute; top:-1px; left:-1px; width:10px; height:10px; border-top:2px solid var(--amber); border-left:2px solid var(--amber); }
  .spec-dark{ background:var(--ink-2); border:1px solid var(--ink-line-soft); }
  .spec-dark::before{ border-color:var(--amber); }
  .tag{ font-family:'IBM Plex Mono',monospace; font-size:10.5px; padding:3px 9px; border:1px solid var(--line-strong); display:inline-flex; align-items:center; gap:5px; }
  .tag.on-dark{ border-color:var(--ink-line-soft); color:#E7EAEE; }
  .demo-tab.is-active{ border-color:var(--amber) !important; color:var(--amber) !important; background:rgba(239,162,60,.1); }
  .kb{ color:var(--amber-deep); font-family:'IBM Plex Mono',monospace; font-weight:700; margin-right:8px; }
  .kb.on-dark{ color:var(--amber); }
  .rail{ position:relative; padding-left:26px; margin-bottom:17px; }
  .rail::before{ content:''; position:absolute; left:6px; top:4px; bottom:-17px; width:1px; background:var(--line-strong); }
  .rail:last-child::before{ display:none; }
  .rail .dot{ position:absolute; left:0; top:2px; width:13px; height:13px; border:2px solid var(--amber); background:var(--paper-2); }
  .rail.on-dark .dot{ background:var(--ink); }
  .code{ font-family:'IBM Plex Mono',monospace; background:#0B0F19; color:#D7E2E9; padding:9px 12px; font-size:11px; border-left:2px solid var(--amber); white-space:pre-wrap; margin-top:8px; line-height:1.5; }
  .ent{ background:var(--ink-2); border:1px solid var(--ink-line-soft); width:222px; }
  .ent-head{ padding:7px 12px; border-bottom:1px solid var(--ink-line-soft); font-family:'IBM Plex Mono',monospace; font-size:12.5px; font-weight:600; color:var(--amber); display:flex; justify-content:space-between; align-items:center; }
  .ent-row{ display:flex; justify-content:space-between; gap:8px; padding:5px 12px; font-family:'IBM Plex Mono',monospace; font-size:10.5px; border-bottom:1px solid rgba(255,255,255,.05); color:#C7CFD8; }
  .ent-row:last-child{ border-bottom:none; }
  .ent-row .k{ color:var(--slate-light); white-space:nowrap; }
  .ent-row .pk{ color:var(--amber); }
  .node{ position:relative; background:var(--ink-2); border:1px solid var(--ink-line-soft); padding:11px 13px; }
  .node .cap{ font-family:'IBM Plex Mono',monospace; font-size:9.5px; color:var(--slate-light); }
  .conn{ color:var(--slate-light); font-family:'IBM Plex Mono',monospace; font-size:15px; }
  table.spectable{ width:100%; border-collapse:collapse; font-size:11.5px; }
  table.spectable th{ text-align:left; font-family:'IBM Plex Mono',monospace; font-weight:600; font-size:10px; color:var(--slate); border-bottom:1px solid var(--line-strong); padding:6px 10px; }
  table.spectable td{ padding:6.5px 10px; border-bottom:1px solid var(--line); }
  .c-amber{ color:var(--amber); } .c-amber-deep{ color:var(--amber-deep); }
  .c-slate{ color:var(--slate); } .c-slate-light{ color:var(--slate-light); }
  .c-bug{ color:var(--bug); } .c-guard{ color:var(--guard); } .c-teal{ color:var(--teal); }
  .b-amber{ border-color:var(--amber) !important; }
  .b-bug{ border-color:var(--bug) !important; } .b-guard{ border-color:var(--guard) !important; }

  /* ---- reveal-on-scroll: one synced draft-reveal per sheet ---- */
  @media (prefers-reduced-motion: no-preference){
    .rv{ opacity:0; transform:translateY(18px); transition:opacity .65s cubic-bezier(.19,1,.22,1), transform .65s cubic-bezier(.19,1,.22,1); }
    .sheet.in .rv{ opacity:1; transform:translateY(0); }
    .sheet.in .runhead.rv{ transition-delay:0s; }
    .sheet.in .rv:nth-of-type(2){ transition-delay:.08s; }
    .corner-marks{ opacity:0; transition:opacity 1s ease .25s; }
    .sheet.in .corner-marks{ opacity:1; }
    .idx-num{ opacity:0; transform:scale(.94); transition:opacity .8s ease .1s, transform .8s cubic-bezier(.19,1,.22,1) .1s; }
    .sheet.in .idx-num{ opacity:1; transform:scale(1); }
    .ruler{ transform:scaleX(0); transform-origin:left center; transition:transform 1s cubic-bezier(.16,.8,.24,1) .3s; }
    .sheet.in .ruler{ transform:scaleX(1); }
  }
  @media (prefers-reduced-motion: reduce){
    .rv, .corner-marks, .idx-num{ opacity:1 !important; transform:none !important; }
    .ruler{ transform:scaleX(1) !important; }
  }

  /* ---- tactile hover / press feedback ---- */
  .spec, .spec-dark, .node, .ent, .tag{
    transition:transform .16s cubic-bezier(.2,.8,.3,1), border-color .16s ease, box-shadow .2s ease, background-color .16s ease;
  }
  .spec:hover, .spec-dark:hover{ transform:translateY(-4px); border-color:var(--amber); box-shadow:0 14px 28px -16px rgba(0,0,0,.4); }
  .spec:active, .spec-dark:active{ transform:translateY(-1px) scale(.985); transition-duration:.08s; }
  .spec::before{ transition:width .18s ease, height .18s ease; }
  .spec:hover::before{ width:16px; height:16px; }

  .node{ cursor:default; }
  .node:hover{ transform:translateY(-3px); border-color:var(--amber); box-shadow:0 12px 24px -14px rgba(0,0,0,.5); }
  .node:active{ transform:translateY(-1px) scale(.98); transition-duration:.08s; }

  .ent{ cursor:default; }
  .ent:hover{ transform:translateY(-3px); border-color:var(--amber); box-shadow:0 12px 26px -14px rgba(0,0,0,.55); }
  .ent:hover .ent-head{ color:var(--amber); }
  .ent:active{ transform:translateY(-1px) scale(.985); transition-duration:.08s; }

  .tag{ cursor:default; }
  .tag:hover{ border-color:var(--amber); color:var(--amber-deep); }
  .tag:active{ transform:scale(.95); transition-duration:.08s; }

  .rail{ cursor:default; }
  .rail .dot{ transition:transform .2s ease, background .2s ease; }
  .rail:hover .dot{ transform:scale(1.35); background:var(--amber); }

  ::selection{ background:var(--amber); color:#0B0F19; }
</style>
</head>
<body>

<!-- ============================================================ -->
<!-- SLIDE 1 : COVER -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="ruler amber"></div>
  <div class="relative z-10 flex-1 flex flex-col justify-between px-16 pt-12 pb-10 rv">
    <div class="flex justify-between items-start">
      <span class="tag on-dark"><i class="fa-solid fa-diagram-project c-amber"></i>Team Project Presentation</span>
      <span class="mono text-xs c-slate-light">Java Web Developer Portfolio</span>
    </div>
    <div class="mt-4">
      <h1 class="mono font-bold tracking-tight text-white" style="font-size:108px; line-height:.92;">InfraLink</h1>
      <p class="text-2xl mt-5" style="font-weight:300; color:#C7CFD8;">社内統合業務ポータル<span style="font-weight:600; color:#fff;">開発プロジェクト</span></p>
    </div>
    <div class="pt-7" style="border-top:1px solid var(--ink-line-soft);">
      <p class="mono text-[10px] tracking-wide c-slate-light mb-3">TEAM</p>
      <div class="flex flex-wrap gap-x-10 gap-y-3 mb-8">
        <div class="flex items-center gap-3">
          <span class="mono text-xs font-bold px-2 py-1 border b-amber c-amber">BE</span>
          <span class="text-base font-semibold">Oh Seong-sik <span class="text-xs c-slate-light">오성식</span></span>
        </div>
        <div class="flex items-center gap-3">
          <span class="mono text-xs font-bold px-2 py-1 border b-amber c-amber">BE</span>
          <span class="text-base font-semibold">Jeong Sang-kyung <span class="text-xs c-slate-light">정상경</span></span>
        </div>
        <div class="flex items-center gap-3">
          <span class="mono text-xs font-bold px-2 py-1 border" style="border-color:#7DB8C4; color:#7DB8C4;">FE</span>
          <span class="text-base font-semibold">Lee Jeong-beom <span class="text-xs c-slate-light">이정범</span></span>
        </div>
        <div class="flex items-center gap-3">
          <span class="mono text-xs font-bold px-2 py-1 border" style="border-color:#7DB8C4; color:#7DB8C4;">FE</span>
          <span class="text-base font-semibold">Jeon Seok-won <span class="text-xs c-slate-light">전석원</span></span>
        </div>
      </div>
      <div class="grid grid-cols-12 gap-8">
        <div class="col-span-4">
          <p class="mono text-[10px] tracking-wide c-slate-light mb-1">DEVELOPMENT PERIOD</p>
          <p class="text-xl font-bold text-white">2026.09.01–09.21 <span class="text-sm font-normal c-slate-light">(21日間)</span></p>
        </div>
        <div class="col-span-5">
          <p class="mono text-[10px] tracking-wide c-slate-light mb-1">PROJECT TYPE</p>
          <p class="text-xl font-bold text-white">社内ポータルシステム <span class="text-sm font-normal c-slate-light">(フルスクラッチ開発)</span></p>
        </div>
        <div class="col-span-3">
          <p class="mono text-[10px] tracking-wide c-slate-light mb-1">STACK</p>
          <p class="text-sm font-bold c-amber leading-relaxed">Servlet / JSP<br/>Oracle DB<br/>MVC + Command</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 2 : AGENDA -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="runhead rv"><span class="mono">InfraLink <span class="c-slate-light">/ 社内統合業務ポータル開発</span></span><span class="mono">02 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num">02</span>
    <div class="relative z-10">
      <h1 class="text-[34px] font-black leading-tight text-white">目次 <span class="mono text-base font-normal ml-2 c-amber">Agenda</span></h1>
    </div>
  </div>
  <div class="flex-1 px-14 pt-8 pb-10 relative z-10 rv">
    <div class="grid grid-cols-2 gap-x-14 gap-y-0">
      <div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-amber font-bold text-lg w-8">01</span><div><h3 class="text-base font-bold text-white">プロジェクト概要</h3><p class="mono text-[10px] c-slate-light">Project Overview</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-amber font-bold text-lg w-8">02</span><div><h3 class="text-base font-bold text-white">技術スタック</h3><p class="mono text-[10px] c-slate-light">Tech Stack</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-amber font-bold text-lg w-8">03</span><div><h3 class="text-base font-bold text-white">システムアーキテクチャ</h3><p class="mono text-[10px] c-slate-light">System Architecture</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-amber font-bold text-lg w-8">04</span><div><h3 class="text-base font-bold text-white">データベース設計</h3><p class="mono text-[10px] c-slate-light">Database Design (ER)</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-amber font-bold text-lg w-8">05</span><div><h3 class="text-base font-bold text-white">主要機能 1：認証・セキュリティ</h3><p class="mono text-[10px] c-slate-light">Authentication &amp; Security</p></div></div>
        <div class="flex items-center gap-4 py-3"><span class="mono c-amber font-bold text-lg w-8">06</span><div><h3 class="text-base font-bold text-white">主要機能 2：業務モジュール</h3><p class="mono text-[10px] c-slate-light">Business Modules</p></div></div>
      </div>
      <div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-slate-light font-bold text-lg w-8">07</span><div><h3 class="text-base font-bold text-white">開発の課題と解決 1：バグ修正</h3><p class="mono text-[10px] c-slate-light">Troubleshooting – Bug Fix</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-slate-light font-bold text-lg w-8">08</span><div><h3 class="text-base font-bold text-white">開発の課題と解決 2：セキュリティ強化</h3><p class="mono text-[10px] c-slate-light">Troubleshooting – Hardening</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-slate-light font-bold text-lg w-8">09</span><div><h3 class="text-base font-bold text-white">成果と検証</h3><p class="mono text-[10px] c-slate-light">Results &amp; Verification</p></div></div>
        <div class="flex items-center gap-4 py-3" style="border-bottom:1px solid var(--ink-line);"><span class="mono c-slate-light font-bold text-lg w-8">10</span><div><h3 class="text-base font-bold text-white">今後の計画</h3><p class="mono text-[10px] c-slate-light">Future Plans</p></div></div>
        <div class="flex items-center gap-4 py-3"><span class="mono c-slate-light font-bold text-lg w-8">11</span><div><h3 class="text-base font-bold text-white">まとめ</h3><p class="mono text-[10px] c-slate-light">Conclusion</p></div></div>
      </div>
    </div>
  </div>
  <div class="ruler"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 3 : PROJECT OVERVIEW -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">03 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">03</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">プロジェクト概要 <span class="mono text-base font-normal ml-2 c-amber-deep">Overview</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-7 pb-8 relative z-10 rv">
    <div class="grid grid-cols-2 gap-5">
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-lightbulb c-amber-deep"></i>開発背景 <span class="mono text-[10px] font-normal c-slate">Background</span></h3>
        <p class="text-[13px] leading-relaxed mb-2"><span class="kb">›</span><span class="font-bold">日本のIT実務を想定した技術選定</span> — エンタープライズ現場で今も広く使われるJavaベースのバックエンド技術を習得するため、Servlet/JSPによる素のMVC構成でチームからゼロで設計・実装。</p>
        <p class="text-[13px] leading-relaxed"><span class="kb">›</span><span class="font-bold">Webの原理を体で理解する</span> — フレームワークに頼らず、リクエスト/レスポンス・セッション・フィルタの仕組みを一から実装。</p>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-bullseye c-amber-deep"></i>開発目的 <span class="mono text-[10px] font-normal c-slate">Objectives</span></h3>
        <p class="text-[13px] leading-relaxed mb-2"><span class="kb">›</span><span class="font-bold">8業務モジュールの統合ポータル構築</span> — 社員・部署をベースに、複数業務を1つのWebアプリに統合。</p>
        <p class="text-[13px] leading-relaxed mb-2"><span class="kb">›</span><span class="font-bold">Command パターンによる拡張性</span> — ルートが増えても保守しやすいフロントコントローラー構造を設計。</p>
        <p class="text-[13px] leading-relaxed"><span class="kb">›</span><span class="font-bold">正規化されたDB設計</span> — 11テーブルの外部キー制約・インデックス設計によるデータ整合性の確保。</p>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-layer-group c-amber-deep"></i>プロジェクト範囲 <span class="mono text-[10px] font-normal c-slate">Scope</span></h3>
        <p class="text-[13px] leading-relaxed mb-2"><span class="kb">›</span><span class="font-bold">基本機能</span>：認証・マイページ・社員管理・お知らせ・自由掲示板</p>
        <p class="text-[13px] leading-relaxed"><span class="kb">›</span><span class="font-bold">応用機能</span>：電子決裁・スケジュール・会議室予約・勤怠・通知</p>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-trophy c-amber-deep"></i>成果 <span class="mono text-[10px] font-normal c-slate">Key Results</span></h3>
        <p class="text-[13px] leading-relaxed mb-2"><span class="kb">›</span><span class="font-bold">ルート57件を実装</span> — Command 47件・View 10件、未登録ルート0件を確認。</p>
        <p class="text-[13px] leading-relaxed"><span class="kb">›</span><span class="font-bold">サービス48個・JSP 43枚 全数検証</span> — コンパイルエラー・未接続画面ゼロを達成。</p>
      </div>
    </div>
    <div class="mt-5 flex justify-center gap-3">
      <span class="tag">要件定義</span><span class="tag">設計</span><span class="tag">実装</span><span class="tag">検証</span>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 4 : TECH STACK -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">04 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">04</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">技術スタック <span class="mono text-base font-normal ml-2 c-amber-deep">Tech Stack</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-8 relative z-10 flex flex-col rv">
    <p class="text-[14px] mb-4 c-slate" style="color:#3f4a58;">安定した <span class="font-bold" style="color:var(--ink-text)">Java Servlet</span> ベースのバックエンドと <span class="font-bold" style="color:var(--ink-text)">Oracle RDB</span> を採用し、実務に近い堅牢なWebアプリケーション環境を構築しました。</p>
    <div class="grid grid-cols-2 gap-5 flex-1">
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-desktop c-amber-deep"></i>Frontend <span class="mono text-[10px] font-normal c-slate">フロントエンド</span></h3>
        <div class="text-[13px] space-y-2">
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">JSP</span><span class="c-slate">JSTL 1.2 / EL</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Bootstrap</span><span class="c-slate">5.3 / レスポンシブ対応</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">JavaScript</span><span class="c-slate">ES6+ / DOM操作・Fetch API</span></div>
        </div>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-brands fa-java c-amber-deep"></i>Backend <span class="mono text-[10px] font-normal c-slate">バックエンド</span></h3>
        <div class="text-[13px] space-y-2">
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Java 17</span><span class="c-slate">Servlet 4.0 / JDBC</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Pattern</span><span class="c-slate">Front Controller + Command</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Core</span><span class="c-slate">Filter(3種) / Session管理</span></div>
        </div>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-database c-amber-deep"></i>Database <span class="mono text-[10px] font-normal c-slate">データベース</span></h3>
        <div class="text-[13px] space-y-2">
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Oracle</span><span class="c-slate">XE 11g / SQL Developer</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">設計</span><span class="c-slate">正規化・ERD・インデックス</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">規模</span><span class="c-slate">11 Tables / 9 Sequences</span></div>
        </div>
      </div>
      <div class="spec">
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-shield-halved c-amber-deep"></i>Server &amp; Security <span class="mono text-[10px] font-normal c-slate">サーバー・セキュリティ</span></h3>
        <div class="text-[13px] space-y-2">
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">WAS</span><span class="c-slate">Apache Tomcat 9.0</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">認証</span><span class="c-slate">jBCrypt（パスワードハッシュ化）</span></div>
          <div class="flex items-center gap-3"><span class="mono w-24 font-bold">Tools</span><span class="c-slate">Eclipse / Git・GitHub</span></div>
        </div>
      </div>
    </div>
    <div class="mt-4 flex items-start gap-3 pt-3" style="border-top:1px solid var(--line);">
      <i class="fa-solid fa-circle-info c-amber-deep mt-0.5"></i>
      <div>
        <p class="text-[13px] font-bold">なぜフレームワークを使わずServlet/JSPを選んだのか</p>
        <p class="text-[12px] c-slate mt-0.5">Spring等のフレームワークが自動化する部分に頼らず、リクエスト/レスポンス・セッション・フィルタチェーンなどWebアプリケーションの原理を深く理解するために、あえてネイティブなServlet/JSPで設計しました。</p>
      </div>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 5 : ARCHITECTURE -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="runhead rv"><span class="mono">InfraLink <span class="c-slate-light">/ 社内統合業務ポータル開発</span></span><span class="mono">05 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num">05</span>
    <div class="relative z-10 flex items-baseline justify-between">
      <h1 class="text-[34px] font-black leading-tight text-white">システムアーキテクチャ <span class="mono text-base font-normal ml-2 c-amber">Front Controller + Command</span></h1>
      <div class="flex gap-4 mono text-[10px] c-slate-light">
        <span><span class="inline-block w-2 h-2 mr-1" style="background:var(--amber)"></span>Control Flow</span>
        <span><span class="inline-block w-2 h-2 mr-1" style="background:#7DB8C4"></span>Filter Chain</span>
      </div>
    </div>
  </div>
  <div class="flex-1 px-12 pt-6 pb-6 relative z-10 flex flex-col justify-center items-center gap-6 rv">
    <div class="w-full max-w-6xl flex items-center justify-between">
      <div class="node w-28 h-24 flex flex-col items-center justify-center text-center">
        <i class="fa-solid fa-laptop text-2xl c-slate-light mb-1"></i>
        <p class="font-bold text-sm text-white">Client</p><p class="cap">ブラウザ</p>
      </div>
      <div class="flex-1 mx-4 relative py-2" style="border:1px dashed var(--ink-line-soft);">
        <div class="absolute -top-3 left-4 px-2 mono text-[10px]" style="background:var(--ink); color:#7DB8C4;"><i class="fa-solid fa-server mr-1"></i>Apache Tomcat（フィルタチェーン）</div>
        <div class="flex items-center justify-center gap-3 py-1">
          <div class="node w-32 text-center" style="border-color:#7DB8C455;"><p class="font-bold text-xs text-white">EncodingFilter</p><p class="cap">UTF-8 統一</p></div>
          <span class="conn">╌╌▸</span>
          <div class="node w-32 text-center" style="border-color:#7DB8C455;"><p class="font-bold text-xs text-white">LoginFilter</p><p class="cap">未ログイン遮断</p></div>
          <span class="conn">╌╌▸</span>
          <div class="node w-32 text-center" style="border-color:#7DB8C455;"><p class="font-bold text-xs text-white">AdminFilter</p><p class="cap">管理者権限確認</p></div>
        </div>
      </div>
    </div>
    <div class="w-full max-w-6xl flex items-center justify-center gap-3">
      <div class="node w-48">
        <div class="flex justify-between items-start mb-1"><span class="mono text-[10px] px-1.5 border c-amber b-amber">C</span><i class="fa-brands fa-java c-amber"></i></div>
        <h3 class="font-bold text-sm text-white">pages Servlet</h3><p class="cap">Front Controller</p>
        <div class="mt-2 pt-2 cap leading-tight" style="border-top:1px solid var(--ink-line);">・COMMANDS Map（57ルート）<br/>・&#64;MultipartConfig</div>
      </div>
      <span class="conn">─────▸</span>
      <div class="node w-44">
        <div class="flex justify-between items-start mb-1"><span class="mono text-[10px] px-1.5 border" style="color:#7DB8C4; border-color:#7DB8C4;">M</span><i class="fa-solid fa-gears" style="color:#7DB8C4;"></i></div>
        <h3 class="font-bold text-sm text-white">Service</h3><p class="cap">Command 実装 48個</p>
        <div class="mt-2 pt-2 cap leading-tight" style="border-top:1px solid var(--ink-line);">・execute(req,res)<br/>・PRGパターン</div>
      </div>
      <span class="conn">─────▸</span>
      <div class="node w-44">
        <div class="flex justify-between items-start mb-1"><span class="mono text-[10px] px-1.5 border c-teal" style="border-color:var(--teal);">M</span><i class="fa-solid fa-database c-teal"></i></div>
        <h3 class="font-bold text-sm text-white">DAO</h3><p class="cap">try-with-resources</p>
        <div class="mt-2 pt-2 cap leading-tight" style="border-top:1px solid var(--ink-line);">・JDBC / DBManager<br/>・SQL実行</div>
      </div>
      <span class="conn">─────▸</span>
      <div class="node w-28 h-24 flex flex-col items-center justify-center text-center">
        <i class="fa-solid fa-database text-2xl c-teal mb-1"></i><p class="font-bold text-sm text-white">Oracle DB</p><p class="cap">11 Tables</p>
      </div>
    </div>
    <div class="w-full max-w-6xl grid grid-cols-3 gap-5 mt-1">
      <div class="spec-dark p-3"><p class="text-[12px] leading-snug"><span class="font-bold text-white">Controller:</span> <span class="c-slate-light">switch文ではなくMap(COMMANDS/VIEWS)でルーティング。ルート追加時は1行の登録のみで対応可能。</span></p></div>
      <div class="spec-dark p-3"><p class="text-[12px] leading-snug"><span class="font-bold text-white">Filter Chain:</span> <span class="c-slate-light">web.xmlで順序を明示登録。認証・権限チェックをServiceから分離し責務を単純化。</span></p></div>
      <div class="spec-dark p-3"><p class="text-[12px] leading-snug"><span class="font-bold text-white">Service:</span> <span class="c-slate-light">全48サービスが共通の Command インターフェースを実装し、統一的に呼び出し可能な設計。</span></p></div>
    </div>
  </div>
  <div class="ruler"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 6 : DATABASE DESIGN -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="runhead rv"><span class="mono">InfraLink <span class="c-slate-light">/ 社内統合業務ポータル開発</span></span><span class="mono">06 / 14</span></div>
  <div class="relative px-14 pt-5 flex items-baseline justify-between rv">
    <div><span class="idx-num">06</span>
      <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight text-white">データベース設計 <span class="mono text-base font-normal ml-2 c-amber">ER図</span></h1></div>
    </div>
    <span class="tag on-dark relative z-10"><i class="fa-solid fa-table c-amber"></i> 全11テーブル ・ 9シーケンス</span>
  </div>
  <div class="flex-1 px-12 pt-5 pb-6 relative z-10 rv">
    <div class="grid grid-cols-4 gap-4">
      <div class="ent"><div class="ent-head"><span>department</span><i class="fa-solid fa-sitemap text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">dept_code</span><span>PK</span></div>
        <div class="ent-row"><span class="k">dept_name</span><span>VARCHAR2</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>employee</span><i class="fa-solid fa-user text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">employee_id</span><span>PK</span></div>
        <div class="ent-row"><span class="k">dept_code</span><span>FK</span></div>
        <div class="ent-row"><span class="k">password</span><span>BCrypt</span></div>
        <div class="ent-row"><span class="k">auth_role</span><span>USER/ADMIN</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>notice</span><i class="fa-solid fa-bullhorn text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">notice_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">employee_id</span><span>FK</span></div>
        <div class="ent-row"><span class="k">pin_yn</span><span>CHAR(1)</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>approval</span><i class="fa-solid fa-file-signature text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">approval_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">employee_id</span><span>FK 起案者</span></div>
        <div class="ent-row"><span class="k">approval_id</span><span>FK 決裁者</span></div>
        <div class="ent-row"><span class="k">status</span><span>4状態</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>board</span><i class="fa-solid fa-note-sticky text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">board_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">employee_id</span><span>FK</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>board_comment</span><i class="fa-solid fa-comment text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">comment_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">board_no</span><span>FK CASCADE</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>schedule</span><i class="fa-solid fa-calendar-days text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">schedule_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">visibility</span><span>3段階</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>room_reserve</span><i class="fa-solid fa-door-open text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">reserve_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">room_code</span><span>FK</span></div>
        <div class="ent-row"><span class="k">start/end</span><span>重複検査</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>attendance</span><i class="fa-solid fa-clock text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">att_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">(emp,date)</span><span>UNIQUE</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>notification</span><i class="fa-solid fa-bell text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">noti_no</span><span>PK</span></div>
        <div class="ent-row"><span class="k">read_yn</span><span>CHAR(1)</span></div>
      </div>
      <div class="ent"><div class="ent-head"><span>room</span><i class="fa-solid fa-door-closed text-[10px]"></i></div>
        <div class="ent-row"><span class="k pk">room_code</span><span>PK</span></div>
        <div class="ent-row"><span class="k">capacity</span><span>NUMBER</span></div>
      </div>
      <div class="spec-dark flex flex-col justify-center">
        <p class="mono text-[10px] c-amber mb-1">DESIGN POINTS</p>
        <p class="text-[11px] leading-relaxed c-slate-light">・全テーブルが <span class="font-bold text-white">employee</span> を起点に外部キーで接続<br/>・削除時の影響範囲を制約で明示（コメントは CASCADE）<br/>・予約/勤怠は複合インデックス・UNIQUE制約で不整合を防止</p>
      </div>
    </div>
  </div>
  <div class="ruler"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 7 : AUTH & SECURITY -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">07 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">07</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">認証・セキュリティ <span class="mono text-base font-normal ml-2 c-amber-deep">Authentication</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 flex flex-col rv">
    <div class="grid grid-cols-2 gap-10 flex-1">
      <div>
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-right-to-bracket c-amber-deep"></i>ログイン・パスワード管理</h3>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">初期パスワード = 社員番号</h4>
          <p class="text-[12px] c-slate mt-1">新規登録時は社員番号がそのまま初期パスワードになり、初回ログイン時に変更を促す（<span class="mono">pwd_reset_yn</span>）。</p></div>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">BCrypt ハッシュ化必須</h4>
          <p class="text-[12px] c-slate mt-1">平文パスワードはDBに保存しない。60桁のBCryptハッシュのみ許可。</p>
          <div class="code">String hashed = PasswordUtil.hashPassword(plain);
// checkPassword() は非BCrypt値でも例外を投げず false を返す</div></div>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">セッション固定攻撃への対策</h4>
          <p class="text-[12px] c-slate mt-1">ログイン成功時にセッションIDを再発行し、既存セッションの乗っ取りを防止。パスワードハッシュはセッションに保存しない。</p></div>
      </div>
      <div>
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-shield-halved c-amber-deep"></i>権限管理・入力値検証</h3>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">2段階フィルタによる権限分離</h4>
          <p class="text-[12px] c-slate mt-1">LoginFilter が未ログインアクセスを遮断し、AdminFilter が <span class="mono">auth_role=ADMIN</span> を確認。静的リソースと公開パスは通過させる。</p></div>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">XSS 対策</h4>
          <p class="text-[12px] c-slate mt-1">ユーザー入力の表示は必ず <span class="mono">&lt;c:out&gt;</span> でエスケープし、タイトル等へのスクリプト混入を防止。</p></div>
        <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm">DBレベルの所有者チェック</h4>
          <p class="text-[12px] c-slate mt-1">更新・削除系のSQLの WHERE 句に <span class="mono">employee_id</span> を含め、他人の投稿・決裁を操作できないよう制御。</p></div>
      </div>
    </div>
    <div class="spec flex items-center gap-4 mt-2">
      <span class="tag"><i class="fa-solid fa-user-shield c-amber-deep"></i> ADMIN</span><span class="mono text-[11px] c-slate">ADM-2026-001</span>
      <span class="tag"><i class="fa-solid fa-user c-slate"></i> USER</span><span class="mono text-[11px] c-slate">DEV-2026-002</span>
      <span class="text-[11px] c-slate ml-auto">※ サンプルデータのテストアカウント（初期パスワード＝社員番号）</span>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 8 : BUSINESS MODULES -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">08 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">08</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">業務モジュール <span class="mono text-base font-normal ml-2 c-amber-deep">Business Modules</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 flex flex-col rv">
    <div class="grid grid-cols-4 gap-4 flex-1">
      <div class="spec"><i class="fa-solid fa-bullhorn c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">お知らせ</h4><p class="text-[11px] c-slate leading-relaxed">カテゴリ・全体/部署公開範囲・上部固定表示・添付ファイル対応</p></div>
      <div class="spec"><i class="fa-solid fa-comments c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">自由掲示板 + コメント</h4><p class="text-[11px] c-slate leading-relaxed">投稿削除時にコメントも自動削除（ON DELETE CASCADE）</p></div>
      <div class="spec"><i class="fa-solid fa-file-signature c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">電子決裁</h4><p class="text-[11px] c-slate leading-relaxed">起案 → 承認/却下 → 回収の4状態を管理、決裁者を別途指定</p></div>
      <div class="spec"><i class="fa-solid fa-calendar-days c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">スケジュール</h4><p class="text-[11px] c-slate leading-relaxed">公開範囲を個人/部署/全体で切替、開始≦終了をDB制約で保証</p></div>
      <div class="spec"><i class="fa-solid fa-door-open c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">会議室予約</h4><p class="text-[11px] c-slate leading-relaxed">同一会議室・同一時間帯の重複予約を専用インデックスで検査</p></div>
      <div class="spec"><i class="fa-solid fa-business-time c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">勤怠管理</h4><p class="text-[11px] c-slate leading-relaxed">1人1日1件をUNIQUE制約で保証、月次集計に対応</p></div>
      <div class="spec"><i class="fa-solid fa-bell c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">通知</h4><p class="text-[11px] c-slate leading-relaxed">DBベースで既読/未読を管理、クリックで該当画面へ遷移</p></div>
      <div class="spec"><i class="fa-solid fa-users c-amber-deep text-lg mb-2"></i><h4 class="font-bold text-sm mb-1">社員管理（管理者）</h4><p class="text-[11px] c-slate leading-relaxed">検索・編集・退職処理・パスワード初期化、部署別採番ロジック</p></div>
    </div>
    <div class="spec flex items-start gap-3 mt-4">
      <i class="fa-solid fa-circle-info c-amber-deep mt-0.5"></i>
      <p class="text-[12px] c-slate">全モジュールが同じ Command インターフェースを実装したService層に対応しており、画面（JSP）・DAO・DTOがそれぞれ独立して追加できる構造になっています。<span class="c-slate-light mono text-[10.5px] ml-1">※ 添付ファイルの削除処理に関する既知の課題は P.13 参照</span></p>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 09 : DEMO VIDEO -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="runhead rv"><span class="mono">InfraLink <span class="c-slate-light">/ 社内統合業務ポータル開発</span></span><span class="mono">09 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num">09</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight text-white">デモンストレーション映像 <span class="mono text-base font-normal ml-2 c-amber">Demo</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-5 pb-6 relative z-10 flex flex-col rv">
    <div class="spec-dark p-2" style="flex:1; display:flex; align-items:center; justify-content:center; min-height:0;">
      <iframe id="demoVideo" width="100%" height="100%" style="max-height:420px; aspect-ratio:16/9; background:#000;"
        src="https://www.youtube.com/embed/4RNqnQm2ZHo"
        title="InfraLink デモ映像" frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen></iframe>
    </div>
    <div class="flex items-center gap-3 mt-4">
      <button class="tag on-dark demo-tab is-active" data-src="https://www.youtube.com/embed/4RNqnQm2ZHo" style="cursor:pointer;">
        <i class="fa-solid fa-right-to-bracket"></i> 認証・ログイン
      </button>
      <button class="tag on-dark demo-tab" data-src="https://www.youtube.com/embed/_SLHhIKNLQw" style="cursor:pointer;">
        <i class="fa-solid fa-business-time"></i> 勤怠管理・会議室予約
      </button>
      <button class="tag on-dark demo-tab" data-src="https://www.youtube.com/embed/kNN4rKiUsXY" style="cursor:pointer;">
        <i class="fa-solid fa-file-signature"></i> 電子決裁
      </button>
      <span class="mono text-[10.5px] c-slate-light ml-auto">※ YouTube 埋め込み</span>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 10 : TROUBLESHOOTING 1 - BUG FIX -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">10 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">10</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">開発中に発見・修正したバグ <span class="mono text-base font-normal ml-2 c-bug">Bug Fix</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 rv">
    <p class="text-[13px] c-slate mb-4">開発の途中で結合テストを行った際、以下のような <span class="font-bold c-bug">500エラー</span> や実装漏れが見つかり、原因を特定して修正しました。</p>
    <div class="grid grid-cols-2 gap-4">
      <div class="spec" style="border-left:3px solid var(--bug);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-bug border b-bug px-1.5">CRIT</span>ルーティングの NullPointerException</h4>
        <p class="text-[12px] c-slate mt-1.5">「/pages」のみでアクセスすると <span class="mono">getPathInfo()</span> が null になり、<span class="mono">switch(null)</span> で例外発生。</p>
        <div class="code">switch → LinkedHashMap(COMMANDS/VIEWS) に置き換え
+ null チェックを追加</div>
      </div>
      <div class="spec" style="border-left:3px solid var(--bug);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-bug border b-bug px-1.5">CRIT</span>ファイルアップロードの例外</h4>
        <p class="text-[12px] c-slate mt-1.5">サーブレットに <span class="mono">&#64;MultipartConfig</span> が無く、<span class="mono">request.getPart()</span> が <span class="mono">IllegalStateException</span> を投げていた。</p>
        <div class="code">&#64;MultipartConfig(maxFileSize = 10L*1024*1024, ...)
を pages サーブレットに追加</div>
      </div>
      <div class="spec" style="border-left:3px solid var(--amber-deep);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-amber-deep border" style="border-color:var(--amber-deep);" >WARN</span>お知らせ更新の条件分岐ミス</h4>
        <p class="text-[12px] c-slate mt-1.5"><span class="mono">NoticeDAO.updateNotice()</span> の if/else が入れ替わっており、意図と逆の処理が実行されていた。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--amber-deep);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-amber-deep border" style="border-color:var(--amber-deep);">WARN</span>存在しない画面への遷移</h4>
        <p class="text-[12px] c-slate mt-1.5"><span class="mono">/system-status.do</span> 等、実装前に登録していたルートが存在しないJSPを指しており404が発生。画面実装とルート登録の整合性を全件チェック。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--slate);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-slate border" style="border-color:var(--slate);">NOTE</span>パスワード検証時の例外</h4>
        <p class="text-[12px] c-slate mt-1.5"><span class="mono">PasswordUtil.checkPassword()</span> がBCrypt形式でない値に対して例外を投げていた点を、<span class="mono">false</span> を返すよう修正。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--slate);">
        <h4 class="font-bold text-sm flex items-center gap-2"><span class="mono text-[9px] c-slate border" style="border-color:var(--slate);">NOTE</span>未接続だった機能</h4>
        <p class="text-[12px] c-slate mt-1.5">ログアウト・マイページ・個人情報修正・パスワード変更など、実装済みのロジックの半数が画面やルートと未接続だった状態を発見し、全て接続。</p>
      </div>
    </div>
  </div>
  <div class="ruler" style="background-image:repeating-linear-gradient(90deg, var(--bug) 0 1px, transparent 1px 40px); opacity:.8;"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 11 : TROUBLESHOOTING 2 - SECURITY HARDENING -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">11 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">11</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">セキュリティ強化 <span class="mono text-base font-normal ml-2 c-guard">Hardening</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 flex flex-col rv">
    <div class="grid grid-cols-2 gap-10 flex-1">
      <div>
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-lock c-guard"></i>設定・機密情報の外部化</h3>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">DBアカウント・アップロード先のハードコーディング除去</h4>
          <p class="text-[12px] c-slate mt-1">ソース内に直接書かれていた接続情報を <span class="mono">db.properties</span>（Git管理外）に分離。</p></div>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">添付ファイルのパストラバーサル対策</h4>
          <p class="text-[12px] c-slate mt-1">ダウンロードはファイル名でなく「投稿番号」で要求する方式にし、<span class="mono">../../</span> によるパス操作を遮断。</p></div>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">アップロード制限</h4>
          <p class="text-[12px] c-slate mt-1">拡張子ホワイトリストと容量上限（1リクエスト最大50MB）を設定。</p></div>
      </div>
      <div>
        <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-list-check c-guard"></i>コード品質・形状管理</h3>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">.gitignore の見直し</h4>
          <p class="text-[12px] c-slate mt-1"><span class="mono">src/main/java</span> 全体が除外設定に含まれていた設定ミスを発見・修正し、ソース全体がリポジトリに正しく反映されるようにした。</p></div>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">DBリソース管理の統一</h4>
          <p class="text-[12px] c-slate mt-1">全DAOを <span class="mono">try-with-resources</span> に統一し、コネクションリークを防止。</p></div>
        <div class="rail"><span class="dot" style="border-color:var(--guard);"></span><h4 class="font-bold text-sm">DBスキーマ・エラーページの新規整備</h4>
          <p class="text-[12px] c-slate mt-1">DDLが存在しなかったため <span class="mono">01_schema.sql</span>（11テーブル・9シーケンス）を新規作成し、400/403/404/500の専用エラー画面を追加。</p></div>
      </div>
    </div>
    <div class="grid grid-cols-3 gap-3 mt-1">
      <span class="tag" style="color:var(--guard); border-color:var(--guard);">db.properties</span>
      <span class="tag" style="color:var(--guard); border-color:var(--guard);">Whitelist Ext</span>
      <span class="tag" style="color:var(--guard); border-color:var(--guard);">Path Traversal 対策</span>
      <span class="tag">try-with-resources</span>
      <span class="tag">.gitignore 修正</span>
      <span class="tag">DDL 新規作成</span>
    </div>
  </div>
  <div class="ruler" style="background-image:repeating-linear-gradient(90deg, var(--guard) 0 1px, transparent 1px 40px); opacity:.8;"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 12 : RESULTS & FUTURE PLANS -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">12 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">12</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">成果と今後の計画 <span class="mono text-base font-normal ml-2 c-amber-deep">Results / Future</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 grid grid-cols-2 gap-10 rv">
    <div>
      <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-chart-simple c-amber-deep"></i>実装・検証結果</h3>
      <table class="spectable mb-3">
        <thead><tr><th>レイヤー</th><th>状況</th></tr></thead>
        <tbody>
          <tr><td class="font-bold">Util 共通</td><td>7 / 7</td></tr>
          <tr><td class="font-bold">DTO・DAO</td><td>21 / 21</td></tr>
          <tr><td class="font-bold">Service</td><td>48 / 48</td></tr>
          <tr><td class="font-bold">Controller・Filter</td><td>ルート57件（Command 47・View 10）／ Filter 3件</td></tr>
          <tr><td class="font-bold">JSP・JS</td><td>43 / 43</td></tr>
        </tbody>
      </table>
      <div class="text-[12px] c-slate space-y-1.5">
        <p><span class="kb">›</span>Java コンパイル：<span class="mono">javac -Xlint:all</span> 警告 0件</p>
        <p><span class="kb">›</span>JSP コンパイル検証：43 / 43 通過（Tomcat JspC）</p>
        <p><span class="kb">›</span>ルート照合：未登録0件・未接続サービス0件</p>
      </div>
    </div>
    <div>
      <h3 class="font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-road c-amber-deep"></i>今後の計画</h3>
      <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm flex items-center">Spring Framework への移行<span class="ml-auto mono text-[10px] c-slate">Refactoring</span></h4>
        <p class="text-[12px] c-slate mt-1">DI/IoC・JPA導入による生産性と保守性の向上</p></div>
      <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm flex items-center">REST API化・ソーシャルログイン<span class="ml-auto mono text-[10px] c-slate">OAuth 2.0</span></h4>
        <p class="text-[12px] c-slate mt-1">Google/GitHub 連携によるアクセス性向上</p></div>
      <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm flex items-center">メッセンジャー機能<span class="ml-auto mono text-[10px] c-slate">WebSocket</span></h4>
        <p class="text-[12px] c-slate mt-1">画面のみ先行実装済み。リアルタイム通信基盤の追加が必要</p></div>
      <div class="rail"><span class="dot"></span><h4 class="font-bold text-sm flex items-center">管理者活動ログ・権限細分化<span class="ml-auto mono text-[10px] c-slate">Audit Log</span></h4>
        <p class="text-[12px] c-slate mt-1">現在はUSER/ADMINの2段階権限。監査テーブル設計後に拡張予定</p></div>
    </div>
  </div>
  <div class="ruler amber"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 13 : KNOWN ISSUES / TO BE FIXED -->
<!-- ============================================================ -->
<div class="sheet sheet-light">
  <div class="grid-light"></div>
  <div class="corner-marks on-light"></div>
  <div class="runhead on-light rv"><span class="mono">InfraLink <span class="c-slate">/ 社内統合業務ポータル開発</span></span><span class="mono">13 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num on-light">13</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight">既知の課題・今後補完すべき点 <span class="mono text-base font-normal ml-2 c-bug">Known Issues</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-5 pb-5 relative z-10 rv">
    <p class="text-[12.5px] c-slate mb-3">現時点で動作確認が取れていない箇所、および仕様上の考慮漏れです。次フェーズで優先的に対応します。</p>
    <div class="grid grid-cols-2 gap-3">
      <div class="spec" style="border-left:3px solid var(--amber-deep); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-amber-deep border px-1.5" style="border-color:var(--amber-deep);">仕様漏れ</span>会議室予約 — タイムゾーン未考慮</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed">日時はサーバーの既定時刻／Oracle <span class="mono">SYSDATE</span> に依存しており、KST（韓国標準時）を明示的に指定していません。またリクエストを操作すれば、過去の日付や無効化された会議室でも予約が成立してしまいます。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--amber-deep); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-amber-deep border px-1.5" style="border-color:var(--amber-deep);">仕様漏れ</span>スケジュール — 編集時の番号欠落</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed">編集中にバリデーションが失敗すると <span class="mono">schedule_no</span> が失われ、再送信時に別の新規予定として重複登録されてしまう場合があります。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--bug); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-bug border b-bug px-1.5">不具合</span>掲示板・お知らせ — 添付削除の不整合</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed">投稿／コメントの登録・修正・削除自体は動作しますが、「既存の添付ファイルを削除」を選ぶと実ファイルのみ削除され、DB上の <span class="mono">file_path</span> が残存。以後ダウンロードリンクが壊れた状態になります。お知らせ機能も同様です。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--slate); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-slate border px-1.5" style="border-color:var(--slate);">未実装</span>管理者 — 役割 / 決裁ルール / 活動ログ</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed">画面（JSP）のみ用意された静的ページで、ルーティングも Service ではなく <span class="mono">VIEWS</span>（単純フォワード）にしか接続されていません。対応するDBテーブル・DAO・保存／削除APIは未着手です。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--slate); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-slate border px-1.5" style="border-color:var(--slate);">未実装</span>食堂メニュー</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed">メニュー用のテーブル・DAO・Service・管理画面はまだなく、メイン画面には8月13日分の固定メニューがハードコーディングされているのみです。</p>
      </div>
      <div class="spec" style="border-left:3px solid var(--bug); padding:12px 16px;">
        <h4 class="font-bold text-[13px] flex items-center gap-2"><span class="mono text-[9px] c-bug border b-bug px-1.5">未接続</span>パスワード再設定画面</h4>
        <p class="text-[11.5px] c-slate mt-1.5 leading-relaxed"><span class="mono">password-reset.do</span> は単なるJSPページで、フォームの action 属性と実際の処理ロジックがまだ結びついていません。</p>
      </div>
    </div>
  </div>
  <div class="ruler" style="background-image:repeating-linear-gradient(90deg, var(--slate) 0 1px, transparent 1px 40px); opacity:.7;"></div>
</div>

<!-- ============================================================ -->
<!-- SLIDE 14 : CONCLUSION -->
<!-- ============================================================ -->
<div class="sheet sheet-dark">
  <div class="grid-dark"></div>
  <div class="corner-marks"></div>
  <div class="runhead rv"><span class="mono">InfraLink <span class="c-slate-light">/ 社内統合業務ポータル開発</span></span><span class="mono">14 / 14</span></div>
  <div class="relative px-14 pt-5 rv">
    <span class="idx-num">14</span>
    <div class="relative z-10"><h1 class="text-[34px] font-black leading-tight text-white">まとめ <span class="mono text-base font-normal ml-2 c-amber">Thank You</span></h1></div>
  </div>
  <div class="flex-1 px-14 pt-6 pb-6 relative z-10 grid grid-cols-2 gap-5 rv">
    <div class="spec-dark p-5">
      <div class="flex items-center gap-3 mb-3"><i class="fa-solid fa-trophy c-amber text-lg"></i><div><h3 class="text-lg font-bold text-white">プロジェクトの成果</h3><p class="mono text-[10px] c-slate-light">Achievements</p></div></div>
      <p class="text-[13px] leading-relaxed mb-2 c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">21日間で8業務モジュールを完成</span> — フロント〜バックエンド〜DBまで一貫して設計・実装。</p>
      <p class="text-[13px] leading-relaxed c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">設計力の証明</span> — Command パターンと正規化されたDB設計による実務水準の技術力を提示。</p>
    </div>
    <div class="spec-dark p-5">
      <div class="flex items-center gap-3 mb-3"><i class="fa-solid fa-book-open c-amber text-lg"></i><div><h3 class="text-lg font-bold text-white">学んだこと</h3><p class="mono text-[10px] c-slate-light">Lessons Learned</p></div></div>
      <p class="text-[13px] leading-relaxed mb-2 c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">問題解決力の向上</span> — エンコーディングエラーやセッション管理の不具合を自力でデバッグ。</p>
      <p class="text-[13px] leading-relaxed c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">基礎の重要性</span> — フレームワーク以前の素のServletを扱うことで、Webの原理への理解が深まった。</p>
    </div>
    <div class="spec-dark p-5">
      <div class="flex items-center gap-3 mb-3"><i class="fa-solid fa-rocket c-amber text-lg"></i><div><h3 class="text-lg font-bold text-white">今後の計画</h3><p class="mono text-[10px] c-slate-light">Future Plans</p></div></div>
      <p class="text-[13px] leading-relaxed mb-2 c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">Spring への移行</span> — 生産性・保守性向上のためのフレームワーク導入。</p>
      <p class="text-[13px] leading-relaxed c-slate-light"><span class="kb on-dark">›</span><span class="font-bold text-white">機能の高度化</span> — REST API化・OAuthソーシャルログインの実装予定。</p>
    </div>
    <div class="p-5 flex flex-col justify-center items-center text-center" style="background:linear-gradient(145deg,#1a2236,#0B0F19); border:1px solid var(--ink-line-soft);">
      <i class="fa-solid fa-handshake c-amber text-4xl mb-2" style="opacity:.85;"></i>
      <h3 class="text-xl font-bold text-white mb-1">ご清聴ありがとうございました</h3>
      <p class="text-sm c-slate-light font-light mb-3">InfraLink Team</p>
      <div class="mono text-[11px] c-slate-light pt-2 w-full space-y-0.5" style="border-top:1px solid var(--ink-line-soft);">
        <p><span class="font-bold text-white">Oh Seong-sik</span> / <span class="font-bold text-white">Jeong Sang-kyung</span> — Backend</p>
        <p><span class="font-bold text-white">Lee Jeong-beom</span> / <span class="font-bold text-white">Jeon Seok-won</span> — Frontend</p>
      </div>
    </div>
  </div>
  <div class="flex justify-center items-center relative z-10 mono text-xs c-slate-light pb-4">
    <i class="fa-brands fa-github mr-2"></i> github.com/peri7860/InfraLinkProject
  </div>
  <div class="ruler amber"></div>
</div>

<script>
  (function(){
    var sheets = document.querySelectorAll('.sheet');
    if (!('IntersectionObserver' in window)) {
      sheets.forEach(function(s){ s.classList.add('in'); });
      return;
    }
    var io = new IntersectionObserver(function(entries){
      entries.forEach(function(entry){
        if (entry.isIntersecting) {
          entry.target.classList.add('in');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.22 });
    sheets.forEach(function(s){ io.observe(s); });
  })();

  (function(){
    var video = document.getElementById('demoVideo');
    if (!video) return;
    var tabs = document.querySelectorAll('.demo-tab');
    tabs.forEach(function(btn){
      btn.addEventListener('click', function(){
        tabs.forEach(function(b){ b.classList.remove('is-active'); });
        btn.classList.add('is-active');
        var src = btn.getAttribute('data-src');
        if (video.getAttribute('src') !== src) {
          video.setAttribute('src', src);
        }
      });
    });
  })();
</script>
</body>
</html>
