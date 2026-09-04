# 🚀 MyPages

我的静态网页工具集

---

## ⚡ 配置文件

<details>
<summary>📋 点击展开复制代码</summary>

```powershell
# ============================================
# MyPages 配置生成器
# ============================================

# 🔑 请填写你的 Cloudflare 信息
$ACCOUNT_ID = "你的账户ID"
$API_TOKEN = "你的API令牌"
$PROJECT_NAME = "你的项目名称"

# 🌐 可选修改
$GITHUB_URL = "https://github.com/GhbGjxZr/MyPages"
$CF_PAGES_URL = "https://dash.cloudflare.com/你的账户ID/pages/view/你的项目名称"
$KEEP_COUNT = 5

# ============================================
$DEL_PAGES = @"
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set ACCOUNT_ID=$ACCOUNT_ID
set API_TOKEN=$API_TOKEN
set PROJECT_NAME=$PROJECT_NAME

set CLOUDFLARE_ACCOUNT_ID=%ACCOUNT_ID%
set CLOUDFLARE_API_TOKEN=%API_TOKEN%
set CLOUDFLARE_PROJECT_NAME=%PROJECT_NAME%

echo ========================================
echo   🧹 清理 Cloudflare Pages 历史版本
echo ========================================
echo.
echo 📁 项目: %PROJECT_NAME%
echo 📅 保留策略: 保留最新 $KEEP_COUNT 个版本
echo.

call npx --yes cf-deploy-cleanup -s=$KEEP_COUNT

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 清理完成！
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   ❌ 清理失败
    echo ========================================
    echo.
    echo 请检查：
    echo 1. API 令牌是否有效
    echo 2. 项目名称是否正确
    echo 3. 网络连接是否正常
)

echo.
pause
"@

$COMMIT = @"
@echo off
chcp 65001 >nul
echo ================================
echo   一键提交并推送脚本
echo ================================
echo.

git status --porcelain >nul 2>&1
if errorlevel 1 (
    echo ❌ 不是有效的 Git 仓库！
    pause
    exit /b 1
)

git diff --quiet
if errorlevel 1 (
    echo ✅ 检测到变更，准备提交...
) else (
    git diff --cached --quiet
    if errorlevel 1 (
        echo ✅ 检测到暂存区变更，准备提交...
    ) else (
        echo ⚠️ 没有需要提交的变更
        pause
        exit /b 0
    )
)

echo.
set /p msg="📝 请输入提交信息（直接回车默认：提交）: "
if "%msg%"=="" set msg=提交

echo.
echo 📤 正在添加所有变更...
git add .

echo 📝 正在提交...
git commit -m "%msg%"

if errorlevel 1 (
    echo ❌ 提交失败！
    pause
    exit /b 1
)

echo 🚀 正在推送到远程仓库...
git push

if errorlevel 1 (
    echo ❌ 推送失败！
    pause
) else (
    echo ✅ 推送成功！
    echo.
    echo 🌐 正在打开网页...
    start "" "$GITHUB_URL"
    start "" "$CF_PAGES_URL"
    del-pages-log.bat
)

exit
"@

$DEL_PAGES | Out-File -Encoding UTF8 del-pages-log.bat
$COMMIT | Out-File -Encoding UTF8 commit.bat

Write-Host "✅ 已生成 del-pages-log.bat 和 commit.bat" -ForegroundColor Green
Write-Host "📁 位置：$PWD" -ForegroundColor Cyan
pause