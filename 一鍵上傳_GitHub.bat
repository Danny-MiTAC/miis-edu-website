@echo off
:: =====================================================
:: ?? �@��W�� GitHub + Firebase + �۰ʧ�s������ + �۰ʶ}�Һ���
:: =====================================================

setlocal enabledelayedexpansion

:: ?? �]�w�A�� Firebase ���}�]�Ш̹�ڱM�׭ק�^
set SITE_URL=https://miis-edu-website.web.app

:: ?? �ˬd�O�_�� Git �M��
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [���~] �o�Ӹ�Ƨ����O Git �M�סI
    echo �Х����� git init
    pause
    exit /b
)

:: =====================================================
:: STEP 1: �۰ʧ�s index.html �������]��s�ɶ��^
:: =====================================================
echo ?? ���b��s index.html ������...

set file=index.html
if not exist %file% (
    echo [ĵ�i] �䤣�� index.html�A���L������s�C
) else (
    set "datetime=%date% %time%"
    powershell -Command "(Get-Content %file%) -replace '<footer>��s�ɶ��G.*?</footer>', '<footer>��s�ɶ��G%datetime%</footer>' | Set-Content %file%"
)

:: =====================================================
:: STEP 2: Git �ާ@
:: =====================================================
echo.
echo ?? �s�W�ܧ�...
git add .

set /p msg=�п�J�o���W�ǻ��� (�w�]: �۰ʧ�s�������e)�G 
if "%msg%"=="" set msg=�۰ʧ�s�������e

git commit -m "%msg%"
echo ?? ���b���e�� GitHub...
git push -u origin main

if %errorlevel%==0 (
    echo ? GitHub �W�ǧ����C
) else (
    echo ? GitHub �W�ǥ��ѡA���ˬd�����αb���C
    pause
    exit /b
)

:: =====================================================
:: STEP 3: Firebase ���p
:: =====================================================
echo.
echo ??  ���b���p�� Firebase Hosting...
firebase deploy --only hosting

if %errorlevel%==0 (
    echo.
    echo ? Firebase ���p���\�I�����w�W�u�C
    echo ?? �������}�G%SITE_URL%
    echo ?? ���b�۰ʶ}�Һ���...
    start %SITE_URL%
) else (
    echo ? Firebase ���p���ѡA���ˬd�����εn�J���A�C
)

echo.
pause
