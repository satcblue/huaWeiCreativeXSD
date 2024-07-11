@echo off

REM 输出使用帮助信息
:usage
echo Usage: %0 --url ^<schema url^> --src ^<处理的目录^> --dist ^<生成的目录^>
exit /b 1

REM 解析命名参数
:parse_params
if "%~1"=="" goto end_parse_params
if "%~1"=="--url" (
  set URL=%~2
  shift
) else if "%~1"=="--src" (
  set SRC_DIR=%~2
  shift
) else if "%~1"=="--dist" (
  set DIST_DIR=%~2
  shift
) else (
  echo Unknown parameter passed: %~1
  goto usage
)
shift
goto parse_params
:end_parse_params

if "%URL%"=="" goto usage
if "%SRC_DIR%"=="" goto usage
if "%DIST_DIR%"=="" goto usage

REM 创建dist目录，如果存在则删除原有文件
if exist "%DIST_DIR%" (
  echo Cleaning up existing directory: %DIST_DIR%
  rmdir /s /q "%DIST_DIR%"
)

mkdir "%DIST_DIR%"

REM 复制src目录下所有内容到dist目录
echo Copying files from %SRC_DIR% to %DIST_DIR%
xcopy "%SRC_DIR%\*" "%DIST_DIR%\" /s /e /y

REM 查找并替换xsd文件中的schemaLocation
for /r "%DIST_DIR%" %%f in (*.xsd) do (
  echo Processing %%f
  setlocal enabledelayedexpansion
  set XSD_FILE=%%f
  set TMP_FILE=!XSD_FILE!.tmp
  (for /f "usebackq delims=" %%l in ("!XSD_FILE!") do (
    set LINE=%%l
    echo !LINE! | findstr /r "schemaLocation=\"[^\"]*\"" >nul && (
      for /f "tokens=2 delims==\"" %%a in ("!LINE!") do (
        set ORIGINAL_LOCATION=%%a
        if "!ORIGINAL_LOCATION:~0,6!"=="../../" (
          set RELATIVE_PATH=!ORIGINAL_LOCATION:~6!
        ) else (
          set RELATIVE_PATH=!ORIGINAL_LOCATION!
        )
        set NEW_LOCATION=%URL%/!RELATIVE_PATH!
        set LINE=!LINE:!ORIGINAL_LOCATION!=!NEW_LOCATION!!
      )
    )
    echo !LINE! >> "!TMP_FILE!"
  ))
  move /y "!TMP_FILE!" "!XSD_FILE!"
  endlocal
)

echo Files processed successfully.
exit /b 0
