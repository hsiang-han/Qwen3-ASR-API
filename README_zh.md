# Qwen3-ASR-API

[English](README.md) | [中文](README_zh.md)

纯净的 OpenAI 兼容语音转文字 API，基于 [Qwen3-ASR](https://github.com/QwenLM/Qwen3-ASR)。

无多余组件、仅通过 vLLM 提供模型推理和 OpenAI 兼容接口。

## 相比官方镜像的改进

官方 `qwenllm/qwen3-asr` Docker 镜像没有 entrypoint（启动后进入交互式 shell）。本项目添加了：
- 容器启动自动运行 `qwen-asr-serve`
- 通过环境变量切换模型（无需重新构建镜像）
- GPU 显存控制
- Unraid Community Applications 模板

## 快速开始

```bash
docker run -d --gpus all --shm-size=4g \
  -p 8000:80 \
  -v /path/to/models:/root/.cache/huggingface \
  -e MODEL_ID=Qwen/Qwen3-ASR-0.6B \
  ghcr.io/hsiang-han/qwen3-asr-api:latest
```

首次启动会下载模型（约 1-3GB）。

## 使用方法（OpenAI 兼容）

```bash
curl -X POST http://localhost:8000/v1/audio/transcriptions \
  -H "Content-Type: multipart/form-data" \
  -F "file=@audio.wav" \
  -F "model=qwen3-asr"
```

或使用 OpenAI SDK：
```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:8000/v1", api_key="none")
result = client.audio.transcriptions.create(
    model="qwen3-asr",
    file=open("audio.wav", "rb")
)
print(result.text)
```

## 模型选择

| 模型 | 显存 | 速度 | 适用场景 |
|------|------|------|----------|
| `Qwen/Qwen3-ASR-0.6B` | ~2-3GB | RTFx 166 | 低延迟、共享 GPU |
| `Qwen/Qwen3-ASR-1.7B` | ~4-6GB | RTFx 148 | 最高准确率 |

修改 `MODEL_ID` 环境变量并重启容器即可切换。

## Unraid 安装

1. 添加模板仓库：`https://github.com/hsiang-han/unraid_templates`
2. 在 Community Applications 中搜索 "Qwen3-ASR-API"
3. 配置 MODEL_ID 和 GPU 设置
4. 启动——首次启动下载模型，之后秒启动

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `MODEL_ID` | `Qwen/Qwen3-ASR-0.6B` | 使用的模型 |
| `GPU_MEMORY_UTILIZATION` | `0.8` | GPU 显存分配比例（0.0-1.0） |
| `MAX_MODEL_LEN` | `8192` | KV cache 最大序列长度。默认支持约 10 分钟音频。降低可节省显存，升高可支持更长音频。 |
| `HOST` | `0.0.0.0` | 绑定地址 |
| `PORT` | `80` | 容器端口 |

## 许可证

Apache-2.0（与上游 Qwen3-ASR 一致）
