## ⚡ 一键生成配置文件

复制以下命令到 **PowerShell（Windows）** 或 **Terminal（Mac/Linux）** 执行：

### Windows（PowerShell）
```powershell
# 输入你的 Cloudflare 信息
$ACCOUNT_ID = Read-Host "请输入 ACCOUNT_ID"
$API_TOKEN = Read-Host "请输入 API_TOKEN"  
$PROJECT_NAME = Read-Host "请输入 PROJECT_NAME"

# 自动生成 del-pages-log.bat
@"
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Cloudflare Pages 历史版本清理工具
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
echo 📅 保留策略: 保留最新 5 个版本
echo.

call npx --yes cf-deploy-cleanup -s=5

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
"@ | Out-File -Encoding UTF8 del-pages-log.bat

Write-Host "`n✅ 配置文件已生成：del-pages-log.bat" -ForegroundColor Green