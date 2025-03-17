# Verificar si el sistema es x64
$ARCH = [System.Environment]::Is64BitOperatingSystem
if (-not $ARCH) {
    Write-Host "Este script solo es compatible con sistemas x64."
    exit 1
}

# Solicitar confirmación
Write-Host "Este script realizará los siguientes cambios:"
Write-Host " - Establecer límite de memoria de Chromium"
Write-Host " - Deshabilitar precarga de páginas"
Write-Host " - Deshabilitar aceleración de hardware"
Write-Host ""
$confirmacion = Read-Host "¿Desea continuar? (S/N)"

if ($confirmacion.ToUpper() -eq "N") {
    Write-Host "Cancelando..."
    exit 0
}

# Función para detectar memoria
function Detectar-Memoria {
    $total_memoria = (Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1024
    $max_memoria = [math]::Floor($total_memoria / 2)
    
    $memoria_asignada = Read-Host "Memoria a asignar (MB, máximo $max_memoria)"
    
    if (-not $memoria_asignada -or -not ($memoria_asignada -match '^[0-9]+$') -or $memoria_asignada -gt $max_memoria) {
        Write-Host "Usando valor máximo."
        $memoria_asignada = $max_memoria
    }

    $env:CHROME_MAX_MEMORY = $memoria_asignada
}

# Lista de navegadores compatibles
$browsers = @(
    "Google\ Chrome", "Chromium", "BraveSoftware\ Brave-Browser",
    "Opera Software\ Opera Stable", "Microsoft\ Edge", "Vivaldi",
    "Yandex\ YandexBrowser", "Epic Privacy Browser", "Colibri",
    "SRWare Iron", "Comodo\ Dragon", "Torch", "Blisk",
    "CocCoc", "Slimjet"
)

# Función de configuración
function Configurar-Navegador {
    param ($browser)
    
    $config_dir = "$env:APPDATA\$browser"
    
    if (-not (Test-Path $config_dir)) {
        return
    }
    
    $launch_flags_file = "$config_dir\launch_flags.conf"
    if (-not (Test-Path $launch_flags_file)) {
        New-Item -Path $launch_flags_file -ItemType File -Force | Out-Null
    }
    
    $flags = @("--disable-gpu", "--disable-preloading")
    $existing_flags = Get-Content $launch_flags_file -ErrorAction SilentlyContinue
    
    foreach ($flag in $flags) {
        if ($existing_flags -notcontains $flag) {
            Add-Content -Path $launch_flags_file -Value $flag
        }
    }
    
    Write-Host "Configurado $browser con ${env:CHROME_MAX_MEMORY}MB"
}

# Proceso principal
Detectar-Memoria
foreach ($browser in $browsers) {
    Configurar-Navegador $browser
}

# Reinicio de navegadores
$reiniciar = Read-Host "¿Reiniciar navegadores ahora? (S/N)"
if ($reiniciar.ToUpper() -eq "S") {
    Write-Host "Cerrando navegadores..."
    
    # Lista de procesos de navegadores
    $processes = @("chrome", "chromium", "brave", "opera", "msedge", "vivaldi", "yandex", "epic", "colibri", "iron", "dragon", "torch", "blisk", "coccoc", "slimjet")
    
    foreach ($proc in $processes) {
        if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
            Stop-Process -Name $proc -Force
            Write-Host "✓ Cerrado: $proc"
        } else {
            Write-Host "× No en ejecución: $proc"
        }
    }
    
    Write-Host "¡Reinicia manualmente los navegadores para aplicar cambios!"
}
