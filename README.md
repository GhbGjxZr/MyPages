# 🚀 MyPages

我的静态网页工具集

---

## 📖 配置教程

在开始之前，请准备好以下 Cloudflare 信息：

| 参数 | 获取方式 |
|------|----------|
| **ACCOUNT_ID** | 访问 [Cloudflare Dashboard](https://dash.cloudflare.com/)，右下角 **"账户 ID"** |
| **API_TOKEN** | 访问 [API Tokens](https://dash.cloudflare.com/profile/api-tokens) → 创建令牌 → 选择 **"编辑 Cloudflare Workers"**（⚠️ 只显示一次，请立即保存） |
| **PROJECT_NAME** | 访问 [Cloudflare Pages](https://dash.cloudflare.com/?to=/:account/pages)，复制你的项目名称 |


# 📦 工具：commit.bat 和 del-pages-log.bat

## commit.bat
      一键提交 Git 变更并推送到远程仓库，自动打开 GitHub 和 Cloudflare Pages。
## del-pages-log.bat
      清理 Cloudflare Pages 历史部署版本，保留最新 N 个版本。
<details>
<summary>📋 点击展开复制代码 </summary>

```cmd
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ================================
echo   Cloudflare Pages 配置向导
echo ================================
echo.

:: 获取用户输入
set /p ACCOUNT_ID="请输入 Cloudflare 账户 ID: "
set /p API_TOKEN="请输入 Cloudflare API Token: "
set /p PROJECT_NAME="请输入 Cloudflare Pages 项目名称: "
set /p KEEP_COUNT="保留版本数 (默认5): "
if "%KEEP_COUNT%"=="" set KEEP_COUNT=5

:: 获取 GitHub 远程地址
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set "GIT_URL=%%i"
if not "!GIT_URL!"=="" (
    set "GITHUB_URL=!GIT_URL:.git=!"
    set "GITHUB_URL=!GITHUB_URL:git@github.com:=https://github.com/!"
    echo.
    echo ✅ 检测到 GitHub 仓库: !GITHUB_URL!
)

:: 生成 commit.bat
(
echo @echo off
echo chcp 65001 ^>nul
echo setlocal enabledelayedexpansion
echo.
echo :: ===== 自动生成的配置 =====
echo set ACCOUNT_ID=%ACCOUNT_ID%
echo set PROJECT_NAME=%PROJECT_NAME%
echo :: ==========================
echo.
echo echo ================================
echo echo   一键提交并推送脚本
echo echo ================================
echo echo.
echo :: 检查 Git 仓库
echo git status --porcelain ^>nul 2^>^&1
echo if errorlevel 1 ^(
echo     echo ❌ 不是有效的 Git 仓库！
echo     pause
echo     exit /b 1
echo ^)
echo.
echo :: 检查是否有变更
echo git diff --quiet
echo set has_changes=0
echo if errorlevel 1 ^(
echo     set has_changes=1
echo ^) else ^(
echo     git diff --cached --quiet
echo     if errorlevel 1 ^(
echo         set has_changes=1
echo     ^)
echo ^)
echo.
echo if !has_changes! equ 0 ^(
echo     echo ⚠️ 没有需要提交的变更
echo     pause
echo     exit /b 0
echo ^)
echo.
echo echo ✅ 检测到变更，准备提交...
echo echo.
echo set /p msg="📝 请输入提交信息（直接回车默认：提交）: "
echo if "%%msg%%"=="" set msg=提交
echo.
echo echo 📤 正在添加所有变更...
echo git add .
echo.
echo echo 📝 正在提交...
echo git commit -m "%%msg%%"
echo.
echo if errorlevel 1 ^(
echo     echo ❌ 提交失败！
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo 🚀 正在推送到远程仓库...
echo git push
echo.
echo if errorlevel 1 ^(
echo     echo ❌ 推送失败！
echo     pause
echo ^) else ^(
echo     echo ✅ 推送成功！
echo     echo.
echo     echo 🌐 正在打开网页...
echo     for /f "tokens=*" %%%%i in ^('git remote get-url origin 2^>nul'^) do set "GIT_URL=%%%%i"
echo     if not "!GIT_URL!"=="" ^(
echo         set "GITHUB_URL=!GIT_URL:.git=!"
echo         set "GITHUB_URL=!GITHUB_URL:git@github.com:=https://github.com/!"
echo         start "" "!GITHUB_URL!"
echo     ^)
echo     start "" "https://dash.cloudflare.com/%ACCOUNT_ID%/pages/view/%PROJECT_NAME%"
echo     echo.
echo     echo 📌 运行清理脚本? (y/N)
echo     set /p run_clean=""
echo     if /i "!run_clean!"=="y" call del-pages-log.bat
echo ^)
echo.
echo pause
) > commit.bat

:: 生成 del-pages-log.bat
(
echo @echo off
echo chcp 65001 ^>nul
echo setlocal enabledelayedexpansion
echo.
echo :: ===== 自动生成的配置 =====
echo set ACCOUNT_ID=%ACCOUNT_ID%
echo set API_TOKEN=%API_TOKEN%
echo set PROJECT_NAME=%PROJECT_NAME%
echo set KEEP_COUNT=%KEEP_COUNT%
echo :: ==========================
echo.
echo echo ========================================
echo echo   🧹 清理 Cloudflare Pages 历史版本
echo echo ========================================
echo echo.
echo echo 📁 项目: %%PROJECT_NAME%%
echo echo 📅 保留策略: 保留最新 %%KEEP_COUNT%% 个版本
echo echo.
echo echo ⚠️  注意：此操作将删除旧版本部署，不可恢复！
echo echo.
echo set /p confirm="确认继续？(y/N): "
echo if /i not "%%confirm%%"=="y" ^(
echo     echo ❌ 已取消操作
echo     pause
echo     exit /b 0
echo ^)
echo.
echo echo 🚀 正在清理...
echo call npx --yes cf-deploy-cleanup -s=%%KEEP_COUNT%% ^
echo     --account-id=%%ACCOUNT_ID%% ^
echo     --api-token=%%API_TOKEN%% ^
echo     --project=%%PROJECT_NAME%%
echo.
echo if errorlevel 1 ^(
echo     echo.
echo     echo ========================================
echo     echo   ❌ 清理失败
echo     echo ========================================
echo     echo.
echo     echo 请检查配置信息是否正确
echo ^) else ^(
echo     echo.
echo     echo ========================================
echo     echo   ✅ 清理完成！
echo     echo ========================================
echo ^)
echo.
echo pause
) > del-pages-log.bat

echo.
echo ================================
echo   ✅ 配置生成完成！
echo ================================
echo.
echo 已生成以下文件：
echo   📄 commit.bat       - 一键提交推送脚本
echo   📄 del-pages-log.bat - 清理历史版本脚本
echo.
echo 使用方法：
echo   commit.bat      - 提交并推送代码
echo   del-pages-log.bat - 清理 Cloudflare Pages 历史版本
echo.
pause
```