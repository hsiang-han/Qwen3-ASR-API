# Qwen3-ASR-API

[English](README.md) | [中文](README_zh.md)

Pure OpenAI-compatible Speech-to-Text API powered by [Qwen3-ASR](https://github.com/QwenLM/Qwen3-ASR).

No extra services, no NGINX, no voiceprint database — just the model served via vLLM with an OpenAI-compatible endpoint.

## What this adds

The official `qwenllm/qwen3-asr` Docker image has no entrypoint (drops to interactive shell), making it unusable on platforms like Unraid. This project adds an entrypoint for out-of-the-box usage, compatible with any Docker environment:
- Auto-start `qwen-asr-serve` on container launch
- Environment variable for model switching (no rebuild needed)
- GPU memory control via env var
- Unraid Community Applications template

## Quick Start

```bash
docker run -d --gpus all --shm-size=4g \
  -p 8000:80 \
  -v /path/to/models:/root/.cache/huggingface \
  -e MODEL_ID=Qwen/Qwen3-ASR-0.6B \
  ghcr.io/hsiang-han/qwen3-asr-api:latest
```

First start downloads the model (~1-3GB depending on variant).

## Usage (OpenAI-compatible)

```bash
curl -X POST http://localhost:8000/v1/audio/transcriptions \
  -H "Content-Type: multipart/form-data" \
  -F "file=@audio.wav" \
  -F "model=qwen3-asr"
```

Or with OpenAI SDK:
```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:8000/v1", api_key="none")
result = client.audio.transcriptions.create(
    model="qwen3-asr",
    file=open("audio.wav", "rb")
)
print(result.text)
```

## Model Options

| Model | VRAM | Speed | Best for |
|-------|------|-------|----------|
| `Qwen/Qwen3-ASR-0.6B` | ~2-3GB | RTFx 166 | Low latency, shared GPU |
| `Qwen/Qwen3-ASR-1.7B` | ~4-6GB | RTFx 148 | Best accuracy |

Switch by changing `MODEL_ID` env var and restarting container.

## Unraid Install

1. Add template repo: `https://github.com/hsiang-han/unraid_templates`
2. Find "Qwen3-ASR-API" in Community Applications
3. Configure MODEL_ID and GPU settings
4. Start — first launch downloads model, subsequent starts are fast

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MODEL_ID` | `Qwen/Qwen3-ASR-0.6B` | Model to serve |
| `GPU_MEMORY_UTILIZATION` | `0.8` | GPU memory fraction (0.0-1.0) |
| `MAX_MODEL_LEN` | `8192` | Max sequence length for KV cache. Default supports ~10 min audio. Lower to save VRAM, raise for longer audio. |
| `HOST` | `0.0.0.0` | Bind address |
| `PORT` | `80` | Container port |

## License

Apache-2.0 (same as upstream Qwen3-ASR)
