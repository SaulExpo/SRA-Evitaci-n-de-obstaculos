$port = 8000

function Try-Run-Python ($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $versionStr = & $cmd --version 2>&1 | Out-String

        if ($versionStr -match "Python 3") {
            & $cmd -m http.server $port
            return $true
        }
    }
    return $false
}

# Intentar primero con 'python'
if (-not (Try-Run-Python "python")) {
    # Si falla, intentar con 'python3' (MS Store o WSL)
    if (-not (Try-Run-Python "python3")) {
        # Último recurso: intentar con 'py' (Python Launcher de Windows)
        if (-not (Try-Run-Python "py")) {
            Write-Warning "Error: No se encontró una instalación de Python."
        }
    }
}
