@echo off
:: ==========================================
:: 一鍵上傳 GitHub 備份工具
:: 適用環境：Windows + 已安裝 Git
:: 作者：ChatGPT 自動產生
:: ==========================================

:: 檢查是否在 Git 專案內
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [錯誤] 這個資料夾不是 Git 專案！
    echo 請先執行：git init
    pause
    exit /b
)

echo ==========================================
echo 🔄 正在準備上傳至 GitHub...
echo ==========================================
echo.

:: 新增所有修改的檔案
git add .

:: 讓使用者輸入 Commit 訊息
set /p msg=請輸入這次上傳的說明 (預設: 更新網站內容)： 
if "%msg%"=="" set msg=更新網站內容

:: 建立 commit
git commit -m "%msg%"

:: 推送到 GitHub main 分支
echo.
echo 🚀 正在推送到 GitHub...
git push -u origin main

if %errorlevel%==0 (
    echo.
    echo ✅ 上傳完成！已成功同步到 GitHub。
) else (
    echo.
    echo ❌ 上傳失敗，請檢查網路或登入狀態。
)

pause
