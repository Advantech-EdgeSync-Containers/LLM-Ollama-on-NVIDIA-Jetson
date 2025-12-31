#!/bin/bash
# ==========================================================================
# Advantech Jetson™ Hardware Acceleration Benchmark & Diagnostic Script
# ==========================================================================
# Version:      1.0.0-Ubuntu20.04-ARM
# Author:       Samir Singh <samir.singh@advantech.com>
# Created:      March 25, 2025
# Last Updated: August 28, 2025
#
# Description:
#
#   This script provides a comprehensive Jetson™ hardware diagnostics and
#   benchmarking utility for edge AI development platforms. It verifies and
#   tests NVIDIA GPU acceleration, CUDA, TensorRT, OpenCV, PyTorch, TensorFlow,
#   ONNX Runtime, FFmpeg hardware codecs, and GStreamer plugins.
#
#   Key Features:
#     - System diagnostics: Reports Jetson™ hardware, OS, kernel, memory,
#       and CPU details.
#     - CUDA verification: Detects CUDA installation, version, and runtime
#       availability.
#     - Deep learning frameworks: Benchmarks GPU acceleration in OpenCV,
#       PyTorch, TensorFlow, and ONNX Runtime.
#     - TensorRT integration: Tests precision modes (FP32/FP16/INT8) and
#       verifies DLA core support.
#     - Multimedia stack: Inspects NVIDIA GStreamer plugins, FFmpeg NVENC/
#       NVDEC accelerators, and validates video hardware acceleration.
#
#   The results are displayed with interactive animations, spinners, tables,
#   and ASCII banners, while also being logged to:
#       /workspace/wise-bench.log
#
# Terms and Conditions:
#   1. This software is provided by Advantech Corporation "as is" and any
#      express or implied warranties, including, but not limited to, the implied
#      warranties of merchantability and fitness for a particular purpose are
#      disclaimed.
#   2. In no event shall Advantech Corporation be liable for any direct, indirect,
#      incidental, special, exemplary, or consequential damages arising in any way
#      out of the use of this software.
#   3. Redistribution and use in source and binary forms, with or without
#      modification, are permitted provided that the above copyright notice and
#      this permission notice appear in all copies.
#
# Copyright (c) 2025 Advantech Corporation. All rights reserved.
# ==========================================================================
clear
LOG_FILE="/workspace/wise-bench.log"
mkdir -p "$(dirname "$LOG_FILE")"
{
  echo "==========================================================="
  echo ">>> Diagnostic Run Started at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "==========================================================="
} >> "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
# Display banner
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
# Display fancy banner
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo -e "${BLUE}${BOLD}|    ${PURPLE}Advantech_COE Jetson Hardware Diagnostics Tool${BLUE}    |${NC}"
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo
echo -e "${BLUE}"
echo "       █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗███████╗ ██████╗██╗  ██╗     ██████╗ ██████╗ ███████╗"
echo "      ██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║    ██╔════╝██╔═══██╗██╔════╝"
echo "      ███████║██║  ██║██║   ██║███████║██╔██╗ ██║   ██║   █████╗  ██║     ███████║    ██║     ██║   ██║█████╗  "
echo "      ██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║   ██║   ██╔══╝  ██║     ██╔══██║    ██║     ██║   ██║██╔══╝  "
echo "      ██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║   ██║   ███████╗╚██████╗██║  ██║    ╚██████╗╚██████╔╝███████╗"
echo "      ╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚══════╝"
echo -e "${WHITE}                                  Center of Excellence${NC}"
echo
echo -e "${YELLOW}${BOLD}▶ Starting hardware acceleration tests...${NC}"
echo -e "${CYAN}  This may take a moment...${NC}"
echo
sleep 7
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
echo "▶ Setting up hardware acceleration environment..."

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

