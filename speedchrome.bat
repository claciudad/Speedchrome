@echo off

rem Verificar la compatibilidad
if "%PROCESSOR_ARCHITECTURE%" == "x86" (
    echo Este script solo es compatible con procesadores x64.
    exit /b
)

rem Obtener el valor actual de EnableHardwareAcceleration
set "reg_path=HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration"
for /f "tokens=3" %%a in ('REG QUERY "%reg_path%" /v EnableHardwareAcceleration 2^>nul') do set "value=%%a"

rem Comprobar si la aceleración de hardware ya está deshabilitada
if "%value%" == "0x0" (
    echo La aceleración de hardware ya está deshabilitada.
    exit /b
)

rem Dialogo de confirmación
echo Este script realizará los siguientes cambios en su navegador:
echo - Establecer el límite de memoria de Chromium a 4 GB
echo - Deshabilitar la precarga de páginas
echo - Deshabilitar la aceleración de hardware
echo.
set /p "respuesta=¿Desea continuar? (S/N): "

if /i "%respuesta%" == "N" (
    echo Cancelando...
    exit /b
)

rem Establecer el límite de memoria de Chromium a 4 GB
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Process" /v MaxMemPerProcess /t REG_DWORD /d 4096 /f

rem Deshabilitar la precarga de páginas
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Prefetch" /v EnablePrefetch /t REG_DWORD /d 0 /f

rem Deshabilitar la aceleración de hardware
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration" /v EnableHardwareAcceleration /t REG_DWORD /d 0 /f

rem Mensaje final
echo.
echo Los cambios se han realizado correctamente.
echo Por favor, reinicie su navegador para que los cambios surtan efecto.
echo.
set /p "reiniciar=¿Desea reiniciar el navegador ahora? (S/N): "

if /i "%reiniciar%" == "S" (
    taskkill /F /IM msedge.exe
    echo El navegador se está reiniciando...
) else (
    echo Por favor, reinicie el navegador manualmente para aplicar los cambios.
)
