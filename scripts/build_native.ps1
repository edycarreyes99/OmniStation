# ==============================================================================
# OmniStation — Native Build Script (C++23 Cores + Rust Host FFI)
# Windows PowerShell Compiler & Test Runner
# ==============================================================================

[CmdletBinding()]
param(
    [switch]$SkipTests = $false
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path "$PSScriptRoot\.."
$BuildDir = "$RepoRoot\build"
$OmniStationDir = "$RepoRoot\omnistation"

Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    OmniStation — Native Compilation Pipeline (C++ & Rust)        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "Project Root: $RepoRoot`n"

$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# ------------------------------------------------------------------------------
# 1. C++23 Cores Compilation with CMake
# ------------------------------------------------------------------------------
Write-Host "▶ PHASE 1: Configuring and Compiling C++23 Cores (CMake Release)" -ForegroundColor Magenta
Write-Host "──────────────────────────────────────────────────────────────────" -ForegroundColor Magenta

Set-Location $RepoRoot
cmake -B $BuildDir -S . -DCMAKE_BUILD_TYPE=Release
if ($LASTEXITCODE -ne 0) { throw "CMake configuration failed" }

cmake --build $BuildDir --config Release --parallel
if ($LASTEXITCODE -ne 0) { throw "CMake compilation failed" }

if (-not $SkipTests) {
    $TestExe = "$BuildDir\cores\tests\Release\omnistation_tests.exe"
    if (Test-Path $TestExe) {
        Write-Host "[INFO] Running C++23 GoogleTest..." -ForegroundColor Cyan
        & $TestExe
        if ($LASTEXITCODE -ne 0) { throw "C++ unit tests failed" }
    }
}

# ------------------------------------------------------------------------------
# 2. Rust Crates & emu_ffi Compilation with Cargo
# ------------------------------------------------------------------------------
Write-Host "`n▶ PHASE 2: Compiling Rust Crates and emu_ffi (Cargo Edition 2024)" -ForegroundColor Magenta
Write-Host "──────────────────────────────────────────────────────────────────" -ForegroundColor Magenta

cargo build --workspace
if ($LASTEXITCODE -ne 0) { throw "cargo build --workspace failed" }

cargo build --release -p emu_ffi
if ($LASTEXITCODE -ne 0) { throw "cargo build --release -p emu_ffi failed" }

if (-not $SkipTests) {
    Write-Host "[INFO] Verifying Rust linting and unit tests..." -ForegroundColor Cyan
    cargo clippy --workspace --all-targets -- -D warnings
    if ($LASTEXITCODE -ne 0) { throw "cargo clippy failed" }

    cargo test --workspace
    if ($LASTEXITCODE -ne 0) { throw "Rust unit tests failed" }
}

# ------------------------------------------------------------------------------
# 3. Dynamic FFI Library Synchronization (DLL)
# ------------------------------------------------------------------------------
Write-Host "`n▶ PHASE 3: Synchronizing Native Dynamic Libraries (DLL)" -ForegroundColor Magenta
Write-Host "──────────────────────────────────────────────────────────────────" -ForegroundColor Magenta

$DllName = "emu_ffi.dll"
$DebugDll = "$RepoRoot\target\debug\$DllName"
$ReleaseDll = "$RepoRoot\target\release\$DllName"

if (Test-Path $DebugDll -and -not (Test-Path $ReleaseDll)) {
    Copy-Item $DebugDll -Destination $ReleaseDll -Force
} elseif (Test-Path $ReleaseDll -and -not (Test-Path $DebugDll)) {
    Copy-Item $ReleaseDll -Destination $DebugDll -Force
}

$WinRunnerDebug = "$OmniStationDir\build\windows\x64\runner\Debug"
$WinRunnerRelease = "$OmniStationDir\build\windows\x64\runner\Release"

if (Test-Path $WinRunnerDebug) {
    Copy-Item "$RepoRoot\target\debug\$DllName" -Destination $WinRunnerDebug -Force
    Write-Host "[SYNC] Copied $DllName to $WinRunnerDebug" -ForegroundColor Green
}
if (Test-Path $WinRunnerRelease) {
    Copy-Item "$RepoRoot\target\release\$DllName" -Destination $WinRunnerRelease -Force
    Write-Host "[SYNC] Copied $DllName to $WinRunnerRelease" -ForegroundColor Green
}

$Stopwatch.Stop()
$Elapsed = [math]::Round($Stopwatch.Elapsed.TotalSeconds, 1)

Write-Host "`n══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "[SUCCESS] Native compilation completed successfully in ${Elapsed}s!" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════════════════" -ForegroundColor Green