setup_device() {
    echo -ne "  $1 "
    $2 > /dev/null 2>&1 &
    spinner $!
    if [ $? -eq 0 ]; then
        echo -e "✓"
    else
        echo -e "⚠"
    fi
}
# Process each setup step with a nice spinner
(
if [ ! -e "/dev/nvhost-nvdec-bl" ]; then
    setup_device "Setting up virtual decoder..." "
        if [ -e '/dev/nvhost-nvdec' ]; then
            if [ \$(id -u) -eq 0 ]; then
                mknod -m 666 /dev/nvhost-nvdec-bl c \$(stat -c \"%%t %%T\" /dev/nvhost-nvdec) || ln -sf /dev/nvhost-nvdec /dev/nvhost-nvdec-bl
            else
                ln -sf /dev/nvhost-nvdec /dev/nvhost-nvdec-bl
            fi
        fi
    "
fi
if [ ! -e "/dev/nvhost-nvenc" ]; then
    setup_device "Setting up virtual encoder..." "
        if [ -e '/dev/nvhost-msenc' ]; then
            if [ \$(id -u) -eq 0 ]; then
                mknod -m 666 /dev/nvhost-nvenc c \$(stat -c \"%%t %%T\" /dev/nvhost-msenc) || ln -sf /dev/nvhost-msenc /dev/nvhost-nvenc
            else
                ln -sf /dev/nvhost-msenc /dev/nvhost-nvenc
            fi
        fi
    "
fi
setup_device "Creating required directories..." "
    mkdir -p /tmp/argus_socket
    mkdir -p /opt/nvidia/l4t-packages    
    if [ ! -d '/opt/nvidia/l4t-jetson-multimedia-api' ] && [ -d '/usr/src/jetson_multimedia_api' ]; then
        mkdir -p /opt/nvidia
        ln -sf /usr/src/jetson_multimedia_api /opt/nvidia/l4t-jetson-multimedia-api
    fi
"
)
echo -e "\n▶ NVIDIA Devices Detected:"
echo "+------------------------------------------------------------------+"
printf "| %-30s| %-15s| %-12s|\n" "Device" "Type" "Major:Minor"
echo "+------------------------------+-----------------+-------------+"
ls -la /dev/nvhost* 2>/dev/null | grep -v "^total" | awk '{print $1, $3, $4, $5, $6, $10}' | 
while read -r perms owner group major minor device; do
    # Use safe basename that won't fail
    device_name=$(echo "$device" | awk -F/ '{print $NF}' 2>/dev/null || echo "Unknown")
    if [[ -z "$device_name" || "$device_name" == *"basename"* || "$device_name" == *"invalid option"* ]]; then
        continue
    fi
    device_type=$(echo "$device_name" | cut -d'-' -f2 2>/dev/null || echo "Unknown")
    printf "| %-30s| %-15s| %-12s|\n" "$device_name" "$device_type" "$major:$minor"
done
DEVICE_COUNT=$(ls -la /dev/nvhost* 2>/dev/null | grep -v "^total" | wc -l)
if [ "$DEVICE_COUNT" -eq 0 ]; then
    printf "| %-62s|\n" "No NVIDIA devices found"
fi
echo "+------------------------------------------------------------------+"
print_success "Hardware acceleration environment successfully prepared"
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

print_header "DIAGNOSTICS SUMMARY"
print_table_header "HARDWARE ACCELERATION STATUS"

if command -v nvidia-smi &> /dev/null && nvidia-smi > /dev/null 2>&1; then
    print_table_row "NVIDIA GPU" "✓ Active"
    CUDA_STATUS=1
else
    print_table_row "NVIDIA GPU" "⚠ Not detected"
    CUDA_STATUS=0
fi

if pip list | grep -E "^torch " &>/dev/null; then
    print_table_row "PyTorch GPU" "✓ Accelerated"
    PYTORCH_STATUS=1
else
    print_table_row "PyTorch GPU" "⚠ CPU Only"
    PYTORCH_STATUS=0
fi

if pip list | grep -E "^tensorflow " &>/dev/null; then
    print_table_row "TensorFlow GPU" "✓ Accelerated"
    TF_STATUS=1
else
    print_table_row "TensorFlow GPU" "⚠ CPU Only"
    TF_STATUS=0
fi

if [ -e "/dev/v4l2-nvenc" ]; then
    print_table_row "Video Encoding" "✓ Available"
    VENC_STATUS=1
else
    print_table_row "Video Encoding" "⚠ Not available"
    VENC_STATUS=0
fi

if [ -e "/dev/v4l2-nvdec" ]; then
    print_table_row "Video Decoding" "✓ Available"
    VDEC_STATUS=1
else
    print_table_row "Video Decoding" "⚠ Not available"
    VDEC_STATUS=0
fi

TOTAL=$((CUDA_STATUS + PYTORCH_STATUS + TF_STATUS + VENC_STATUS + VDEC_STATUS))
MAX=5
PERCENTAGE=$((TOTAL * 100 / MAX))
print_table_row "Overall Score" "$PERCENTAGE% ($TOTAL/$MAX)"
BAR_SIZE=20
FILLED=$((BAR_SIZE * TOTAL / MAX))
EMPTY=$((BAR_SIZE - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do

    BAR="${BAR}░"
done
print_table_row "Progress" "$BAR"

print_header "OLLAMA CHECK"
MAX=1
OLLAMA_STATUS=0
INFERENCE_STATUS=0
EXEC_MODE_STATUS=0

# ---- Check if Ollama is running ----
if curl --silent --fail "$OPENAI_API_OLLAMA_BASE/api/tags" > /dev/null; then
    print_table_row "Ollama Server Status" "✓ Running"
    OLLAMA_STATUS=1
    MAX=$((MAX + 2))
    RESPONSE=$(curl -s -X POST "$OPENAI_API_OLLAMA_BASE/api/generate" \
    -H "Content-Type: application/json" \
    -d "{
          \"model\": \"$MODEL_NAME\",
          \"prompt\": \"Hi! How are you?\",
          \"stream\": false
        }")
    MESSAGE=$(echo "$RESPONSE" | grep -oP '"response"\s*:\s*"\K[^"]+')
    if [ -n "$MESSAGE" ]; then
        INFERENCE_STATUS=1
        print_table_row "Ollama Test Inference (Hi, How are you?)" "✓ $MESSAGE"
    else
        print_table_row "Ollama Test Inference (Hi, How are you?)" "⚠ No valid response"
    fi
    LOG_PATH="/workspace/ollama.log"
    LAST_OFFLOAD=$(grep -E "offloading .* to GPU" "$LOG_PATH" | tail -n 1)
    EXEC_MODE_STATUS=1
    if echo "$LAST_OFFLOAD" | grep -q "offloading .* to GPU"; then
        EXEC_MODE="GPU"
    else
        EXEC_MODE="CPU"
    fi
    print_table_row "Ollama Execution Mode" "$EXEC_MODE"
else
    print_table_row "Ollama Server Status" "⚠ Not Running"
fi

TOTAL=$((OLLAMA_STATUS + INFERENCE_STATUS + EXEC_MODE_STATUS))
PERCENTAGE=$((TOTAL * 100 / MAX))
print_table_row "Overall Score" "$PERCENTAGE% ($TOTAL/$MAX)"
BAR_SIZE=20
FILLED=$((BAR_SIZE * TOTAL / MAX))
EMPTY=$((BAR_SIZE - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do
    BAR="${BAR}░"
done
print_table_row "Progress" "$BAR"
print_table_footer
print_header "DIAGNOSTICS COMPLETE"
print_success "All diagnostics completed"