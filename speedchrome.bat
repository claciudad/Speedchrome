@echo off

rem Verifica la compatibilidad
if "%PROCESSOR_ARCHITECTURE%" == "x86" (
echo Este script solo es compatible con procesadores x64.
exit /b
)

rem Verifica si los cambios ya están hechos
rem Obtener el valor actual de EnableHardwareAcceleration
set "reg_value=HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration\EnableHardwareAcceleration"
for /f "delims=" %%a in ('REG QUERY "%reg_value%" /v Value') do set "value=%%a"

if "%value%" == "1" (
echo La aceleración de hardware ya está habilitada.
exit /b
)

rem Dialogo de confirmación
echo Este script realizará los siguientes cambios en su navegador:
echo - Establecer el límite de memoria de Chromium a 4 GB
echo - Deshabilitar la precarga de páginas
echo - Deshabilitar la aceleración de hardware
echo
echo ¿Desea continuar? (S/N)
set /p respuesta="S"

if "%respuesta%" == "N" (
echo Cancelando...
exit /b
)

rem Establecer el límite de memoria de Chromium a 4 GB
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Process" /v MaxMemPerProcess /t REG_DWORD /d 4096

rem Deshabilitar la precarga de páginas
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Prefetch" /v EnablePrefetch /t REG_DWORD /d 0

rem Deshabilitar la aceleración de hardware
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration" /v EnableHardwareAcceleration /t REG_DWORD /d 0

rem Reiniciar el navegador
echo "Reiniciar el Navegador"