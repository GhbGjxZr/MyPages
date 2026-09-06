@echo off

:: 设置控制台为 UTF-8 编码
chcp 65001 >nul 2>&1

setlocal enabledelayedexpansion

:: ============================================
::   Git + Cloudflare Pages 工具生成器
::   修复版本 v1.3
:: ============================================

title Git + Cloudflare Pages 工具生成器

:: 获取脚本目录
set "SCRIPT_DIR=%~dp0"

cd /d "%SCRIPT_DIR%"

:: 显示初始信息
cls

echo ============================================================
echo   Git 提交 + Cloudflare Pages 清理工具
echo   分步生成器 v1.3
echo ============================================================
echo/

echo 本脚本将引导您完成以下步骤：
echo   1. 环境检查

echo   2. 获取 Cloudflare 账户 ID

echo   3. 获取 Cloudflare API 令牌

echo   4. 获取 Cloudflare Pages 项目名称

echo   5. 获取 GitHub 仓库信息

echo   6. 生成文件
echo/

echo ============================================================
echo/

pause

:: ============================================
:: 步骤 1：环境检查
:: ============================================

cls

echo ============================================================
echo   步骤 1/6：环境检查
echo ============================================================
echo/

:: 检查 Git
echo [检查] Git...

git --version >nul 2>&1

if errorlevel 1 (
    cls
    echo ============================================================
    echo   [错误] Git 未安装或未添加到 PATH 环境变量！
    echo ============================================================
    echo/
    echo 自动从该地址安装 Git：https://git-scm.com/download/win
    echo/
    powershell -c "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe' -OutFile 'Git.exe'"
    echo 下载完成
    exit /b 1
)

echo [通过] Git 已安装

for /f "tokens=*" %%a in ('git --version') do echo 版本：%%a

:: 检查 Node.js
echo [检查] Node.js...

node --version >nul 2>&1

if errorlevel 1 (
    cls
    echo ============================================================
    echo   [错误] Node.js 未安装或未添加到 PATH 环境变量！
    echo ============================================================
    echo/
    echo 自动从该地址安装 Node.js：https://nodejs.org/
    echo/
    powershell -c "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.18.0/node-v20.18.0-x64.msi' -OutFile 'Node.msi'"
    echo 下载完成   
    exit /b 1
)

echo [通过] Node.js 已安装

for /f "tokens=*" %%a in ('node --version') do echo 版本：%%a

echo/

echo ============================================================
echo   [完成] 所有检查通过！
echo ============================================================
echo/

pause

:: ============================================
:: 步骤 2：获取 Cloudflare 账户 ID
:: ============================================

cls

echo ============================================================
echo   步骤 2/6：获取 Cloudflare 账户 ID
echo ============================================================
echo/

echo 正在打开 Cloudflare 控制面板...

start "" "https://dash.cloudflare.com/"

echo/

echo 如何获取账户 ID：

echo   1. 登录 Cloudflare

echo   2. 点击左侧菜单中的"Pages"

echo   3. 在页面中找到账户 ID

echo   4. 或者直接查看 URL：https://dash.cloudflare.com/中间这个就是账户ID/pages
echo/

echo 账户 ID 是一个 32 位十六进制字符串。

echo ============================================================
echo/

:input_account
set /p ACCOUNT_ID="请输入 Cloudflare 账户 ID："

if "%ACCOUNT_ID%"=="" (
    echo [警告] 不能为空！
    goto input_account
)

:: 移除可能的空格（防止意外）
set ACCOUNT_ID=!ACCOUNT_ID: =!

:: 严格验证：必须是32位十六进制字符
echo !ACCOUNT_ID!| findstr /r "^[0-9a-fA-F]\{32\}$" >nul

if errorlevel 1 (
    echo [错误] 账户 ID 格式无效！
    echo 要求：32位十六进制字符（0-9, a-f, A-F）
    echo 示例：a1b2c3d4e5f67890a1b2c3d4e5f67890
    echo.
    goto input_account
)

echo/

echo [通过] 账户 ID：%ACCOUNT_ID%

echo/

pause

:: ============================================
:: 步骤 3：获取 Cloudflare API 令牌
:: ============================================

cls

echo ============================================================
echo   步骤 3/6：获取 Cloudflare API 令牌
echo ============================================================
echo/

echo 正在打开 API 令牌创建页面...

start "" "https://dash.cloudflare.com/profile/api-tokens"

echo/

echo 如何创建 API 令牌：

echo   1. 点击"创建令牌"

echo   2. 选择"编辑 Cloudflare Workers"模板

echo   3. 所需权限：

echo      - 账户：Pages：编辑

echo      - 账户：账户设置：读取

