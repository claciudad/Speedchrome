![logo](https://i3.wp.com/raw.githubusercontent.com/Quamagi/Speedchrome/main/logo.jpg)

# Optimizador de Rendimiento para Navegadores Basados en Chromium (Windows)

Este script de Windows optimiza el rendimiento de varios navegadores basados en el motor de Chromium, incluyendo **Microsoft Edge, Google Chrome, Brave, y Opera**. Los ajustes aplicados son:

1. Establece un límite de memoria de 4 GB para reducir el consumo.
2. Deshabilita la precarga de páginas para un arranque más rápido.
3. Deshabilita la aceleración de hardware para mejorar la estabilidad en sistemas que experimentan problemas con esta función.

## Instrucciones de uso

### Paso 1: Abrir una ventana del símbolo del sistema con privilegios de administrador
1. Presiona `Windows + X` y selecciona `Símbolo del sistema (Administrador)` o `Windows PowerShell (Administrador)`.

### Paso 2: Descargar y ejecutar el script
1. Descarga el script desde el repositorio o copia el siguiente bloque de código.
2. Pega el código en el símbolo del sistema o ejecuta el archivo descargado desde la terminal con permisos de administrador.

```cmd
@echo off

rem Verificar si el sistema es x64
if "%PROCESSOR_ARCHITECTURE%" == "x86" (
    echo Este script solo es compatible con procesadores x64.
    exit /b
)

rem Definir la ruta base para configuraciones de navegadores basados en Chromium
set "browsers=Microsoft\Edge Google\Chrome BraveSoftware\Brave Software\Opera Stable"

rem Función para aplicar configuraciones a un navegador basado en Chromium
:ConfigureBrowser
    set "browser=%~1"

    rem Verificar y deshabilitar la aceleración de hardware si ya no está deshabilitada
    set "reg_path=HKLM\SOFTWARE\%browser%\HardwareAcceleration"
    for /f "tokens=3" %%a in ('REG QUERY "%reg_path%" /v EnableHardwareAcceleration 2^>nul') do set "value=%%a"
    if "%value%" == "0x0" (
        echo La aceleración de hardware ya está deshabilitada para %browser%.
    ) else (
        echo Deshabilitando la aceleración de hardware para %browser%...
        REG ADD "%reg_path%" /v EnableHardwareAcceleration /t REG_DWORD /d 0 /f
    )

    rem Establecer el límite de memoria del proceso a 4 GB
    echo Configurando límite de memoria en 4 GB para %browser%...
    REG ADD "HKLM\SOFTWARE\%browser%\Process" /v MaxMemPerProcess /t REG_DWORD /d 4096 /f

    rem Deshabilitar la precarga de páginas
    echo Deshabilitando la precarga de páginas para %browser%...
    REG ADD "HKLM\SOFTWARE\%browser%\Prefetch" /v EnablePrefetch /t REG_DWORD /d 0 /f

    goto :eof

rem Solicitar confirmación antes de continuar
echo Este script realizará los siguientes cambios en los navegadores compatibles:
echo - Establecer el límite de memoria de Chromium a 4 GB
echo - Deshabilitar la precarga de páginas
echo - Deshabilitar la aceleración de hardware
echo.
set /p "respuesta=¿Desea continuar? (S/N): "

if /i "%respuesta%" == "N" (
    echo Cancelando...
    exit /b
)

rem Aplicar configuraciones a cada navegador compatible
for %%b in (%browsers%) do (
    call :ConfigureBrowser %%b
)

rem Mensaje final
echo.
echo Los cambios se han realizado correctamente en los navegadores detectados.
echo Por favor, reinicie los navegadores para que los cambios surtan efecto.
echo.
set /p "reiniciar=¿Desea reiniciar los navegadores ahora? (S/N): "

if /i "%reiniciar%" == "S" (
    for %%b in (msedge.exe chrome.exe brave.exe opera.exe) do (
        taskkill /F /IM %%b 2>nul
    )
    echo Los navegadores se están reiniciando...
) else (
    echo Por favor, reinicie los navegadores manualmente para aplicar los cambios.
)
```

### Paso 3: Reiniciar el navegador
1. Al finalizar, el script ofrecerá la opción de reiniciar automáticamente los navegadores configurados.
2. Presiona la tecla `S` para reiniciar automáticamente o `N` para reiniciar manualmente más tarde.

## Notas Importantes

- Este script solo es compatible con procesadores x64.
- Asegúrate de cerrar todas las pestañas del navegador antes de ejecutar el script.
- Para restaurar los valores originales del registro, abre el Editor del Registro (`regedit`) y navega hasta las siguientes claves:
  - `HKEY_LOCAL_MACHINE\SOFTWARE\[Nombre del navegador]\Process` (ajuste de memoria)
  - `HKEY_LOCAL_MACHINE\SOFTWARE\[Nombre del navegador]\Prefetch` (precarga de páginas)
  - `HKEY_LOCAL_MACHINE\SOFTWARE\[Nombre del navegador]\HardwareAcceleration` (aceleración de hardware)
  
En cada clave, restaura el valor `MaxMemPerProcess`, `EnablePrefetch` o `EnableHardwareAcceleration` a `1` si se había establecido en `0`.
