@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo   HireIQ - Upload project to GitHub
echo ========================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo ERROR: Git is not installed or not in PATH.
  echo Install Git for Windows from https://git-scm.com/download/win and run this file again.
  pause
  exit /b 1
)

if not exist ".git" (
  git init -b main
  if errorlevel 1 goto fail
) else (
  git branch -M main
  if errorlevel 1 goto fail
)

for /f "delims=" %%E in ('git config user.email') do set "GIT_EMAIL=%%E"
if "%GIT_EMAIL%"=="" (
  echo Enter the email associated with your GitHub account.
  set /p GIT_EMAIL=Git email: 
  call git config user.email "%GIT_EMAIL%"
)
for /f "delims=" %%N in ('git config user.name') do set "GIT_NAME=%%N"
if "%GIT_NAME%"=="" (
  set /p GIT_NAME=Git name: 
  call git config user.name "%GIT_NAME%"
)

git add .
if errorlevel 1 goto fail

git diff --cached --quiet
if not errorlevel 1 (
  echo No new changes to commit. Continuing to push existing commits if any.
) else (
  git commit -m "Initial commit: HireIQ project"
  if errorlevel 1 goto fail
)

set "REMOTE_URL=https://github.com/shivarjunchaturvedi/HireIQ.git"
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  git remote add origin "%REMOTE_URL%"
) else (
  git remote set-url origin "%REMOTE_URL%"
)
if errorlevel 1 goto fail

echo.
echo Pushing project to GitHub. A browser sign-in may appear.
git push -u origin main
if errorlevel 1 goto fail

echo.
echo SUCCESS! Open https://github.com/shivarjunchaturvedi/HireIQ
pause
exit /b 0

:fail
echo.
echo Upload did not complete. Read the error shown above and share a screenshot for help.
pause
exit /b 1
