# ================================================================
# 🚀 GitHub Pages 自动部署脚本
# ================================================================
# 使用方法：
#   1. 在 GitHub 创建仓库，例如 love-site
#   2. 修改 GITHUB_REPO 为你的仓库地址
#   3. PowerShell 运行: .\_deploy.ps1
# ================================================================

 = "https://github.com/YOUR_USERNAME/love-site.git"
 = "💕 更新情侣网页 - 2026-05-28 19:23"

Set-Location "E:\情侣网页"

# 初始化 Git
if (-not (Test-Path ".git")) {
    Write-Host "📦 初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# 远程仓库
 = git remote get-url origin 2>
if (-not ) {
    Write-Host "🔗 添加远程仓库: " -ForegroundColor Yellow
    git remote add origin 
} else {
    Write-Host "🔗 远程仓库: " -ForegroundColor Green
}

# 添加 .nojekyll
"" | Out-File ".nojekyll" -Encoding ASCII -NoNewline

# 创建 music 文件夹占位
if (-not (Test-Path "music")) {
    New-Item -ItemType Directory -Path "music" -Force | Out-Null
}
if (-not (Test-Path "music\.gitkeep")) {
    "将你的背景音乐文件命名为 bg.mp3 放到此文件夹" | Out-File "music\README.txt" -Encoding UTF8
    "" | Out-File "music\.gitkeep" -Encoding ASCII
}

# 提交所有文件
git add index.html admin.html config.json .gitignore .nojekyll _deploy.ps1 photos/ music/ 2>

 = git status --porcelain
if () {
    git commit -m 
    Write-Host "✅ 已提交" -ForegroundColor Green
} else {
    Write-Host "ℹ️ 无更改" -ForegroundColor Gray
}

# 推送
Write-Host "📤 推送中..." -ForegroundColor Yellow
git push -u origin main

if ( -eq 0) {
    Write-Host ""
    Write-Host "🎉 部署成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "📌 接下来去 GitHub 仓库 → Settings → Pages 启用 Pages" -ForegroundColor Cyan
    Write-Host "   Source: Deploy from a branch → main → / (root) → Save"
    Write-Host ""
    Write-Host "🌐 前台地址: https://你的用户名.github.io/love-site/" -ForegroundColor Magenta
    Write-Host "🔧 后台地址: https://你的用户名.github.io/love-site/admin.html" -ForegroundColor Magenta
    Write-Host "🔑 后台密码: love2024"
    Write-Host ""
    Write-Host "📋 更新内容流程:" -ForegroundColor Cyan
    Write-Host "   1. 打开后台 → 编辑 → 点「🚀 发布到线上」下载 config.json"
    Write-Host "   2. 把 config.json 放到此文件夹"
    Write-Host "   3. 重新运行此脚本"
} else {
    Write-Host "❌ 推送失败！检查 GITHUB_REPO 是否正确" -ForegroundColor Red
}
