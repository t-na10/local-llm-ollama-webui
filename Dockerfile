FROM ollama/ollama

# Install pip
RUN apt-get update && apt-get install -y python3-pip

# Install additional Python packages
RUN pip3 install --no-cache-dir \
    huggingface-hub \
    hf_transfer

# Set environment variable
ENV HF_HUB_ENABLE_HF_TRANSFER=1
