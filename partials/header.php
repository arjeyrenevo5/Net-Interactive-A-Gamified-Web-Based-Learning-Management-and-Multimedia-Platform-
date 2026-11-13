<?php
$pageTitle = $pageTitle ?? 'Net Learn';
$activeNav = $activeNav ?? '';
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#f4f7fb">
  <title><?= e($pageTitle) ?> · Net Learn</title>
  <link rel="stylesheet" href="<?= e(app_url('style.css')) ?>">
  <script src="<?= e(app_url('assets/app.js')) ?>" defer></script>
</head>
<body>
<header class="site-header"><div class="header-inner">
  <a class="brand" href="<?= e(app_url('index.php')) ?>"><span class="brand-icon">N</span><span>Net Learn<small>NETWORKING, MADE CLEAR</small></span></a>
  <button class="menu-toggle" type="button" aria-label="Toggle navigation" aria-expanded="false">☰</button>
  <nav class="main-nav">
    <a class="<?= $activeNav==='lessons'?'active':'' ?>" href="<?= e(app_url('lessons.php')) ?>">Lessons</a>
    <a class="<?= $activeNav==='activities'?'active':'' ?>" href="<?= e(app_url('activities.php')) ?>">Practice labs</a>
    <a class="<?= $activeNav==='resources'?'active':'' ?>" href="<?= e(app_url('resources.php')) ?>">Resources</a>
    <a class="<?= $activeNav==='quizzes'?'active':'' ?>" href="<?= e(app_url('quizzes.php')) ?>">Quizzes</a>
    <?php if (!empty($_SESSION['user_id'])): ?>
      <a class="nav-dashboard" href="<?= e(app_url(($_SESSION['role'] ?? '')==='admin' ? 'admin/dashboard.php' : 'student/dashboard.php')) ?>">My dashboard</a>
      <a href="<?= e(app_url('logout.php')) ?>">Sign out</a>
    <?php else: ?>
      <a href="<?= e(app_url('login.php')) ?>">Sign in</a>
      <a class="nav-join" href="<?= e(app_url('register.php')) ?>">Join free <span>↗</span></a>
    <?php endif; ?>
  </nav>
</div></header>
<main>
