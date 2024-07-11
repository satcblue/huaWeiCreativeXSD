@echo off

REM 输出使用帮助信息
:usage
echo Usage: %0 --bucket-domain ^<aliyun-oss-bucket-domain^> [--access-key-id ^<access-key-id^>] [--access-key-secret ^<access-key-secret^>] [--security-token ^<security-token^>] [--keep-output]
exit /b 1

set KEEP_OUTPUT=false

REM 解析命名参数
:parse_params
if "%~1"=="" goto end_parse_params
if "%~1"=="--bucket-domain" (
  set BUCKET_DOMAIN=%~2
  shift
) else if "%~1"=="--access-key-id" (
  set ACCESS_KEY_ID=%~2
  shift
) else if "%~1"=="--access-key-secret" (
  set ACCESS_KEY_SECRET=%~2
  shift
) else if "%~1"=="--security-token" (
  set SECURITY_TOKEN=%~2
  shift
) else if "%~1"=="--keep-output" (
  set KEEP_OUTPUT=true
) else (
  echo Unknown parameter passed: %~1
  goto usage
)
shift
goto parse_params
:end_parse_params

if "%BUCKET_DOMAIN%"=="" goto usage

REM 执行文件处理脚本
set SCRIPT_DIR=%~dp0

set INPUT_DIR=%SCRIPT_DIR%\..\..\src
set OUTPUT_DIR=%SCRIPT_DIR%\..\..\dist\aliyun-oss\SCHEMA
set REMOVE_DIR=%SCRIPT_DIR%\..\..\dist\aliyun-oss\
set OSS_DIR=SCHEMA

call "%SCRIPT_DIR%\process_files.bat" --url https://%BUCKET_DOMAIN%/%OSS_DIR% --src %INPUT_DIR% --dist %OUTPUT_DIR%
set PROCESS_STATUS=%ERRORLEVEL%
if %PROCESS_STATUS%==0 (
  echo Process files successfully. dist dir is %OUTPUT_DIR%
) else (
  echo Process files failed
  exit /b 1
)

echo Start upload files to OSS

REM 执行上传脚本
if not "%SECURITY_TOKEN%"=="" (
  call "%SCRIPT_DIR%\upload_files.bat" --source-dir "%OUTPUT_DIR%" --target-dir "%OSS_DIR%" --bucket-domain "%BUCKET_DOMAIN%" --security-token "%SECURITY_TOKEN%"
) else (
  if "%ACCESS_KEY_ID%"=="" goto usage
  if "%ACCESS_KEY_SECRET%"=="" goto usage
  call "%SCRIPT_DIR%\upload_files.bat" --source-dir "%OUTPUT_DIR%" --target-dir "%OSS_DIR%" --bucket-domain "%BUCKET_DOMAIN%" --access-key-id "%ACCESS_KEY_ID%" --access-key-secret "%ACCESS_KEY_SECRET%"
)
set UPLOAD_STATUS=%ERRORLEVEL%

if %UPLOAD_STATUS%==0 (
  echo Upload completed successfully.
  if "%KEEP_OUTPUT%"=="false" (
    echo Deleting output directory %REMOVE_DIR%
    rmdir /s /q "%REMOVE_DIR%"
  )
) else (
  echo Upload failed
  exit /b 1
)
exit /b 0
