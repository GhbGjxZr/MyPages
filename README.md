# 🚀 MyPages

我的静态网页工具集

---

## 📖 静态网页快速部署教程

# 🚀 从 GitHub 到 Cloudflare：实现推送即部署的静态网站

> 告别手动上传，每次 `git push` 代码到 GitHub，网站自动更新部署。  
> 本教程将带你使用 **Cloudflare Pages** 的 Git 集成功能，连接你的 GitHub 仓库，开启全自动部署之旅。

---

## 📖 目录

- [核心优势](#-核心优势)
- [准备工作](#-准备工作)
- [第一步：将代码推送到 GitHub](#-第一步将代码推送到-github)
- [第二步：在 Cloudflare Pages 中连接 GitHub](#-第二步在-cloudflare-pages-中连接-github)
- [第三步：推送代码，自动更新](#-第三步推送代码自动更新)
- [进阶玩法](#-进阶玩法)
- [常见问题](#-常见问题)
- [更多资源](#-更多资源)

---

## ✨ 核心优势

- **⚡ 全自动部署**：每次 `git push` 代码到 GitHub，网站会自动重新部署，无需手动操作。
- **🌐 全球 CDN 加速**：借助 Cloudflare 的全球网络，国内外访问速度都更快。
- **🔒 免费 HTTPS**：自动为你的网站开启 SSL 加密，安全可靠。
- **🧪 预览环境**：可为 Pull Request 自动生成预览链接，方便测试和评审。
- **💰 完全免费**：Cloudflare Pages 的免费额度足够个人和小型项目使用。

---

## 📋 准备工作

在开始之前，你需要准备：

- [ ] 一个 **GitHub 账号**（[点击注册](https://github.com/signup)）
- [ ] 一个 **Cloudflare 账号**（[点击注册](https://dash.cloudflare.com/sign-up)）
- [ ] 你的静态网站源码（包含 `index.html` 的文件夹）

> **💡 小贴士**：纯静态 HTML 项目，请确保首页文件名为 `index.html`（全小写），这是网页服务器默认寻找的文件。

---

## 🎯 第一步：将代码推送到 GitHub

### 1.1 创建 GitHub 仓库

1. 登录 GitHub，点击右上角的 **+** → **New repository**。
2. 填写仓库名称（如 `my-web`）。
3. 建议勾选 **Private**（私有），保护你的源码。
4. 点击 **Create repository** 完成创建。

### 1.2 上传你的代码

在本地项目文件夹中打开终端（或命令行），执行以下命令：

```bash
git init
git add .
git commit -m "首次提交"
git branch -M main
git remote add origin https://github.com/你的用户名/你的仓库名.git
git push -u origin main
```

> **📌 不熟悉 Git 命令？**  
> 也可以在 GitHub 网页端通过 **"Add file" → "Upload files"** 直接上传你的 `index.html` 和资源文件。

---

## ⚙️ 第二步：在 Cloudflare Pages 中连接 GitHub

### 2.1 进入 Cloudflare Pages

1. 登录 [Cloudflare 仪表板](https://dash.cloudflare.com/)。
2. 在左侧菜单中找到并点击 **Workers & Pages**。

### 2.2 创建 Pages 项目

1. 点击 **创建应用程序** → 切换到 **Pages** 标签页 → 点击 **连接到 Git**。

### 2.3 授权并选择仓库

1. 选择 **GitHub** 作为 Git 提供商。
2. 按提示完成 GitHub 授权（首次使用需要授权）。
3. 授权后，选择你刚刚创建的 GitHub 仓库（如 `my-web`）。

### 2.4 设置构建和部署（关键步骤）

在 **"设置构建和部署"** 页面，按以下配置填写：

| 配置项 | 填写内容 | 说明 |
|--------|----------|------|
| **项目名称** | 自定义名称（如 `my-web`） | 会作为 `*.pages.dev` 子域名的一部分 |
| **生产分支** | `main` | 即你推送代码的分支 |
| **框架预设** | **无** | 纯静态网站无需构建工具 |
| **构建命令** | **留空** | 纯静态网站无需构建命令 |
| **构建输出目录** | **留空** | 或填写 `/`（表示根目录） |

4. 点击 **"保存并部署"**。

### 2.5 等待部署完成

- Cloudflare 会自动拉取你的代码并部署。
- 部署完成后，会生成一个 `*.pages.dev` 的预览链接。
- 点击链接即可访问你的网站，例如：`https://my-web.pages.dev`。

---

## 🔄 第三步：推送代码，自动更新

从此以后，每次你更新代码并推送到 GitHub 的 `main` 分支，Cloudflare Pages 都会**自动重新部署**你的网站。

```bash
git add .
git commit -m "更新了网站内容"
git push origin main
```

> 推送后，稍等 1-2 分钟，刷新你的 `*.pages.dev` 网址，即可看到更新！

---

## ✨ 进阶玩法

### 🌐 绑定自定义域名

1. 进入你的 Pages 项目设置。
2. 找到 **"自定义域"** 或 **"Custom domains"**。
3. 点击 **"设置自定义域"**，输入你的域名（如 `www.example.com`）。
4. 按指引在域名服务商处添加一条 **CNAME 记录**，指向 Cloudflare 提供的目标地址（如 `my-web.pages.dev`）。

> **📌 注意**：如果你使用 Cloudflare 管理 DNS，添加自定义域会更简单，可一键配置。

### 🧪 预览部署

- 当你创建 Pull Request 时，Cloudflare 会自动生成一个预览链接。
- 预览链接可以在合并前进行检查和测试，非常适合团队协作。

### 🔧 使用构建工具（如 React/Vue）

如果你的项目需要构建（如 React、Vue、Vite 等），在 **"设置构建和部署"** 中配置：

| 配置项 | 示例值 |
|--------|--------|
| **框架预设** | 选择对应的框架（如 React、Vue） |
| **构建命令** | `npm run build` 或 `yarn build` |
| **构建输出目录** | `dist` 或 `build`（根据框架而定） |

---

## ❓ 常见问题

### Q1：部署后访问显示 404？

- 检查你的 HTML 文件是否命名为 `index.html`（**全小写**），这是最常见的原因。
- 确保 `index.html` 位于仓库的根目录，而不是子文件夹中。

### Q2：页面修改后没有更新？

- Cloudflare Pages 有 1-2 分钟缓存延迟，请耐心等待。
- 按 `Ctrl + F5`（Windows）或 `Cmd + Shift + R`（Mac）强制刷新浏览器缓存。
- 检查推送的分支是否与 Cloudflare 设置的生产分支一致（默认是 `main`）。

### Q3：如何跳过某次部署？

- 可以在 commit message 中加入 `[skip ci]` 或 `[ci skip]` 前缀，例如：
  ```bash
  git commit -m "[skip ci] 只是更新了文档，不需要部署"
  ```

### Q4：可以上传图片吗？

可以！两种方式：
- 在仓库中创建 `images` 文件夹，上传图片后使用路径：`/images/photo.jpg`。
- 使用免费图床服务（如 [Cloudflare Images](https://www.cloudflare.com/products/cloudflare-images/) 或 [Imgur](https://imgur.com/)）获取外部链接。

### Q5：我的网站是动态的（需要后端）怎么办？

Cloudflare Pages 主要针对**静态网站**。如果你需要后端功能，可以结合 Cloudflare Workers 或使用全栈框架（如 Next.js、Nuxt.js 等）的 SSR（服务端渲染）模式。

---

## 📚 更多资源

- 📖 [Cloudflare Pages 官方文档](https://developers.cloudflare.com/pages/)
- 🎨 [免费 HTML 模板](https://html5up.net/)
- 🖼️ [免费图片素材](https://unsplash.com/)
- 🔤 [图标库 Font Awesome](https://fontawesome.com/)
- 💬 [Cloudflare 开发者社区](https://community.cloudflare.com/)

---

## 🎉 恭喜你！

你现在已经拥有了一个 **"推送即部署"** 的个人静态网站！  
每次修改代码推送到 GitHub，网站都会自动更新，省时省力。

**记住：**
- 每一次修改都是一次进步 🚀
- 不要害怕犯错（Git 可以回滚 🔄）
- 享受创造的乐趣！✨

---

> 💡 **小贴士**：如果遇到任何问题，可以在本仓库的 Issues 中提问，或搜索 [Cloudflare Pages 常见问题](https://developers.cloudflare.com/pages/faq/)
