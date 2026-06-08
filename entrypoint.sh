#!/bin/bash
set -e

echo "=== qwen3-asr-api ==="
echo "Model: ${MODEL_ID}"
echo "Port:  ${PORT}"
echo "GPU Memory: ${GPU_MEMORY_UTILIZATION}"
echo "Max Model Len: ${MAX_MODEL_LEN}"
echo "====================="

exec qwen-asr-serve "${MODEL_ID}" \
    --host "${HOST}" \
    --port "${PORT}" \
    --gpu-memory-utilization "${GPU_MEMORY_UTILIZATION}" \
    --max-model-len "${MAX_MODEL_LEN}"
