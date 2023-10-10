FROM archlinux:base-20231001.0.182270

ENV DEFAULT_MODEL codeup:13b-llama2-chat-q2_K

WORKDIR $GITHUB_WORKSPACE

# Install ollama
RUN pacman -Syu --noconfirm ollama

# Start ollama in the background and pull the default model
RUN ollama serve & sleep 10 && ollama pull "$DEFAULT_MODEL"

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
