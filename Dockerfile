#FROM archlinux:latest
#FROM archlinux:base-devel
FROM archlinux:base-devel-20231001.0.182270

# Install necessary dependencies
RUN pacman -Syu --noconfirm base-devel cmake git go ollama

# Start ollama in the background and pull the model
RUN ollama serve & \
    sleep 10 && ollama pull $MODEL

# Copy the script that will run when the action is triggered
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
