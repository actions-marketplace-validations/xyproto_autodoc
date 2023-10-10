#!/bin/bash

# Variables
MODEL=${INPUT_MODEL}

# Generate a Modelfile
echo "FROM $MODEL" > Modelfile
echo "PARAMETER temperature 0.2" >> Modelfile
echo "SYSTEM \"\"\"" >> Modelfile
cat main.go >> Modelfile
echo "Write the API documentation for the above code." >> Modelfile
echo "\"\"\"" >> Modelfile

# Start ollama in the background
/ollama/ollama serve &

# Build the model file
MODEL_NAME=$(echo "${MODEL}_custom" | tr ':-' '__')
/ollama/ollama create "${MODEL_NAME}" -f Modelfile

# Run Ollama and display the output
mkdir -p github-pages
/ollama/ollama run "${MODEL_NAME}" "Use professional English. Generate a Markdown document." > "github-pages/${MODEL_NAME}.md"
cat "github-pages/${MODEL_NAME}.md"
