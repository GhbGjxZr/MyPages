name: 生成配置文件

on:
  workflow_dispatch:
    inputs:
      account_id:
        description: 'Cloudflare ACCOUNT_ID'
        required: true
        type: string
      api_token:
        description: 'Cloudflare API_TOKEN'
        required: true
        type: string
      project_name:
        description: 'Cloudflare PROJECT_NAME'
        required: true
        type: string

jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: 生成配置文件
        run: |
          cat > del-pages-log.bat << EOF
          @echo off
          chcp 65001 >nul
          setlocal enabledelayedexpansion
          
          set ACCOUNT_ID=${{ github.event.inputs.account_id }}
          set API_TOKEN=${{ github.event.inputs.api_token }}
          set PROJECT_NAME=${{ github.event.inputs.project_name }}
          
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
          EOF
      
      - name: 上传配置文件
        uses: actions/upload-artifact@v3
        with:
          name: del-pages-log
          path: del-pages-log.bat