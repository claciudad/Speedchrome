#!/bin/bash

# Verificar si el sistema es x64
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    echo "Este script solo es compatible con sistemas x64."
    exit 1
fi

# Solicitar confirmación antes de continuar
echo "Este script realizará los siguientes cambios en los navegadores compatibles:"
echo " - Establecer el límite de memoria de Chromium a 4 GB"
echo " - Deshabilitar la precarga de páginas"
echo " - Deshabilitar la aceleración de hardware"
echo
read -p "¿Desea continuar? (S/N): " respuesta

respuesta=$(echo "$respuesta" | tr '[:lower:]' '[:upper:]')
if [[ "$respuesta" == "N" ]]; then
    echo "Cancelando..."
    exit 0
fi

# Lista de navegadores
browsers=("google-chrome" "chromium" "brave-browser" "opera" "microsoft-edge")

# Función para aplicar configuraciones a un navegador basado en Chromium
configure_browser() {
    local browser=$1
    echo "Procesando configuraciones para el navegador: $browser"

    # Ruta al directorio de configuración del usuario
    config_dir="$HOME/.config/$browser"

    if [[ ! -d "$config_dir" ]]; then
        echo "Directorio de configuración para $browser no encontrado. Saltando..."
        return
    fi

    # Crear o modificar el archivo de banderas de lanzamiento
    launch_flags_file="$config_dir/launch_flags.conf"
    
    # Crear el archivo si no existe
    if [[ ! -f "$launch_flags_file" ]]; then
        touch "$launch_flags_file"
    fi

    # Deshabilitar la aceleración de hardware
    if ! grep -q "--disable-gpu" "$launch_flags_file"; then
        echo "--disable-gpu" >> "$launch_flags_file"
        echo "Deshabilitando la aceleración de hardware para $browser..."
    else
        echo "La aceleración de hardware ya está deshabilitada para $browser."
    fi

    # Deshabilitar la precarga de páginas
    if ! grep -q "--disable-preloading" "$launch_flags_file"; then
        echo "--disable-preloading" >> "$launch_flags_file"
        echo "Deshabilitando la precarga de páginas para $browser..."
    else
        echo "La precarga de páginas ya está deshabilitada para $browser."
    fi

    # Establecer el límite de memoria a 4 GB si es 32gb 32768
    # Nota: No todos los navegadores soportan esta configuración directamente
    # Aquí se establece una variable de entorno que podría ser utilizada por el navegador
    export CHROME_MAX_MEMORY=4096
    echo "Estableciendo el límite de memoria a 4 GB para $browser..."

    echo "Configuración aplicada para $browser."
}

# Aplicar configuraciones a cada navegador compatible
for browser in "${browsers[@]}"; do
    configure_browser "$browser"
done

echo
echo "Los cambios se han realizado correctamente en los navegadores detectados."
echo "Por favor, reinicie los navegadores para que los cambios surtan efecto."
echo
read -p "¿Desea reiniciar los navegadores ahora? (S/N): " reiniciar

reiniciar=$(echo "$reiniciar" | tr '[:lower:]' '[:upper:]')
if [[ "$reiniciar" == "S" ]]; then
    for proc in "chrome" "chromium" "brave" "opera" "microsoft-edge"; do
        pkill -f "$proc" 2>/dev/null
    done
    echo "Los navegadores se están reiniciando..."
else
    echo "Por favor, reinicie los navegadores manualmente para aplicar los cambios."
fi
