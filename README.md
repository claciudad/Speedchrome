![logo](https://i3.wp.com/raw.githubusercontent.com/Quamagi/htmlplus/main/logo.png)

Claro, puedo ayudarte a mejorar el script y proporcionar una estructura más clara para las instrucciones. Aquí está una versión mejorada:

---

# Optimizador de Rendimiento para Navegadores Basados en Chromium (Windows)

Este script de Windows optimiza el rendimiento de Navegadores Basados en Chromium mediante la realización de los siguientes cambios:

1. Establece el límite de memoria de Chromium a 4 GB.
2. Deshabilita la precarga de páginas.
3. Deshabilita la aceleración de hardware.

## Instrucciones de uso

### Paso 1: Abrir una ventana del símbolo del sistema con privilegios de administrador
1. Presiona `Windows + X` y selecciona `Símbolo del sistema (Administrador)` o `Windows PowerShell (Administrador)`.

### Paso 2: Copiar y pegar el siguiente código en la ventana del símbolo del sistema

```cmd
rem Establecer el límite de memoria de Chromium a 4 GB
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Process" /v MaxMemPerProcess /t REG_DWORD /d 4096 /f

rem Deshabilitar la precarga de páginas
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Prefetch" /v EnablePrefetch /t REG_DWORD /d 0 /f

rem Deshabilitar la aceleración de hardware
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration" /v EnableHardwareAcceleration /t REG_DWORD /d 0 /f

rem Mostrar mensaje para reiniciar el navegador
echo "Reiniciar el Navegador para aplicar los cambios. ¿Deseas reiniciar ahora? (S/N)"

set /p response=
if /i "%response%"=="S" (
    taskkill /F /IM msedge.exe
    echo "El navegador se ha reiniciado."
) else (
    echo "Por favor, reinicia el navegador manualmente para aplicar los cambios."
)
```

### Paso 3: Ejecutar el script
1. Presiona la tecla Enter después de pegar el código.
2. El script mostrará un mensaje para reiniciar el navegador.
3. Presiona la tecla `S` para reiniciar automáticamente o `N` para reiniciar manualmente más tarde.

## Notas

- Este script solo es compatible con procesadores x64.
- Asegúrate de cerrar todas las pestañas del navegador antes de ejecutar el script.
- Si experimentas problemas con el rendimiento del navegador después de ejecutar el script, puedes restaurar los valores originales del registro. Para ello:
  1. Abre el Editor del Registro (`regedit`).
  2. Navega hasta las siguientes claves:
     - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\Process`
     - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\Prefetch`
     - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\HardwareAcceleration`
  3. En cada clave, busca el valor `MaxMemPerProcess`, `EnablePrefetch` o `EnableHardwareAcceleration` y cámbialo a `1` si está establecido en `0`.

---

Esta versión proporciona instrucciones más claras y realiza el reinicio del navegador automáticamente si el usuario lo elige. También incluye la opción de confirmar si se desea reiniciar el navegador inmediatamente.
