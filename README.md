# MyPages
我的静态网页工具

## 一键下载配置脚本
点击下方按钮自动生成并下载 `del-pages-log.bat` 配置文件：

<button onclick="generateAndDownload()" style="padding:10px 20px;background:#4CAF50;color:white;border:none;border-radius:5px;cursor:pointer;font-size:16px;">
  ⬇️ 下载配置文件（已填充你的信息）
</button>

<script>
function generateAndDownload() {
  // 这里是你从用户输入获取的变量
  const accountId = prompt('请输入你的 Cloudflare ACCOUNT_ID（账户ID）:');
  if (!accountId) return;
  
  const apiToken = prompt('请输入你的 API_TOKEN（API令牌）:');
  if (!apiToken) return;
  
  const projectName = prompt('请输入你的 PROJECT_NAME（项目名称）:');
  if (!projectName) return;

  // 生成完整的 bat 文件内容
  const batContent = `@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
:: Cloudflare Pages 历史版本清理工具
:: ============================================

:: 请在此处填写你的信息
set ACCOUNT_ID=${accountId}
set API_TOKEN=${apiToken}
set PROJECT_NAME=${projectName}

:: ============================================
:: 设置环境变量
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

:: 执行清理
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
pause`;

  // 创建下载
  const blob = new Blob([batContent], { type: 'text/plain;charset=utf-8' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = 'del-pages-log.bat';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(link.href);
}
</script>

### 📖 配置教程
#### 1. 获取 ACCOUNT_ID（账户ID）：
    https://dash.cloudflare.com → 右下角 "账户 ID"
#### 2. 获取 API_TOKEN（API令牌）：
    https://dash.cloudflare.com/profile/api-tokens
    → 创建令牌 → 选择 "编辑 Cloudflare Workers" 权限
#### 3. 获取 PROJECT_NAME（项目名称）：
    https://dash.cloudflare.com/?to=/:account/pages
    → 查看你的 Pages 项目名称