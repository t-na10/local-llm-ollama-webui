# Execution example
## Llama-3.1-70B-Japanese-Instruct(IQ4_XS) with `ollama`+`webUI` on RTX 3090(24GB)×2


make dockerfile (custom ollama)
```Dockefile
FROM ollama/ollama

RUN apt-get update && apt-get install -y python3-pip

RUN pip3 install --no-cache-dir \
    huggingface-hub \
    hf_transfer

ENV HF_HUB_ENABLE_HF_TRANSFER=1
```

custom ollama build (実行1回のみ)
```bash
docker build -t ollama_custom .
```

custom ollama run
```bash
docker run -d --gpus=all -v $(pwd):/root/.ollama -p 11434:11434 --name ollama_custom ollama_custom
```

download gguf file
```bash
docker exec -it ollama_custom huggingface-cli download mmnga/Llama-3.1-70B-Japanese-Instruct-2407-gguf Llama-3.1-70B-Japanese-Instruct-2407-IQ4_XS.gguf --local-dir ./root/.ollama/
```
make modelfile
```
FROM ./Llama-3.1-70B-Japanese-Instruct-2407-IQ4_XS.gguf

TEMPLATE "{{ if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{ end }}{{ if .Prompt }}<|start_header_id|>user<|end_header_id|>

{{ .Prompt }}<|eot_id|>{{ end }}<|start_header_id|>assistant<|end_header_id|>

{{ .Response }}<|eot_id|>"

SYSTEM You are a helpful, smart, kind, and efficient Japanese AI assistant. You always fulfill the user's requests to the best of your ability in Japanese. This is first priority that you must respond answers in Japanese
PARAMETER temperature 0.3
PARAMETER top_k 10
PARAMETER top_p 0.5
PARAMETER stop <|start_header_id|>
PARAMETER stop <|end_header_id|>
PARAMETER stop <|eot_id|>
```


make model
```bash
docker exec -it ollama_custom ollama create Llama-3.1-70B-Japanese-Instruct-2407-IQ4_XS -f ./root/.ollama/Modelfile
```

model test
```bash
docker exec -it ollama_custom ollama run Llama-3.1-70B-Japanese-Instruct-2407-IQ4_XS
```

Open Web UI Docker run
```bash
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

access to http://localhost:3000
