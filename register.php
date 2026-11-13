<?php
require_once __DIR__.'/config/database.php';
$error='';
if ($_SERVER['REQUEST_METHOD']==='POST') {
    check_csrf();
    $fullname=trim((string)($_POST['fullname']??''));
    $email=mb_strtolower(trim((string)($_POST['email']??'')));
    $password=(string)($_POST['password']??'');
    if ($fullname==='' || mb_strlen($fullname)>120 || !filter_var($email,FILTER_VALIDATE_EMAIL) || strlen($password)<8) {
        $error='Enter your name, a valid email address, and a password with at least 8 characters.';
    } else {
        try {
            $stmt=$conn->prepare('INSERT INTO users(fullname,email,password,role) VALUES(?,?,?,\'student\')');
            $stmt->execute([$fullname,$email,password_hash($password,PASSWORD_DEFAULT)]);
            header('Location: '.app_url('login.php?registered=1')); exit;
        } catch (PDOException $exception) {
            $error=$exception->getCode()==='23000'?'An account with this email already exists.':'Could not create your account. Please try again.';
        }
    }
}
$pageTitle='Create account'; require __DIR__.'/partials/header.php';
?>
<section class="auth-wrap"><div class="auth-aside register-aside"><span class="eyebrow">A BETTER WAY TO LEARN NETWORKING</span><h1>Build your foundation. Then build on it.</h1><p>Your lessons, practice activities, and quiz results stay together in one learning space.</p><div class="auth-stat"><b>01</b><span>LEARN AT<br>YOUR OWN PACE</span><b>02</b><span>TRACK YOUR<br>PROGRESS</span></div></div><div class="auth-card"><span class="eyebrow">GET STARTED</span><h2>Create your learner account</h2><p class="muted">It only takes a moment.</p><?php if($error): ?><div class="notice error"><?= e($error) ?></div><?php endif; ?><form method="post" class="form-stack"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><label>Full name<input type="text" name="fullname" maxlength="120" value="<?= e($_POST['fullname']??'') ?>" autocomplete="name" required></label><label>Email address<input type="email" name="email" value="<?= e($_POST['email']??'') ?>" autocomplete="email" required></label><label>Password <small>At least 8 characters</small><input type="password" name="password" minlength="8" autocomplete="new-password" required></label><button class="button button-primary full" type="submit">Create account <span>↗</span></button></form><p class="auth-switch">Already have an account? <a href="<?= e(app_url('login.php')) ?>">Sign in</a></p></div></section>
<?php require __DIR__.'/partials/footer.php'; ?>
