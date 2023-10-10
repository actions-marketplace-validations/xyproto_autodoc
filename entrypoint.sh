#!/bin/bash

# Variables
MODEL=${INPUT_MODEL}
TEMPERATURE=${INPUT_TEMPERATURE:-0.2}  # Default to 0.2 if not provided

# Generate a Modelfile
echo "FROM $MODEL" > Modelfile
echo "PARAMETER temperature $TEMPERATURE" >> Modelfile
echo "SYSTEM \"\"\"" >> Modelfile

# Append all Go files to the Modelfile
find /workspace -name "*.go" -type f -exec cat {} + >> Modelfile

echo "Write the API documentation for the above code." >> Modelfile
echo "\"\"\"" >> Modelfile

# Start ollama in the background
ollama serve &

# Give ollama some time to start
sleep 10

# Pull the model
ollama pull $MODEL

# Build the model file
MODEL_NAME=$(echo "${MODEL}_custom" | tr ':-' '__')
ollama create "${MODEL_NAME}" -f Modelfile

# Run Ollama and display the output
mkdir -p /workspace/github-pages
ollama run "${MODEL_NAME}" "Use professional English. Generate a Markdown document." > "/workspace/github-pages/${MODEL_NAME}.md"
cat "/workspace/github-pages/${MODEL_NAME}.md"