echo   4. 选择您的账户

echo   5. 点击"创建令牌"

echo   6. 复制令牌（仅显示一次！）
echo/

echo 警告：令牌仅显示一次！

echo ============================================================
echo/

:input_token
set /p API_TOKEN="请输入 Cloudflare API 令牌："

if "%API_TOKEN%"=="" (
    echo [警告] 不能为空！
    goto input_token
)
:: 支持 cfat_ 和 cfut_
echo !API_TOKEN!| findstr /r "^cf[au]t_[0-9a-zA-Z]\{36,\}$" >nul

if errorlevel 1 (
    echo [错误] 格式无效！支持：cfat_ 或 cfut_ 开头
    goto input_token
)

if !token_len! lss 40 (
    echo [警告] 令牌似乎太短，已跳过验证，继续执行...
)

echo/

echo [通过] 令牌：%API_TOKEN:~0,8%...%API_TOKEN:~-4%

echo/

pause

:: ============================================
:: 步骤 4：获取 Cloudflare Pages 项目名称
:: ============================================

cls

echo ============================================================
echo   步骤 4/6：获取 Cloudflare Pages 项目名称
echo ============================================================
echo/

echo 正在打开 Cloudflare Pages 控制台...

start "" "https://dash.cloudflare.com/?to=/:account/pages"

echo/

echo 如何获取项目名称：

echo   1. 点击左侧菜单中搜索"Workers 和 Pages"

echo   2. 查看现有项目

echo   3. 或者创建一个新项目
echo/

echo 项目名称：字母、数字和连字符（-）

echo ============================================================
echo/

:input_project
set /p PROJECT_NAME="请输入 Cloudflare Pages 项目名称："

if "%PROJECT_NAME%"=="" (
    echo [警告] 不能为空！
    goto input_project
)

:: 验证项目名称格式
echo %PROJECT_NAME%| findstr /r "^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$" >nul

if errorlevel 1 (
    echo [警告] 项目名称格式可能不正确（应以字母或数字开头和结尾，只允许字母、数字和连字符），已跳过验证，继续执行...
)

echo/

echo [通过] 项目名称：%PROJECT_NAME%

echo/

pause

:: ============================================
:: 步骤 5：获取 GitHub 仓库信息
:: ============================================

cls

echo ============================================================
echo   步骤 5/6：获取 GitHub 仓库信息
echo ============================================================
echo/

echo 正在打开 GitHub...

start "" "https://github.com/"

echo/

:input_repo
echo -------------------------------------------
echo GitHub 仓库 URL：

echo   格式：https://github.com/用户名/仓库名.git
echo/

set /p REPO_URL="请输入 GitHub 仓库 URL："

if "%REPO_URL%"=="" (
    echo [警告] 不能为空！
    goto input_repo
)

:: 验证 URL 格式
echo %REPO_URL%| findstr /r "^https://github\.com/[^/]\+/[^/]\+\.git$" >nul

if errorlevel 1 (
    echo [警告] URL 格式可能不正确（应为：https://github.com/用户名/仓库名.git），已跳过验证，继续执行...
)

:input_pages
echo/

echo -------------------------------------------
echo GitHub Pages URL：

echo   格式：https://用户名.github.io/仓库名/
echo/

set /p PAGES_URL="请输入 GitHub Pages URL："

if "%PAGES_URL%"=="" (
    echo [警告] 不能为空！
    goto input_pages
)

:: 验证 GitHub Pages URL
echo %PAGES_URL%| findstr /r "^https://[^/]\+\.github\.io/[^/]\+/$" >nul

if errorlevel 1 (
    echo [警告] URL 格式可能不正确（应为：https://用户名.github.io/仓库名/），已跳过验证，继续执行...
)

:input_cf_pages
echo/

echo -------------------------------------------
echo Cloudflare Pages URL：

echo   格式：https://项目名.pages.dev
echo/

echo 正在打开 Cloudflare Pages...

start "" "https://dash.cloudflare.com/?to=/:account/pages"

echo/

set /p CLOUDFLARE_URL="请输入 Cloudflare Pages URL："

if "%CLOUDFLARE_URL%"=="" (
    echo [警告] 不能为空！
    goto input_cf_pages
)

:: 验证 Cloudflare Pages URL
echo %CLOUDFLARE_URL%| findstr /r "^https://[^/]\+\.pages\.dev$" >nul

if errorlevel 1 (
    echo [警告] URL 格式可能不正确（应为：https://项目名.pages.dev），已跳过验证，继续执行...
)

echo/

echo ============================================================
echo   GitHub 信息已录入
echo ============================================================
echo/
echo ::
echo GitHub 仓库：%REPO_URL%

