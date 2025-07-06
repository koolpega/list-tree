@echo off
setlocal

set "OUTPUT=list-tree.txt"
echo Generating filesystem tree... > "%OUTPUT%"

:: --- Installed Applications ---
echo ------------------------------ >> "%OUTPUT%"
echo INSTALLED APPLICATIONS >> "%OUTPUT%"
echo ------------------------------ >> "%OUTPUT%"
powershell -NoProfile -Command ^
"Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' ^
| Where-Object { $_.DisplayName -and $_.DisplayVersion } ^
| Sort-Object DisplayName ^
| ForEach-Object { Add-Content -Path '%OUTPUT%' -Value (($_.DisplayName + ' - ' + $_.DisplayVersion)) }"

:: --- Tree View of Files ---
echo. >> "%OUTPUT%"
echo ------------------------------ >> "%OUTPUT%"
echo USER FILE STRUCTURE >> "%OUTPUT%"
echo ------------------------------ >> "%OUTPUT%"

set "USERDIR=%USERPROFILE%"
for %%F in (Downloads Documents Desktop) do (
    echo. >> "%OUTPUT%"
    echo [%%F Folder Tree] >> "%OUTPUT%"
    if exist "%USERDIR%\%%F" (
        tree "%USERDIR%\%%F" /f >> "%OUTPUT%"
    ) else (
        echo Folder %%F not found >> "%OUTPUT%"
    )
)

echo.
echo ✅ Output generated successfully: %OUTPUT%
pause