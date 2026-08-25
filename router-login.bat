@echo off
setlocal EnableExtensions
chcp 65001 >nul
title router-login-ar

set "GW="
set "TARGET="
set "URL="

rem إذا أدخل المستخدم عنوانًا يدويًا، استخدمه مباشرة.
if not "%~1"=="" (
  set "TARGET=%~1"
  goto :open_target
)

rem الطريقة الأساسية: PowerShell لأنها لا تعتمد على لغة واجهة Windows.
for /f "usebackq delims=" %%G in (`powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$route = Get-NetRoute -AddressFamily IPv4 -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue ^| Where-Object { $_.NextHop -and $_.NextHop -ne '0.0.0.0' } ^| Sort-Object RouteMetric ^| Select-Object -First 1; if ($route) { $route.NextHop }" 2^>nul`) do (
  if not defined GW set "GW=%%G"
)

rem طريقة احتياطية لا تعتمد على ترجمة عبارة Default Gateway.
if not defined GW (
  for /f "tokens=1,2,3" %%A in ('route print -4 2^>nul') do (
    if "%%A"=="0.0.0.0" if "%%B"=="0.0.0.0" if not defined GW set "GW=%%C"
  )
)

if not defined GW goto :not_found
set "TARGET=%GW%"

:open_target
if not defined TARGET goto :not_found
set "URL=%TARGET%"
if /i not "%TARGET:~0,7%"=="http://" if /i not "%TARGET:~0,8%"=="https://" set "URL=http://%TARGET%"

echo تم العثور على صفحة الراوتر:
echo %URL%
echo.
start "" "%URL%"
if errorlevel 1 goto :open_failed
exit /b 0

:not_found
echo [تعذر العثور على عنوان الراوتر تلقائيًا]
echo تأكد من اتصال الكمبيوتر بشبكة الراوتر، ثم جرّب عنوانًا يدويًا:
echo.
echo   router-login.bat 192.168.1.1
echo   router-login.bat https://192.168.1.1
echo.
pause
exit /b 1

:open_failed
echo [تم اكتشاف العنوان لكن تعذر فتح المتصفح]
echo افتح المتصفح واكتب هذا العنوان يدويًا:
echo %URL%
echo.
pause
exit /b 1
