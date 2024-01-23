![logo](https://i3.wp.com/raw.githubusercontent.com/Quamagi/Speedchrome/main/logo.jpg)

Este script de Windows optimiza el rendimiento de Navegadores Basado en Chromiun mediante la realización de los siguientes cambios:

Establece el límite de memoria de Chromium a 4 GB. Esto puede ayudar a mejorar el rendimiento en sistemas con poca memoria.
Deshabilita la precarga de páginas. Esto puede ayudar a reducir el uso de la CPU y la memoria.
Deshabilita la aceleración de hardware. Esto puede ayudar a mejorar el rendimiento en sistemas con tarjetas gráficas antiguas o de baja potencia.
Instrucciones de uso

Abre una ventana del símbolo del sistema con privilegios de administrador.
Copia y pega el siguiente código en la ventana del símbolo del sistema:

rem Establecer el límite de memoria de Chromium a 4 GB
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Process" /v MaxMemPerProcess /t REG_DWORD /d 4096

rem Deshabilitar la precarga de páginas
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\Prefetch" /v EnablePrefetch /t REG_DWORD /d 0

rem Deshabilitar la aceleración de hardware
REG ADD "HKLM\SOFTWARE\Microsoft\Edge\HardwareAcceleration" /v EnableHardwareAcceleration /t REG_DWORD /d 0

rem Reiniciar el navegador
echo "Reiniciar el Navegador"

Presiona la tecla Enter.
El script mostrará un mensaje de confirmación. Si quieres continuar, presiona la tecla S. Si quieres cancelar, presiona la tecla N.
El script realizará los cambios en el registro.
El navegador se reiniciará automáticamente.
Notas

Este script solo es compatible con procesadores x64.
Antes de ejecutar el script, asegúrate de que no tienes ninguna pestaña abierta en el navegador.
Si tienes problemas con el rendimiento del navegador después de ejecutar el script, puedes restaurar los valores originales del registro. Para ello, abre el Editor del Registro y navega hasta las siguientes claves:
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\Process
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\Prefetch
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge\HardwareAcceleration
En cada clave, busca el valor MaxMemPerProcess, EnablePrefetch o EnableHardwareAcceleration. Si el valor está establecido en 1, cámbialo a 0.
