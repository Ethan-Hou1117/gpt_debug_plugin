#!/bin/zsh

file=$1
file_content=$(cat "$file")
escaped_content=$(printf "%q" "$file_content")


#file_content=$(cat "$PWD")

OPENAI_API_KEY=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

api_response=$(curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content":"debug the following code: '"$escaped_content"'"}]
  }'
)

# Extract and print the desired information from the response
# Customize this section based on the structure of the response

echo "$api_response"

export PATH="$HOME/.zsh-plugins:$PATH"


# You can further process the response or extract specific information as needed
# For example, if the response is in JSON format, you can use tools like jq to parse and extract specific fields
