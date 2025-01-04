<#
.SYNOPSIS
  Script para configurar navegadores basados en Chromium en sistemas Windows x64.

.DESCRIPTION
  - Solicita confirmación para aplicar configuraciones:
    - Asignar una cantidad de memoria en MB a CHROME_MAX_MEMORY (por defecto 4096).
    - Deshabilitar la precarga de páginas (--disable-preloading).
    - Deshabilitar la aceleración por GPU (--disable-gpu).
  - Verifica y fuerza la ejecución como administrador.
  - Crea un archivo 'launch_flags.conf' en un directorio simulado al estilo Linux (~/.config/<navegador>).
  - Ofrece la opción de reiniciar navegadores (chrome, chromium, brave, opera, msedge).

.NOTES
  - Este script debe ejecutarse en PowerShell 5.0 o superior.
  - Se recomienda guardarlo en UTF-8 con BOM y/o forzar la consola a UTF-8 (chcp 65001).
  - Verifica si los procesos en tu equipo se llaman igual. Por ejemplo, Edge puede ser msedge.
#>

# Forzar la salida en UTF-8 en la consola actual
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Verificar y forzar privilegios de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]"Administrator")) {
    Write-Host "Este script necesita privilegios de Administrador. Solicitando..."
    Start-Process powershell -ArgumentList ("-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"") -Verb RunAs
    exit
}

# Comprobar si el sistema es x64
if (-not [System.Environment]::Is64BitOperatingSystem) {
    Write-Host "Este script solo es compatible con sistemas x64."
    exit 1
}

Write-Host "Este script realizará los siguientes cambios en los navegadores basados en Chromium:"
Write-Host " - Asignar una cantidad de memoria (recomendado 4096 MB)"
Write-Host " - Deshabilitar la precarga de páginas (--disable-preloading)"
Write-Host " - Deshabilitar la aceleración de hardware (--disable-gpu)"
Write-Host ""
$respuesta = Read-Host "¿Desea continuar? (S/N)"
$respuesta = $respuesta.ToUpper()

if ($respuesta -eq "N") {
    Write-Host "Cancelando..."
    exit 0
}

# Preguntar la cantidad de memoria en MB (ejemplo: 4096)
Write-Host "`nIngrese la cantidad de memoria en MB que desea asignar a los navegadores (recomendado 4096)."
$memInput = Read-Host "Presione ENTER sin escribir nada para usar 4096 MB por defecto"

# Validar la entrada del usuario
if ([string]::IsNullOrWhiteSpace($memInput)) {
    # Si el usuario no ingresa nada, usamos 4096
    $memInput = 4096
}
elseif (-not [int]::TryParse($memInput, [ref] 0)) {
    # Si no es un número válido, también usamos 4096
    Write-Host "No se proporcionó un valor numérico válido. Se usará 4096 MB (4GB)."
    $memInput = 4096
}

Write-Host "`nMemoria configurada (CHROME_MAX_MEMORY): $memInput MB."

# Lista de navegadores (nombres simbólicos tipo Linux)
$browsers = @("google-chrome","chromium","brave-browser","opera","microsoft-edge")

function Configure-Browser {
    param(
        [string]$Browser,
        [int]$MemoryLimit
    )

    Write-Host "`nProcesando configuraciones para el navegador: $Browser"

    # Directorio de configuración “simulado” al estilo Linux (~/.config/browser)
    $configDir = Join-Path $env:USERPROFILE ".config\$Browser"

    if (-not (Test-Path $configDir)) {
        Write-Host "Directorio de configuración para $Browser no encontrado. Creándolo..."
        New-Item -ItemType Directory -Path $configDir | Out-Null
    }

    # Archivo de banderas de lanzamiento
    $launchFlagsFile = Join-Path $configDir "launch_flags.conf"

    if (-not (Test-Path $launchFlagsFile)) {
        Write-Host "Archivo de configuración $($launchFlagsFile) no existe. Creándolo..."
        New-Item -ItemType File -Path $launchFlagsFile | Out-Null
    }

    # Leer contenido para verificar si las banderas ya existen
    $fileContent = Get-Content $launchFlagsFile

    # Deshabilitar la aceleración de hardware
    if ($fileContent -notmatch "--disable-gpu") {
        Add-Content -Path $launchFlagsFile -Value "--disable-gpu"
        Write-Host "Deshabilitando la aceleración de hardware para $Browser..."
    }
    else {
        Write-Host "La aceleración de hardware ya está deshabilitada para $Browser."
    }

    # Deshabilitar la precarga de páginas
    if ($fileContent -notmatch "--disable-preloading") {
        Add-Content -Path $launchFlagsFile -Value "--disable-preloading"
        Write-Host "Deshabilitando la precarga de páginas para $Browser..."
    }
    else {
        Write-Host "La precarga de páginas ya está deshabilitada para $Browser."
    }

    # Establecer el límite de memoria
    $env:CHROME_MAX_MEMORY = $MemoryLimit
    Write-Host "Estableciendo el límite de memoria a $MemoryLimit MB para $Browser..."

    Write-Host "Configuración aplicada para $Browser."
}

foreach ($browser in $browsers) {
    Configure-Browser -Browser $browser -MemoryLimit $memInput
}

Write-Host "`nLos cambios se han realizado correctamente en los navegadores detectados."
Write-Host "Por favor, reinicie los navegadores para que los cambios surtan efecto."
$reiniciar = Read-Host "`n¿Desea reiniciar los navegadores ahora? (S/N)"
$reiniciar = $reiniciar.ToUpper()

if ($reiniciar -eq "S") {
    # Nombres de procesos REALES en Windows
    $procNames = @("chrome", "chromium", "brave", "opera", "msedge")

    foreach ($proc in $procNames) {
        $procs = Get-Process -Name $proc -ErrorAction SilentlyContinue
        foreach ($p in $procs) {
            Write-Host "Cerrando navegador: $proc (PID: $($p.Id))"
            $p.Kill()
        }
    }

    Write-Host "`nLos navegadores se han cerrado. Vuelva a abrirlos manualmente."
}
else {
    Write-Host "`nPor favor, reinicie los navegadores manualmente para aplicar los cambios."
}
