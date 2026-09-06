# 🚀 MyPages

我的静态网页工具集

---

## 📖 配置教程

在开始之前，请准备好以下 Cloudflare 信息：

# 注意

>克隆到本地后,直接双击 co-de.bat 会有一个详细的教程

## 环境要求
- **Git** 必须已安装并添加到 `PATH` 环境变量中。

  `可以手动下载,脚本会自动下载`
    ```
    powershell -c "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe' -OutFile 'Git.exe'"
    ```
- **Node.js** 必须已安装并添加到 `PATH` 环境变量中（包含 `npx`）。

  `可以手动下载,脚本会自动下载`
    ```
    powershell -c "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.18.0/node-v20.18.0-x64.msi' -OutFile 'Node.msi'"
    ```
- 系统需支持 `chcp 65001` 命令（Windows 控制台 UTF-8 编码）。

---

## 输入信息注意事项
- **Cloudflare 账户 ID**：为 32 位十六进制字符串，仅含 `0-9`、`a-f`、`A-F`。
- **Cloudflare API 令牌**：
  - 仅在创建时显示一次，请及时保存。
  - 需具有 `Pages：编辑` 和 `账户设置：读取` 权限。
  - 建议长度至少 40 个字符。
- **Cloudflare Pages 项目名称**：
  - 应以字母或数字开头和结尾。
  - 只允许字母、数字和连字符（`-`）。
- **GitHub 仓库 URL**：格式必须为 `https://github.com/用户名/仓库名.git`。
- **GitHub Pages URL**：格式必须为 `https://用户名.github.io/仓库名`。
- **Cloudflare Pages URL**：格式必须为 `https://dash.cloudflare.com/账户ID/pages/view/项目名`。

---

## 生成文件使用注意事项
- **`del-pages-log.bat` 包含您的 API 令牌**，属于敏感信息。
- **`.gitignore` 已配置为排除 `del-pages-log.bat`**，请勿将其提交到公开仓库。
- 如需更改保留版本数量，请修改 `del-pages-log.bat` 中的 `-s=3` 参数：
  - `-s=3`：保留最新 3 个版本（默认）。
  - `-s=0`：删除所有版本（请谨慎使用！）。

---

## 运行注意事项
- 请确保在 **Git 仓库根目录** 下运行生成的脚本。
- 推送前请检查网络连接和远程仓库权限。
- Cloudflare 清理操作需要网络连接及有效的 API 权限。

---

## 其他提示
- 脚本会尝试打开浏览器页面（Cloudflare、GitHub）辅助操作，请确保网络正常。
- 所有生成的输出文件位于脚本同级的 `output` 文件夹中。

# 📦 工具：commit.bat 和 del-pages-log.bat

## commit.bat

> 一键提交 Git 变更并推送到远程仓库，自动打开 GitHub 和 Cloudflare Pages。

## del-pages-log.bat

> 清理 Cloudflare Pages 历史部署版本，保留最新 N 个版本。
