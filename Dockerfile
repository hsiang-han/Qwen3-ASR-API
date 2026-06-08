FROM qwenllm/qwen3-asr:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MODEL_ID=Qwen/Qwen3-ASR-0.6B \
    HOST=0.0.0.0 \
    PORT=80 \
    GPU_MEMORY_UTILIZATION=0.8 \
    MAX_MODEL_LEN=8192 \
    HF_ENDPOINT=https://huggingface.co

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -sf http://localhost:${PORT}/health || exit 1

ENTRYPOINT ["/entrypoint.sh"]
