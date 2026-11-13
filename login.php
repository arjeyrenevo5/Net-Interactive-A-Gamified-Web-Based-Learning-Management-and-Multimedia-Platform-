<?php
require_once __DIR__.'/config/database.php';
$error='';
if ($_SERVER['REQUEST_METHOD']==='POST') {
    check_csrf();
    $email=mb_strtolower(trim((string)($_POST['email']??'')));
    $password=(string)($_POST['password']??'');
    $stmt=$conn->prepare('SELECT id,fullname,email,password,role FROM users WHERE email=? LIMIT 1');
    $stmt->execute([$email]); $account=$stmt->fetch();
    if ($account && password_verify($password,$account['password'])) {
        session_regenerate_id(true);
        $_SESSION['user_id']=(int)$account['id']; $_SESSION['fullname']=$account['fullname']; $_SESSION['role']=$account['role'];
        header('Location: '.app_url($account['role']==='admin'?'admin/dashboard.php':'student/dashboard.php')); exit;
    }
    $error='That email and password combination was not found.';
}
$pageTitle='Sign in'; require __DIR__.'/partials/header.php';
?>
<section class="auth-wrap"><div class="auth-aside"><span class="eyebrow">WELCOME BACK</span><h1>Your next networking idea starts here.</h1><p>Pick up where you left off and keep building your confidence, one clear step at a time.</p><div class="auth-aside-art"><span>IP</span><i></i><span>LAN</span><i></i><span>WEB</span></div></div><div class="auth-card"><span class="eyebrow">LEARNER ACCESS</span><h2>Sign in to Net Learn</h2><p class="muted">Use the account you registered with.</p><?php if(isset($_GET['registered'])): ?><div class="notice success">Your account is ready. Sign in to begin.</div><?php endif; ?><?php if($error): ?><div class="notice error"><?= e($error) ?></div><?php endif; ?><form method="post" class="form-stack"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><label>Email address<input type="email" name="email" value="<?= e($_POST['email']??'') ?>" autocomplete="email" required></label><label>Password<input type="password" name="password" autocomplete="current-password" required></label><button class="button button-primary full" type="submit">Sign in <span>↗</span></button></form><p class="auth-switch">New to Net Learn? <a href="<?= e(app_url('register.php')) ?>">Create an account</a></p></div></section>
<?php require __DIR__.'/partials/footer.php'; ?>
