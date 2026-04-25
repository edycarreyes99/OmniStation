#!/usr/bin/env bash
# ==============================================================================
# OmniStation — Native Build Script (C++23 Cores + Rust Host FFI)
# macOS / Linux Bash Compiler & Test Runner
# ==============================================================================

set -euo pipefail

# ANSI color codes
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${REPO_ROOT}/build"
OMNISTATION_DIR="${REPO_ROOT}/omnistation"

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         OmniStation — Native Compilation Pipeline (C++ & Rust)   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo -e "Project Root: ${REPO_ROOT}"
echo ""

START_TIME=$(date +%s)

# ------------------------------------------------------------------------------
# 1. C++23 Cores Compilation with CMake
# ------------------------------------------------------------------------------
echo -e "${PURPLE}▶ PHASE 1: Configuring and Compiling C++23 Cores (CMake Release)${NC}"
echo -e "${PURPLE}──────────────────────────────────────────────────────────────────${NC}"

cd "${REPO_ROOT}"
cmake -B "${BUILD_DIR}" -S . -DCMAKE_BUILD_TYPE=Release
cmake --build "${BUILD_DIR}" --config Release --parallel

if [ -f "${BUILD_DIR}/cores/tests/omnistation_tests" ]; then
    echo -e "${CYAN}[INFO] Running C++23 GoogleTest...${NC}"
    "${BUILD_DIR}/cores/tests/omnistation_tests"
fi

# ------------------------------------------------------------------------------
# 2. Rust Crates & emu_ffi Compilation with Cargo
# ------------------------------------------------------------------------------
echo ""
echo -e "${PURPLE}▶ PHASE 2: Compiling Rust Crates and emu_ffi (Cargo Edition 2024)${NC}"
echo -e "${PURPLE}──────────────────────────────────────────────────────────────────${NC}"

cargo build --workspace
cargo build --release -p emu_ffi
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace

# ------------------------------------------------------------------------------
# 3. Dynamic FFI Library Synchronization
# ------------------------------------------------------------------------------
echo ""
echo -e "${PURPLE}▶ PHASE 3: Synchronizing Native Dynamic Libraries${NC}"
echo -e "${PURPLE}──────────────────────────────────────────────────────────────────${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    DYLIB_NAME="libemu_ffi.dylib"
    TARGET_APP_FRAMEWORKS="${OMNISTATION_DIR}/build/macos/Build/Products/Debug/omnistation.app/Contents/Frameworks"
    TARGET_APP_MACOS="${OMNISTATION_DIR}/build/macos/Build/Products/Debug/omnistation.app/Contents/MacOS"
    
    codesign -f -s - "${REPO_ROOT}/target/debug/${DYLIB_NAME}" 2>/dev/null || true
    if [ -f "${REPO_ROOT}/target/release/${DYLIB_NAME}" ]; then
        codesign -f -s - "${REPO_ROOT}/target/release/${DYLIB_NAME}" 2>/dev/null || true
    fi
    
    if [ -d "${TARGET_APP_FRAMEWORKS}" ]; then
        cp "${REPO_ROOT}/target/debug/${DYLIB_NAME}" "${TARGET_APP_FRAMEWORKS}/${DYLIB_NAME}"
        codesign -f -s - "${TARGET_APP_FRAMEWORKS}/${DYLIB_NAME}" 2>/dev/null || true
        echo -e "${GREEN}[SYNC] Copied and signed ${DYLIB_NAME} to ${TARGET_APP_FRAMEWORKS}${NC}"
    fi
    if [ -d "${TARGET_APP_MACOS}" ]; then
        cp "${REPO_ROOT}/target/debug/${DYLIB_NAME}" "${TARGET_APP_MACOS}/${DYLIB_NAME}"
        codesign -f -s - "${TARGET_APP_MACOS}/${DYLIB_NAME}" 2>/dev/null || true
        echo -e "${GREEN}[SYNC] Copied and signed ${DYLIB_NAME} to ${TARGET_APP_MACOS}${NC}"
    fi
else
    DYLIB_NAME="libemu_ffi.so"
fi

# Ensure synchronization across target debug and release directories
if [ -f "${REPO_ROOT}/target/debug/${DYLIB_NAME}" ] && [ ! -f "${REPO_ROOT}/target/release/${DYLIB_NAME}" ]; then
    cp "${REPO_ROOT}/target/debug/${DYLIB_NAME}" "${REPO_ROOT}/target/release/${DYLIB_NAME}"
elif [ -f "${REPO_ROOT}/target/release/${DYLIB_NAME}" ] && [ ! -f "${REPO_ROOT}/target/debug/${DYLIB_NAME}" ]; then
    cp "${REPO_ROOT}/target/release/${DYLIB_NAME}" "${REPO_ROOT}/target/debug/${DYLIB_NAME}"
fi

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}[SUCCESS] Native compilation completed successfully in ${ELAPSED}s!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════════════${NC}"
