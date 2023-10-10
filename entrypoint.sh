#!/bin/bash

# Variables
MODEL=${INPUT_MODEL}
TEMPERATURE=${INPUT_TEMPERATURE:-0.2}
GLOBS=${INPUT_GLOBS:-*.go}  # Default to *.go if no globs are provided

# Check if /workspace exists
if [ ! -d "/workspace" ]; then
    echo "The /workspace directory needs to exist for the documentation generation to work."
    exit 0  # exit normally
fi

# Generate a Modelfile
echo "FROM $MODEL" > Modelfile
echo "PARAMETER temperature $TEMPERATURE" >> Modelfile
echo 'SYSTEM """' >> Modelfile

# Append files matching the globs to the Modelfile
IFS=',' read -ra GLOB_ARRAY <<< "$GLOBS"  # Convert comma-separated globs into an array
for GLOB in "${GLOB_ARRAY[@]}"; do
    find /workspace -name "$GLOB" -type f -exec cat {} + >> Modelfile
done

echo "Write the API documentation for the above code." >> Modelfile
echo '"""' >> Modelfile

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
