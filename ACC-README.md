Unlock AI innovation on Advantech Edge with an Ollama-powered container with Meta Llama 3.2 1B, optimized for Jetson Orin NX and NVIDIA GPU passthrough. Includes all dependencies, Ollama runtime, UI, and REST API support—no setup headaches.

# LLM Ollama on NVIDIA Jetson™

### About Advantech Container Catalog
The Advantech Container Catalog offers plug-and-play, GPU-accelerated container images for Edge AI development on NVIDIA Jetson™. These containers abstract hardware complexity, enabling developers to build and deploy AI solutions without worrying about drivers, runtime, or CUDA compatibility.

### Key benefits of the Container Catalog include:
| Feature / Benefit                              | Description                                                                |
|----------------------------------------------------|--------------------------------------------------------------------------------|
| Accelerated Edge AI Development                    | Ready-to-use containerized solutions for fast prototyping and deployment       |
| Hardware Compatibility Solved                      | Eliminates embedded hardware and AI software package incompatibility           |
| GPU/NPU Access Ready                               | Supports passthrough for efficient hardware acceleration                       |
| Model Conversion & Optimization                    | Built-in AI model quantization and format conversion support                   |
| Optimized for CV & LLM Applications                | Pre-optimized containers for computer vision and large language models         |
| Open Ecosystem                                     | 3rd-party developers can integrate new apps to expand the platform             |


## Container Overview

This container image, LLM Ollama on NVIDIA Jetson™, bundles a ready-to-use Ollama inference engine with the Meta Llama 3.2 1B model and the OpenWebUI interface for LLM interaction. Developed for NVIDIA Jetson™, this image offers:
- On-device LLM (Meta Llama 3.2 1B via Ollama) inference (no internet required post-setup)
- Open-AI compatible APIs
- Streaming chat support via OpenWebUI & Ollama
- Modelfile for customizing model parameters


## Container Demo
![Demo](data%2Fgifs%2Fllama.gif)

## Use Case 

- Private LLM Inference on Local Devices: Run large language models locally with no internet requirement—ideal for privacy-critical environments

- Lightweight Backend for LLM APIs: Use Ollama to expose models via its local API for fast integration with tools like LangChain, FastAPI, or custom UIs.

- Document-Based Q&A Systems: Combine Ollama with a vector database to create offline RAG (Retrieval-Augmented Generation) systems for querying internal documents or manuals.

- Rapid Prototyping for Prompt Engineering: Use the Modelfile to fine-tune system prompts, default instructions, and model parameters—great for experimenting with prompt structures or multi-turn workflows.

- Multilingual Assistants: Deploy multilingual chatbots using local models that can translate, summarize, or interact in different languages without depending on cloud services.

- LLM Evaluation and Benchmarking Easily swap and test different quantized models (e.g., Mistral, LLaMA, DeepSeek) to compare performance, output quality, and memory usage across devices.

- Custom Offline Agents: Use Ollama as the reasoning core of intelligent agents that interact with other local tools (e.g., databases, APIs, sensors)—especially powerful when paired with LangChain


## Key Features

- Ollama Integration: Lightweight inference engine for quantized models
- Complete AI Framework Stack: PyTorch, TensorFlow, ONNX Runtime, and TensorRT™
- Industrial Vision Support: Accelerated OpenCV and GStreamer pipelines
- Edge AI Capabilities: Support for computer vision, LLMs, and time-series analysis
- Performance Optimized: Tuned specifically for NVIDIA® Jetson Orin™ NX 8GB
- System Prompt & Temperature Control: Fine-tune the parameters using Modelfile.

