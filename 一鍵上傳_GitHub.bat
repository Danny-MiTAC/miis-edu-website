@echo off
chcp 65001 >nul
:: =====================================================
<<<<<<< HEAD
:: 🚀 一鍵上傳 GitHub + Firebase + 自動更新 README.md
=======
:: 🚀 一鍵上傳 GitHub + Firebase + 自動更新 README（含網址 / 限最近10筆）
>>>>>>> 5cd95b4 (自動更新網站內容)
:: =====================================================

setlocal enabledelayedexpansion

<<<<<<< HEAD
:: 🔹 你的網站網址（可修改）
=======
:: ✅ 你的網站網址（可自行修改）
>>>>>>> 5cd95b4 (自動更新網站內容)
set SITE_URL=https://miis-edu-website.web.app

echo.
echo ===============================================
<<<<<<< HEAD
echo 🚀 一鍵上傳 GitHub + Firebase 自動更新 README
=======
echo 🚀 一鍵上傳 GitHub + Firebase + 更新 README (含網址/限10筆)
>>>>>>> 5cd95b4 (自動更新網站內容)
echo ===============================================
echo.

:: =====================================================
<<<<<<< HEAD
:: STEP 1: 確認這是 Git 專案
=======
:: STEP 1: 檢查是否為 Git 專案
>>>>>>> 5cd95b4 (自動更新網站內容)
:: =====================================================
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ❌ 錯誤：這個資料夾不是 Git 專案！
    echo 請先執行 git init
    pause
    exit /b
)

:: =====================================================
<<<<<<< HEAD
:: STEP 2: 讀取上傳說明
=======
:: STEP 2: 取得使用者輸入
>>>>>>> 5cd95b4 (自動更新網站內容)
:: =====================================================
set /p msg=請輸入這次上傳說明 (預設: 自動更新網站內容)： 
if "%msg%"=="" set msg=自動更新網站內容
set datetime=%date% %time%

:: =====================================================
<<<<<<< HEAD
:: STEP 3: 自動更新 README.md
=======
:: STEP 3: 建立或更新 README.md
>>>>>>> 5cd95b4 (自動更新網站內容)
:: =====================================================
if not exist README.md (
    echo # miis-edu-website > README.md
    echo >> README.md
    echo ## 📘 專案簡介 >> README.md
    echo 此專案為 2025 年度資訊安全教育訓練課程網站。 >> README.md
    echo >> README.md
<<<<<<< HEAD
)

echo 📝 正在更新 README.md...
echo.>> README.md
echo --- >> README.md
echo **更新時間：%datetime%** >> README.md
echo **更新說明：%msg%** >> README.md
=======
    echo 🌐 [前往網站](%SITE_URL%) >> README.md
    echo >> README.md
    echo ## 🕒 更新紀錄 >> README.md
    echo >> README.md
)

:: 確保網站連結存在於 README
find "🌐 [前往網站]" README.md >nul
if %errorlevel% neq 0 (
    echo 🌐 [前往網站](%SITE_URL%) >> README.md
    echo >> README.md
)

:: 先建立暫存檔
type NUL > temp_log.txt
set lineCount=0
set copyFlag=0

:: 保留標題與前10筆更新
for /f "usebackq delims=" %%A in ("README.md") do (
    set "line=%%A"
    echo !line! | find "## 🕒 更新紀錄" >nul
    if !errorlevel! == 0 (
        set copyFlag=1
    )

    if !copyFlag! == 0 (
        echo !line!>>temp_log.txt
    ) else (
        if "!line!"=="---" (
            set /a lineCount+=1
        )
        if !lineCount! lss 11 (
            echo !line!>>temp_log.txt
        )
    )
)

:: 新增最新更新紀錄在最上方
(
    echo ---
    echo **更新時間：%datetime%**
    echo **更新說明：%msg%**
    echo.
) > new_entry.txt

:: 合併新舊紀錄
type new_entry.txt > README.md
type temp_log.txt >> README.md

del temp_log.txt
del new_entry.txt

echo 📝 已更新 README.md（只保留最近 10 筆紀錄）。
>>>>>>> 5cd95b4 (自動更新網站內容)

:: =====================================================
:: STEP 4: 提交變更至 GitHub
:: =====================================================
<<<<<<< HEAD
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
=======
git add .
git commit -m "%msg%"
git push -u origin main
if %errorlevel% neq 0 (
    echo ⚠️ 推送失敗，正在自動同步...
    git pull origin main --rebase
    git push -u origin main
    if %errorlevel% neq 0 (
        echo ❌ GitHub 上傳仍失敗，請檢查帳號或網路。
>>>>>>> 5cd95b4 (自動更新網站內容)
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
<<<<<<< HEAD
    echo 🔄 正在開啟網站...
=======
    echo 🔄 自動開啟網站...
>>>>>>> 5cd95b4 (自動更新網站內容)
    start %SITE_URL%
) else (
    echo ❌ Firebase 部署失敗，請檢查登入狀態。
)

echo.
echo ✅ 所有程序完成。
pause
