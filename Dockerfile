FROM archlinux:base-20231001.0.182270
#FROM archlinux:base-devel-20231001.0.182270

ENV DEFAULT_MODEL codeup:13b-llama2-chat

# Install dependencies
#RUN pacman -Syu --noconfirm git go cmake
RUN pacman -Syu --noconfirm ollama

# Build Ollama in /ollama and install the executable as /usr/bin/ollama
#RUN git clone --recursive https://github.com/jmorganca/ollama /ollama && \
#    cd /ollama && \
#    go generate ./... && \
#    go build -v && \
#    install -Dm755 ollama /usr/bin/ollama && \
#    cd .. && \
#    rm -rf /ollama

# Start ollama in the background and pull the default model
RUN ollama serve & sleep 10 && ollama pull "$DEFAULT_MODEL"

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