echo GitHub Pages：%PAGES_URL%

echo Cloudflare Pages：%CLOUDFLARE_URL%

echo/

pause

:: ============================================
:: 步骤 6：生成文件
:: ============================================

cls

echo ============================================================
echo   步骤 6/6：生成文件
echo ============================================================
echo/

echo 配置摘要：

echo -------------------------------------------
echo 账户 ID：%ACCOUNT_ID%

echo API 令牌：%API_TOKEN:~0,8%...%API_TOKEN:~-4%

echo 项目名称：%PROJECT_NAME%

echo GitHub URL：%REPO_URL%

echo Pages URL：%PAGES_URL%

echo Cloudflare URL：%CLOUDFLARE_URL%

echo -------------------------------------------
echo/

echo 正在生成文件...

echo/

:generate_files
:: 如果输出目录不存在则创建
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"

set "OUTPUT_DIR=%SCRIPT_DIR%output"

:: 生成 commit.bat
echo [生成] commit.bat...

(
echo @echo off

echo :: 设置控制台为 UTF-8 编码

echo chcp 65001 ^>nul 2^>^&1

echo setlocal enabledelayedexpansion

echo/

echo :: 设置脚本目录

echo cd /d "%%~dp0"

echo/

echo echo ================================

echo echo   一键提交并推送

echo echo ================================

echo echo/

echo/

echo :: 检查是否为 git 仓库

echo git status --porcelain ^>nul 2^>^&1

echo if errorlevel 1 ^(

echo     echo [错误] 不是 git 仓库！

echo     echo/

echo     echo 请确保您在 git 仓库根目录运行此脚本。

echo     pause

echo     exit /b 1

echo ^)

echo/

echo :: 检查是否有更改

echo git diff --quiet

echo if errorlevel 1 ^(

echo     echo [通过] 检测到更改

echo ^) else ^(

echo     git diff --cached --quiet

echo     if errorlevel 1 ^(

echo         echo [通过] 检测到暂存的更改

echo     ^) else ^(

echo         echo [警告] 没有需要提交的更改

echo         pause

echo         exit /b 0

echo     ^)

echo ^)

echo/

echo echo/

echo :: 询问提交信息，提供默认值

echo set /p msg="提交信息（回车使用默认：update）："

echo if "%%msg%%"=="" set msg=update

echo/

echo echo/

echo echo [操作] 添加所有更改...

echo git add .

echo if errorlevel 1 ^(

echo     echo [错误] 添加更改失败！

echo     pause

echo     exit /b 1

echo ^)

echo/

echo echo [操作] 提交...

echo git commit -m "%%msg%%"

echo if errorlevel 1 ^(

echo     echo [错误] 提交失败！

echo     pause

echo     exit /b 1

echo ^)

echo/

echo echo [操作] 推送到远程仓库...

echo git push

echo if errorlevel 1 ^(

echo     echo [错误] 推送失败！

echo     echo/

echo     echo 请检查：

echo     echo 1. 远程仓库是否存在

echo     echo 2. 您是否有推送权限

echo     echo 3. 网络连接

echo     pause

echo ^) else ^(

echo     echo [通过] 推送成功！

echo     echo/

echo     echo [操作] 正在打开页面...

echo    ::

echo     start "" "%REPO_URL%"

echo    ::

echo     start "" "%PAGES_URL%"

echo    ::

echo     start "" "%CLOUDFLARE_URL%"

echo     echo/

echo     echo [操作] 正在清理 Cloudflare Pages 历史记录...

echo     del-pages-log.bat

echo ^)

echo/

echo echo/

echo pause

echo exit /b 0
) > "%OUTPUT_DIR%\commit.bat"

echo [通过] commit.bat 已生成！

:: 生成 del-pages-log.bat
echo [生成] del-pages-log.bat...

