#FROM archlinux:latest
#FROM archlinux:base-20231001.0.182270
FROM archlinux:base-devel-20231001.0.182270

# Install dependencies
RUN pacman -Syu --noconfirm base-devel git go cmake

# Build Ollama
RUN git clone --recursive https://github.com/jmorganca/ollama /ollama && \
    cd /ollama && \
    go generate ./... && \
    go build -v &&
    cp ollama /usr/bin/ollama &&
    chmod +x /usr/bin/ollama &&
    rm -rf /ollama

# Start ollama in the background and pull the model
RUN ollama serve & sleep 10 && ollama pull $MODEL

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
