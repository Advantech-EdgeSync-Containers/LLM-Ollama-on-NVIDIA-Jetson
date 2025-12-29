#!/bin/bash

# Copyright (c) 2025 Advantech Corporation

# This script verifies AI/DL frameworks and hardware acceleration

# Clear the terminal
clear

LOG_FILE="/workspace/wise-bench.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Append timestamp to start of each run
{
  echo "==========================================================="
  echo ">>> Diagnostic Run Started at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "==========================================================="
} >> "$LOG_FILE"

# Redirect stdout & stderr to both console and file (append mode)
exec > >(tee -a "$LOG_FILE") 2>&1

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
PURPLE='\033[0;35m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo -e "${BLUE}${BOLD}|    ${PURPLE}Advantech COE Ollama Diagnostics Tool${BLUE}           |${NC}"
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo

# Show Advantech COE ASCII logo
echo -e "${BLUE}"
echo "       █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗███████╗ ██████╗██╗  ██╗     ██████╗ ██████╗ ███████╗"
echo "      ██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║    ██╔════╝██╔═══██╗██╔════╝"
echo "      ███████║██║  ██║██║   ██║███████║██╔██╗ ██║   ██║   █████╗  ██║     ███████║    ██║     ██║   ██║█████╗  "
echo "      ██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║   ██║   ██╔══╝  ██║     ██╔══██║    ██║     ██║   ██║██╔══╝  "
echo "      ██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║   ██║   ███████╗╚██████╗██║  ██║    ╚██████╗╚██████╔╝███████╗"
echo "      ╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚══════╝"
echo -e "${WHITE}                                  Center of Excellence${NC}"
echo
echo -e "${CYAN}  Starting comprehensive hardware and framework tests...${NC}"
echo

sleep 3

# Helper functions
print_header() {
    echo
    echo "+--- $1 ----$(printf '%*s' $((47 - ${#1})) | tr ' ' '-')+"
    echo "|$(printf '%*s' 50 | tr ' ' ' ')|"
    echo "+--------------------------------------------------+"
}

print_success() {
    echo "✓ $1"
}

print_warning() {
    echo "⚠ $1"
}

print_info() {
    echo "ℹ $1"
}

print_table_header() {
    echo "+--------------------------------------------------+"
    echo "| $1$(printf '%*s' $((47 - ${#1})) | tr ' ' ' ')|"
    echo "+--------------------------------------------------+"
}

print_table_row() {
    printf "| %-25s | %s |\n" "$1" "$2"
}

print_table_footer() {
    echo "+--------------------------------------------------+"
}

# System Information
print_header "SYSTEM INFORMATION"
print_table_header "SYSTEM DETAILS"

KERNEL=$(uname -r)
ARCHITECTURE=$(uname -m)
HOSTNAME=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown")
MEMORY_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
MEMORY_USED=$(free -h | awk '/^Mem:/ {print $3}')
CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2- | sed 's/^[ \t]*//' | head -1 || echo "Unknown")
CPU_CORES=$(nproc --all)
UPTIME=$(uptime -p | sed 's/^up //')

print_table_row "Hostname" "$HOSTNAME"
print_table_row "OS" "$OS"
print_table_row "Kernel" "$KERNEL"
print_table_row "Architecture" "$ARCHITECTURE"
print_table_row "CPU" "$CPU_MODEL ($CPU_CORES cores)"
print_table_row "Memory" "$MEMORY_USED used of $MEMORY_TOTAL"
print_table_row "Uptime" "$UPTIME"
print_table_row "Date" "$(date "+%a %b %d %H:%M:%S %Y")"
print_table_footer

# Data Science Libraries Test
print_header "DATA SCIENCE LIBRARIES"

print_table_header "LIBRARY VERSIONS"

# NumPy
NUMPY_VERSION=$(python3 -c "import numpy; print(numpy.__version__)" 2>/dev/null || echo "Not installed")
print_table_row "NumPy" "$NUMPY_VERSION"

# Pandas
PANDAS_VERSION=$(python3 -c "import pandas; print(pandas.__version__)" 2>/dev/null || echo "Not installed")
print_table_row "Pandas" "$PANDAS_VERSION"

# SciPy
SCIPY_VERSION=$(python3 -c "import scipy; print(scipy.__version__)" 2>/dev/null || echo "Not installed")
print_table_row "SciPy" "$SCIPY_VERSION"

# Scikit-learn
SKLEARN_VERSION=$(python3 -c "import sklearn; print(sklearn.__version__)" 2>/dev/null || echo "Not installed")
print_table_row "Scikit-learn" "$SKLEARN_VERSION"

# Matplotlib
MATPLOTLIB_VERSION=$(python3 -c "import matplotlib; print(matplotlib.__version__)" 2>/dev/null || echo "Not installed")
print_table_row "Matplotlib" "$MATPLOTLIB_VERSION"

print_table_footer

# OLLAMA TEST
print_header "OLLAMA TEST"

echo
echo -e "${PURPLE}"
echo "       ██████╗ ██╗     ██╗      █████╗ ███╗   ███╗ █████╗"
echo "      ██╔═══██╗██║     ██║     ██╔══██╗████╗ ████║██╔══██╗"
echo "      ██║   ██║██║     ██║     ███████║██╔████╔██║███████║"
echo "      ██║   ██║██║     ██║     ██╔══██║██║╚██╔╝██║██╔══██║"
echo "      ╚██████╔╝███████╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║"
echo "       ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝"
echo -e "${NC}"

echo "▶ Testing Ollama capabilities..."
print_table_header "OLLAMA DETAILS"

if command -v ollama &> /dev/null; then
    OLLAMA_VERSION=$(ollama --version 2>/dev/null | head -1 || echo "Unknown")
    OLLAMA_PATH=$(which ollama)
    print_table_row "Status" "✓ Installed"
    print_table_row "Version" "$OLLAMA_VERSION"
    print_table_row "Path" "$OLLAMA_PATH"

    # Check if ollama service is running
    if pgrep -x "ollama" > /dev/null; then
        print_table_row "Service Status" "✓ Running"

        # List installed models
        MODELS=$(ollama list 2>/dev/null | tail -n +2 | wc -l)
        print_table_row "Models Installed" "$MODELS"
    else
        print_table_row "Service Status" "⚠ Not Running"
        print_table_row "Note" "Start with 'ollama serve'"
    fi
else
    print_table_row "Status" "✗ Not Installed"
fi
print_table_footer

print_success "All diagnostics completed"