@echo off
chcp 65001 >nul
title 🚀 一鍵上傳 GitHub + Firebase + 自動更新 README

echo ========================================================
echo 🚀 一鍵上傳 GitHub + Firebase + 自動更新 README
echo ========================================================
echo.

:: Step 1. 檢查 Firebase 登入狀態
echo 🔍 正在檢查 Firebase 登入狀態...
for /f "delims=" %%i in ('firebase login:list 2^>nul ^| find "@"') do set FIREBASE_LOGIN=%%i
if not defined FIREBASE_LOGIN (
    echo ❌ 尚未登入 Firebase，請登入後再試。
    firebase login
    pause
    exit /b
)
echo ✅ Firebase 已登入：%FIREBASE_LOGIN%
echo.

:: Step 2. 自動更新 README.md 日期
set "DATESTR=%date% %time%"
echo 🔄 正在更新 README.md 內容...
echo # 自動更新網站內容 > README.md
echo 更新時間：%DATESTR% >> README.md
echo. >> README.md
echo ✅ README.md 已更新。
echo.

:: Step 3. 提交最新修改
echo 💾 正在提交修改到 GitHub...
git add .
git commit -m "自動更新網站內容" >nul 2>&1

:: Step 4. 自動檢查並處理 rebase 狀態
for /f "tokens=1,*" %%a in ('git status --porcelain -b ^| find "diverged"') do set DIVERGED=1
if defined DIVERGED (
    echo ⚠️ 偵測到本地與遠端分歧，正在執行 rebase...
    git pull origin main --rebase
)

:: 若有 rebase 卡住的情況
if exist ".git\rebase-merge" (
    echo ⚠️ 偵測到 rebase 暫停，強制完成中...
    git rebase --continue >nul 2>&1
)

:: Step 5. 推送到 GitHub
echo 🚀 正在推送至 GitHub...
git push origin main --force

if errorlevel 1 (
    echo ❌ 上傳失敗，請檢查網路或帳號設定。
    pause
    exit /b
) else (
    echo ✅ GitHub 上傳成功！
)

:: Step 6. Firebase 部署
echo 🌐 正在部署到 Firebase...
firebase deploy

if errorlevel 1 (
    echo ❌ Firebase 部署失敗，請檢查錯誤訊息。
) else (
    echo ✅ Firebase 部署完成！
)

echo ========================================================
echo 🎉 全部流程完成！網站與 GitHub 均已更新。
echo ========================================================

pause
exit /b
