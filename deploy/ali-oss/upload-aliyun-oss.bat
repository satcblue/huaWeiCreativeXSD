@echo off

REM 输出使用帮助信息
:usage
echo Usage: %0 --source-dir ^<待上传的目录^> --target-dir ^<目标目录^> --bucket-domain ^<aliyun-oss-bucket-domain^> [--access-key-id ^<access-key-id^>] [--access-key-secret ^<access-key-secret^>] [--security-token ^<security-token^>]
exit /b 1

REM 解析命名参数
:parse_params
if "%~1"=="" goto end_parse_params
if "%~1"=="--source-dir" (
  set SOURCE_DIR=%~2
  shift
) else if "%~1"=="--target-dir" (
  set TARGET_DIR=%~2
  shift
) else if "%~1"=="--bucket-domain" (
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
) else (
  echo Unknown parameter passed: %~1
  goto usage
)
shift
goto parse_params
:end_parse_params

if "%BUCKET_DOMAIN%"=="" goto usage
if "%SOURCE_DIR%"=="" goto usage
if "%TARGET_DIR%"=="" goto usage

REM 如果未提供endpoint，则从BUCKET_DOMAIN中提取，保留一级域名
for /f "tokens=2,3,4 delims=." %%a in ("%BUCKET_DOMAIN%") do set ENDPOINT=%%a.%%b.%%c

REM 从BUCKET_DOMAIN中提取BUCKET_NAME
for /f "tokens=1 delims=." %%a in ("%BUCKET_DOMAIN%") do set BUCKET_NAME=%%a
set OSS_DIR=oss://%BUCKET_NAME%/%TARGET_DIR%

REM 获取当前脚本所在路径
set SCRIPT_DIR=%~dp0

REM 确定ossutil路径
REM 判断系统是32位还是64位
set OSSUTIL=
if defined ProgramFiles(x86) (
  REM 64位系统
  set OSSUTIL=%SCRIPT_DIR%util\win\ossutil64\ossutil64.exe
) else (
  REM 32位系统
  set OSSUTIL=%SCRIPT_DIR%util\win\ossutil32\ossutil32.exe
)

REM 设置鉴权信息
set OSSUTIL_CMD="%OSSUTIL% cp -r %SOURCE_DIR% %OSS_DIR% --force --endpoint %ENDPOINT%"
if not "%SECURITY_TOKEN%"=="" (
  set OSSUTIL_CMD=%OSSUTIL_CMD% --sts-token %SECURITY_TOKEN%
) else (
  if "%ACCESS_KEY_ID%"=="" goto usage
  if "%ACCESS_KEY_SECRET%"=="" goto usage
  set OSSUTIL_CMD=%OSSUTIL_CMD% --access-key-id %ACCESS_KEY_ID% --access-key-secret %ACCESS_KEY_SECRET%
)

REM 上传到阿里云OSS
%OSSUTIL_CMD%
set UPLOAD_STATUS=%ERRORLEVEL%

if %UPLOAD_STATUS%==0 (
  echo Upload completed successfully.
) else (
  echo Upload failed
  exit /b 1
)
exit /b 0
