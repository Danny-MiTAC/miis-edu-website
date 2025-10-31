@echo off
chcp 65001 >nul
:: =====================================================
:: 🚀 一鍵上傳 GitHub + Firebase + 自動更新 README.md
:: =====================================================

setlocal enabledelayedexpansion

:: 🔹 你的網站網址（可修改）
set SITE_URL=https://miis-edu-website.web.app

echo.
echo ===============================================
echo 🚀 一鍵上傳 GitHub + Firebase 自動更新 README
echo ===============================================
echo.

:: =====================================================
:: STEP 1: 確認這是 Git 專案
:: =====================================================
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ❌ 錯誤：這個資料夾不是 Git 專案！
    echo 請先執行 git init
    pause
    exit /b
)

:: =====================================================
:: STEP 2: 讀取上傳說明
:: =====================================================
set /p msg=請輸入這次上傳說明 (預設: 自動更新網站內容)： 
if "%msg%"=="" set msg=自動更新網站內容
set datetime=%date% %time%

:: =====================================================
:: STEP 3: 自動更新 README.md
:: =====================================================
if not exist README.md (
    echo # miis-edu-website > README.md
    echo >> README.md
    echo ## 📘 專案簡介 >> README.md
    echo 此專案為 2025 年度資訊安全教育訓練課程網站。 >> README.md
    echo >> README.md
)

echo 📝 正在更新 README.md...
echo.>> README.md
echo --- >> README.md
echo **更新時間：%datetime%** >> README.md
echo **更新說明：%msg%** >> README.md

:: =====================================================
:: STEP 4: 提交變更至 GitHub
:: =====================================================
echo.
echo 🔄 新增變更中...
git add .
git commit -m "%msg%"
echo 🚀 推送到 GitHub...
git push -u origin main
if %errorlevel% neq 0 (
    echo ⚠️ 偵測到推送失敗，正在自動同步...
    git pull origin main --rebase
    git push -u origin main
    if %errorlevel% neq 0 (
        echo ❌ GitHub 上傳仍失敗，請檢查網路或權限。
        pause
        exit /b
    )
)

echo ✅ GitHub 上傳完成！

:: =====================================================
:: STEP 5: Firebase 部署
:: =====================================================
echo ☁️  正在部署至 Firebase Hosting...
firebase deploy --only hosting
if %errorlevel%==0 (
    echo ✅ Firebase 部署成功！
    echo 🌐 網站網址：%SITE_URL%
    echo 🔄 正在開啟網站...
    start %SITE_URL%
) else (
    echo ❌ Firebase 部署失敗，請檢查登入狀態。
)

echo.
echo ✅ 所有程序完成。
pause
