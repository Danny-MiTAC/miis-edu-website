@echo off
:: =====================================================
:: ?? 一鍵上傳 GitHub + Firebase + 自動更新版本號 + 自動開啟網站
:: =====================================================

setlocal enabledelayedexpansion

:: ?? 設定你的 Firebase 網址（請依實際專案修改）
set SITE_URL=https://miis-edu-website.web.app

:: ?? 檢查是否為 Git 專案
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [錯誤] 這個資料夾不是 Git 專案！
    echo 請先執行 git init
    pause
    exit /b
)

:: =====================================================
:: STEP 1: 自動更新 index.html 版本號（更新時間）
:: =====================================================
echo ?? 正在更新 index.html 版本號...

set file=index.html
if not exist %file% (
    echo [警告] 找不到 index.html，跳過版本更新。
) else (
    set "datetime=%date% %time%"
    powershell -Command "(Get-Content %file%) -replace '<footer>更新時間：.*?</footer>', '<footer>更新時間：%datetime%</footer>' | Set-Content %file%"
)

:: =====================================================
:: STEP 2: Git 操作
:: =====================================================
echo.
echo ?? 新增變更中...
git add .

set /p msg=請輸入這次上傳說明 (預設: 自動更新網站內容)： 
if "%msg%"=="" set msg=自動更新網站內容

git commit -m "%msg%"
echo ?? 正在推送至 GitHub...
git push -u origin main

if %errorlevel%==0 (
    echo ? GitHub 上傳完成。
) else (
    echo ? GitHub 上傳失敗，請檢查網路或帳號。
    pause
    exit /b
)

:: =====================================================
:: STEP 3: Firebase 部署
:: =====================================================
echo.
echo ??  正在部署至 Firebase Hosting...
firebase deploy --only hosting

if %errorlevel%==0 (
    echo.
    echo ? Firebase 部署成功！網站已上線。
    echo ?? 網站網址：%SITE_URL%
    echo ?? 正在自動開啟網站...
    start %SITE_URL%
) else (
    echo ? Firebase 部署失敗，請檢查網路或登入狀態。
)

echo.
pause
