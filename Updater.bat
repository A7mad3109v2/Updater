@echo off
setlocal enabledelayedexpansion

REM --- CONFIG ---
set "LOCAL_FILE=Chrome.exe"
set "REMOTE_FILE_URL=https://raw.githubusercontent.com/A7mad3109v2/Updater/refs/heads/main/Chrome.exe"

REM --- COMPUTE LOCAL HASH ---
for /f "tokens=1" %%A in ('certutil -hashfile "%LOCAL_FILE%" SHA256 ^| find /i /v "hash" ^| find /i /v "CertUtil"') do (
    set "LOCAL_HASH=%%A"
)

REM --- DOWNLOAD REMOTE FILE TEMPORARILY ---
curl -s -L %REMOTE_FILE_URL% -o temp_remote_file.bat

REM --- COMPUTE REMOTE HASH ---
for /f "tokens=1" %%A in ('certutil -hashfile "temp_remote_file.bat" SHA256 ^| find /i /v "hash" ^| find /i /v "CertUtil"') do (
    set "REMOTE_HASH=%%A"
)

REM --- COMPARE HASHES ---
if "!LOCAL_HASH!" neq "!REMOTE_HASH!" (
    echo Update available. Installing latest version...
    move /y temp_remote_file.bat "%LOCAL_FILE%" >nul
    echo Update complete.
) else (
    echo File is up to date.
    del temp_remote_file.bat
)

REM --- RUNNING FILE ---
start "" "%LOCAL_FILE%"
exit