## Host Device Prerequisites
| Item | Specification                                                                                                                                                             |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Compatible Hardware | Advantech devices accelerated by NVIDIA Jetson™—refer to [Compatible Hardware](https://catalog.advantech.com/en-us/containers/jetson-gpu-passthrough/compatible-hardware) |
| NVIDIA Jetson™ Version | 5.x                                                                                                                                                                       |
|Host OS          | Ubuntu 20.04                                                                                                                                                              |
| Required Software Packages | Refer to Below                                                                                                                                                            |
| Software Installation | [NVIDIA Jetson™ Software Package Installation](https://developer.advantech.com/EdgeSync/Containers/Environment/NVIDIA)                                                    |                                                                                                    |

### Required Software Packages on Host Device
These packages are bound with the NVIDIA Jetson™ version of the device. This container supports NVIDIA Jetson™ 5.x. 

| Component     | Version          | Description                        |
|---------------|------------------|------------------------------------|
| CUDA® Toolkit | 11.4.315         | GPU computing platform             |
| cuDNN         | 8.6.0            | Deep Neural Network library        |
| TensorRT™     | 8.5.2.2          | Inference optimizer and runtime    |
| VPI           | 2.2.7 or above   |                                    |
| Vulkan        | 1.3.204 or above |                                    |
| OpenCV        | 4.5.0            | Computer vision library with CUDA® |

## Container Environment Overview

### Software Components on Container Image

| Component | Version | Description                               |
|-----------|---------|-------------------------------------------|
| CUDA® | 11.4.315 | GPU computing platform                    |
| cuDNN | 8.6.0 | Deep Neural Network library |
| TensorRT™ | 8.5.2.2 | Inference optimizer and runtime |
| PyTorch | 2.0.0+nv23.02 | Deep learning framework                   |
| TensorFlow | 2.12.0 | Machine learning framework                |
| ONNX Runtime | 1.16.3 | Cross-platform inference engine           |
| OpenCV | 4.5.0 | Computer vision library with CUDA® |
| GStreamer | 1.16.2 | Multimedia framework |
| Ollama | 0.5.7 | LLM inference engine                      |
| OpenWebUI | 0.6.5 | Web interface for chat interactions                      |

### Container Quick Start Guide
For container quick start, including the docker-compose file and more, please refer to [README.](https://github.com/Advantech-EdgeSync-Containers/Nagarro-Container-Project/blob/main/LLM-Ollama-on-NVIDIA-Jetson/README.md)

### Supported AI Capabilities

#### Vision Models

| Model Family | Versions | Performance (FPS) | Quantization Support |
|--------------|----------|-------------------|---------------------|
| YOLO | v3/v4/v5 (up to v5.6.0), v6 (up to v6.2), v7 (up to v7.0), v8 (up to v8.0) | YOLOv5s: 45-60 @ 640x640, YOLOv8n: 40-55 @ 640x640, YOLOv8s: 30-40 @ 640x640 | INT8, FP16, FP32 |
| SSD | MobileNetV1/V2 SSD, EfficientDet-D0/D1 | MobileNetV2 SSD: 50-65 @ 300x300, EfficientDet-D0: 25-35 @ 512x512 | INT8, FP16, FP32 |
| Faster R-CNN | ResNet50/ResNet101 backbones | ResNet50: 3-5 @ 1024x1024 | FP16, FP32 |
| Segmentation | DeepLabV3+, UNet | DeepLabV3+ (MobileNetV2): 12-20 @ 512x512 | INT8, FP16, FP32 |
| Classification | ResNet (18/50), MobileNet (V1/V2/V3), EfficientNet (B0-B2) | ResNet18: 120-150 @ 224x224, MobileNetV2: 180-210 @ 224x224 | INT8, FP16, FP32 |
| Pose Estimation | PoseNet, HRNet (up to W18) | PoseNet: 15-25 @ 256x256 | FP16, FP32 |

### Language Models Recommendation

| Model Family | Parameters | Quantization | Size | Performance  |
|--------------|------------|--------------|------|--------------|
| DeepSeek R1 | 1.5 B | Q4_K_M | 1.1 GB | ~15-17 tokens/sec |
| DeepSeek R1 | 7 B | Q4_K_M | 4.7 GB | ~5-7 tokens/sec |
| DeepSeek Coder | 1.3 B | Q4_0 | 776 MB | ~20-25 tokens/sec |
| Llama 3.2 | 1 B | Q8_0 | 1.3 GB | ~17-20 tokens/sec |
| Llama 3.2 Instruct | 1 B | Q4_0 | ~0.8 GB | ~17-20 tokens/sec |
| Llama 3.2 | 3 B | Q4_K_M | 2 GB | ~10-12 tokens/sec |
| Llama 2 | 7 B | Q4_0 | 3.8 GB | ~5-7 tokens/sec |
| Tinyllama | 1.1 B | Q4_0 | 637 MB | ~22-27 tokens/sec |
| Qwen 2.5 | 0.5 B | Q4_K_M | 398 MB | ~25-30 tokens/sec |
| Qwen 2.5 | 1.5 B | Q4_K_M | 986 MB | ~15-17 tokens/sec |
| Qwen 2.5 Coder | 0.5 B | Q8_0 | 531 MB | ~25-30 tokens/sec |
| Qwen 2.5 Coder | 1.5 B | Q4_K_M | 986 MB | ~15-17 tokens/sec |
| Qwen | 0.5 B | Q4_0 | 395 MB | ~25-30 tokens/sec |
| Qwen | 1.8 B | Q4_0 | 1.1 GB | ~15-20 tokens/sec |
| Gemma 2 | 2 B | Q4_0 | 1.6 GB | ~10-12 tokens/sec |
| Mistral | 7 B | Q4_0 | 4.1 GB | ~5-7 tokens/sec |

*Meta Llama 3.2 1B Optimizations Recommendations:*
- Use INT4-8 (Q4, Q8) quantized models for faster inference
- Best performance with TensorRT™ engine conversion
- Use Jetson™ clocks & higher power modes, if possible
- Run with Jetson™ clocks enabled
- Avoid loading the model from slow storage like SD/eMMC.
- Ensure model is fully loaded into GPU
- Use SWAP/ZRAM in case the model's memory requirements are higher


## Supported AI Model Formats

| Format | Support Level | Compatible Versions | Notes |
|--------|---------------|---------------------|-------|
| ONNX | Full | 1.10.0 - 1.16.3 | Recommended for cross-framework compatibility |
| TensorRT™ | Full | 7.x - 8.5.x | Best for performance-critical applications |
| PyTorch (JIT) | Full | 1.8.0 - 2.0.0 | Native support via TorchScript |
| TensorFlow SavedModel | Full | 2.8.0 - 2.12.0 | Recommended TF deployment format |
| TFLite | Partial | Up to 2.12.0 | May have limited hardware acceleration |
| GGUF | Full | v3 | Format used by Ollama backend |

## Hardware Acceleration Support

| Accelerator | Support Level | Compatible Libraries | Notes |
|-------------|---------------|----------------------|-------|
| CUDA® | Full | PyTorch, TensorFlow, OpenCV, ONNX Runtime | Primary acceleration method |
| TensorRT™ | Full | ONNX, TensorFlow, PyTorch (via export) | Recommended for inference optimization |
| cuDNN | Full | PyTorch, TensorFlow | Accelerates deep learning primitives |
| NVDEC | Full | GStreamer, FFmpeg | Hardware video decoding |
| NVENC | Full | GStreamer, FFmpeg | Hardware video encoding |
| DLA | Partial | TensorRT™ | Requires specific model optimization |
