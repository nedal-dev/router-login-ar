@echo off
REM -------------------------------------
REM  router-login.bat  |  Auto-open router page
REM -------------------------------------

:: إذا مرّر المستخدم IP يدويًا نستعمله
IF NOT "%~1"=="" (
    START "" "http://%~1"
    GOTO :EOF
)

:: العثور على البوّابة الافتراضية تلقائيًا
FOR /F "tokens=3" %%G IN ('chcp 65001^>NUL & ipconfig ^| findstr /R /C:"Default Gateway"') DO (
    SET GW=%%G
    GOTO :FOUND
)

:ECHOERR
ECHO لم أستطع العثور على البوّابة الافتراضيّة. أدخل IP يدويًّا:
ECHO   router-login.bat 192.168.1.1
PAUSE
GOTO :EOF

:FOUND
START "" "http://%GW%"
