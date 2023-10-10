#FROM archlinux:latest
#FROM archlinux:base-devel
FROM archlinux:base-devel-20231001.0.182270

# Install necessary dependencies
RUN pacman -Syu --noconfirm base-devel git go cmake

# Build Ollama
RUN git clone --recursive https://github.com/jmorganca/ollama /ollama && \
    cd /ollama && \
    go generate ./... && \
    go build -v

# Start ollama in the background and pull the model
RUN /ollama/ollama serve & \
    sleep 10 && \
    /ollama/ollama pull $MODEL

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