(
echo @echo off

echo :: 设置控制台为 UTF-8 编码

echo chcp 65001 ^>nul 2^>^&1

echo setlocal enabledelayedexpansion

echo/

echo :: ============================================

echo :: Cloudflare Pages 历史记录清理工具

echo :: ============================================

echo/

echo :: 设置脚本目录

echo cd /d "%%~dp0"

echo/

echo :: Cloudflare 设置（隐藏输出）

echo set ACCOUNT_ID=%ACCOUNT_ID%

echo set API_TOKEN=%API_TOKEN%

echo set PROJECT_NAME=%PROJECT_NAME%

echo/

echo :: 设置环境变量

echo set CLOUDFLARE_ACCOUNT_ID=%%ACCOUNT_ID%%

echo set CLOUDFLARE_API_TOKEN=%%API_TOKEN%%

echo set CLOUDFLARE_PROJECT_NAME=%%PROJECT_NAME%%

echo/

echo echo ========================================

echo echo   Cloudflare Pages 清理工具

echo echo ========================================

echo echo/

echo echo 项目：%%PROJECT_NAME%%

echo echo 保留策略：保留最新 3 个版本

echo echo/

echo/

echo :: 执行清理

echo call npx --yes cf-deploy-cleanup -s=3

echo/

echo if %%errorlevel%% equ 0 ^(

echo     echo/

echo     echo ========================================

echo     echo   [通过] 清理完成！

echo     echo ========================================

echo ^) else ^(

echo     echo/

echo     echo ========================================

echo     echo   [错误] 清理失败

echo     echo ========================================

echo     echo/

echo     echo 请检查：

echo     echo 1. API 令牌是否有效

echo     echo 2. 项目名称是否正确

echo     echo 3. 网络连接

echo     echo 4. 您是否有足够的权限

echo ^)

echo/

echo echo/

echo pause

echo exit /b %%errorlevel%%
) > "%OUTPUT_DIR%\del-pages-log.bat"

echo [通过] del-pages-log.bat 已生成！

:: 创建 README
echo [生成] README.md...

powershell -Command "$content = '# Git + Cloudflare Pages 清理工具' + [Environment]::NewLine + [Environment]::NewLine + '## 文件说明' + [Environment]::NewLine + '- commit.bat - 一键提交并推送' + [Environment]::NewLine + '- del-pages-log.bat - 清理 Cloudflare Pages 部署历史' + [Environment]::NewLine + '- .gitignore - 预配置忽略敏感文件' + [Environment]::NewLine + [Environment]::NewLine + '## 使用方法' + [Environment]::NewLine + '1. 将所有文件复制到您的 git 仓库根目录' + [Environment]::NewLine + '2. 运行 commit.bat 提交并推送更改' + [Environment]::NewLine + '3. 推送后将自动清理 Cloudflare Pages' + [Environment]::NewLine + [Environment]::NewLine + '## 安全提示' + [Environment]::NewLine + '**重要**：del-pages-log.bat 包含您的 API 令牌！' + [Environment]::NewLine + '- .gitignore 已配置为排除它' + [Environment]::NewLine + '- 切勿将 del-pages-log.bat 提交到公开仓库' + [Environment]::NewLine + [Environment]::NewLine + '## 自定义设置' + [Environment]::NewLine + '要更改保留版本数量，请修改 del-pages-log.bat 中的 -s=1 参数：' + [Environment]::NewLine + '- -s=5 保留最新 5 个版本' + [Environment]::NewLine + '- -s=0 删除所有版本（请谨慎使用！）' + [Environment]::NewLine + [Environment]::NewLine + '## 环境要求' + [Environment]::NewLine + '- Git' + [Environment]::NewLine + '- Node.js（包含 npx）' + [Environment]::NewLine + '- 具有 Pages 权限的 Cloudflare 账户' + [Environment]::NewLine + [Environment]::NewLine + '## 故障排除' + [Environment]::NewLine + '如遇问题，请检查：' + [Environment]::NewLine + '- Git 已安装并配置' + [Environment]::NewLine + '- Cloudflare API 令牌具有正确权限' + [Environment]::NewLine + '- 项目名称完全匹配'; [System.IO.File]::WriteAllText('%OUTPUT_DIR%\README.md', $content, [System.Text.UTF8Encoding]::new($true))"

echo [通过] README.md 已生成！

:: ============================================
:: 完成
:: ============================================

cls

echo ============================================================
echo   [完成] 所有文件已成功生成！
echo ============================================================
echo/

echo 文件生成位置：%OUTPUT_DIR%

echo/

echo 生成的文件：

echo   [1] commit.bat

echo   [2] del-pages-log.bat

echo   [4] README.md

echo/

echo ============================================================
echo   使用方法
echo ============================================================
echo/

echo 1. 将 output 文件夹中的所有文件复制到您的 Git 仓库根目录

echo 2. 运行 commit.bat 提交并推送

echo 3. 推送后将自动清理 Cloudflare Pages

echo/

echo ============================================================
echo   注意
echo ============================================================
echo/

echo * 修改 del-pages-log.bat 中的 -s=1 可更改保留数量

echo   -s=3 保留最新 3 个版本（默认3）

echo   -s=0 删除所有版本（请谨慎使用！）

echo/

echo ============================================================
echo   安全提示
echo ============================================================
echo/

echo [重要] del-pages-log.bat 包含您的 API 令牌！

echo [重要] .gitignore 已配置为排除它！

echo/

echo ============================================================
echo   准备就绪！
echo ============================================================
echo/

pause

exit /b 0