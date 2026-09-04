@echo off
chcp 65001 >nul
echo ================================
echo   一键提交并推送脚本
echo ================================
echo.

:: 检查是否有变更
git status --porcelain >nul 2>&1
if errorlevel 1 (
    echo ❌ 不是有效的 Git 仓库！
    pause
    exit /b 1
)

:: 检查是否有未提交的变更
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
:: 询问提交信息
set /p msg="📝 请输入提交信息（直接回车使用默认：提交）: "
if "%msg%"=="" set msg=提交

echo.
echo 📤 正在添加所有变更...
git add .

echo 📝 正在提交...
git commit -m "%msg%"

:: 检查提交是否成功
if errorlevel 1 (
    echo ❌ 提交失败！
    pause
    exit /b 1
)

echo 🚀 正在推送到远程仓库...
git push

:: 检查推送是否成功
if errorlevel 1 (
    echo ❌ 推送失败，请检查网络或权限！
    pause
) else (
    echo ✅ 推送成功！
    echo.
    echo 🌐 正在打开 GitHub Pages...
    start "" "https://github.com/GhbGjxZr/MyPages"
    start "" "https://dash.cloudflare.com/1fa9f1235b0a82feecbf0687901ba61c/workers-and-pages"
)

:: 自动关闭窗口
exit