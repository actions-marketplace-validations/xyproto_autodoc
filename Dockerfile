FROM archlinux:latest

# Install necessary dependencies
RUN pacman -Syu --noconfirm git go cmake

# Build Ollama
RUN git clone --recursive https://github.com/jmorganca/ollama /ollama && \
    cd /ollama && \
    go generate ./... && \
    go build -v

# Start ollama in the background and pull the model
RUN /ollama/ollama serve & \
    sleep 10 && \  # Give ollama some time to start
    /ollama/ollama pull $MODEL

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]