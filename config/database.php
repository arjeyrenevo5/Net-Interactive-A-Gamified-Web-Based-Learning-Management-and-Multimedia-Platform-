<?php
declare(strict_types=1);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

function e(mixed $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function app_base(): string
{
    $script = str_replace('\\', '/', (string) ($_SERVER['SCRIPT_NAME'] ?? '/'));
    $dir = preg_match('~/(admin|student)/~', $script) ? dirname(dirname($script)) : dirname($script);
    return $dir === '/' || $dir === '.' ? '' : rtrim($dir, '/');
}

function app_url(string $path = ''): string
{
    return app_base() . '/' . ltrim($path, '/');
}

function csrf_token(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function check_csrf(): void
{
    $token = (string) ($_POST['csrf_token'] ?? '');
    if (!hash_equals(csrf_token(), $token)) {
        http_response_code(419);
        exit('Your form session expired. Go back, reload the page, and try again.');
    }
}

function require_login(): void
{
    if (empty($_SESSION['user_id'])) {
        header('Location: ' . app_url('login.php'));
        exit;
    }
}

function require_admin(): void
{
    if (($_SESSION['role'] ?? '') !== 'admin') {
        header('Location: ' . app_url('login.php'));
        exit;
    }
}

$host = getenv('DB_HOST') ?: '127.0.0.1';
$name = getenv('DB_NAME') ?: 'net_learn';
$user = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASSWORD') ?: '';
try {
    $conn = new PDO("mysql:host={$host};dbname={$name};charset=utf8mb4", $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
} catch (PDOException $exception) {
    http_response_code(500);
    exit('Could not connect to MySQL. Check the database settings in config/database.php and import setup.sql.');
}
