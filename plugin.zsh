#!/usr/bin/env zsh

function gpt_debug() {

read -r -d '' ex_debug << 'EOF'
File "/Users/ethanhou/Desktop/CS Projects/gpt_debug_plugin/example.py", line 6
    faulty_function()
    ^
SyntaxError: invalid syntax
EOF

read -r -d '' ex_input << 'EOF'
def faulty_function():
    x = "Hello, World!"

    print(x

faulty_function()
EOF

file_name="$2"
execution_command="$1"
working_dir=$PWD

local file=$working_dir/$file_name  # Replace "filename" with the actual file name

  if [[ -f "$file" ]]; then
    chmod +x $file  # Ensure the file has executable permission if needed
    output=$(eval "$execution_command '$file'" 2>&1 >/dev/null)  # Execute the file
  else
    echo "File not found: $file"
  fi

file_content=$(cat $file_name)

#escaped_json=$(jq -R -r -s '.' < $file_content)

file_content=$(jq -n --arg var $file_content '$var | tojson')
file_content=${file_content:1:-1}

output=$(jq -n --arg var $output '$var | tojson')
output=${output:1:-1}

ex_input=$(jq -n --arg var $ex_input '$var | tojson')
ex_input=${ex_input:1:-1}

ex_debug=$(jq -n --arg var $ex_debug '$var | tojson')
ex_debug=${ex_debug:1:-1}

OPENAI_API_KEY=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


curl=`cat <<EOS
curl --location --insecure --request POST 'https://api.openai.com/v1/chat/completions' \
--header 'Authorization: Bearer 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' \
--header 'Content-Type: application/json' \
--data-raw '{
 "model": "gpt-3.5-turbo",
 "messages": [{"role": "user", content": ""You are an expert computer scientist. Debug the following: $ex_input. Given the following debug message: $ex_debug, and return the correct code.",
 "role": "assistant", "content": "error: ["Missing closing parenthesis in print statement in line 4"], corrected_code: ["
 def faulty_function():
    x = "Hello, World!"

    print(x)

faulty_function()"]",
 "role": "user", "content": "You are an expert computer scientist. Debug the following: $file_content. Given the following debug message: $output, and return the correct code."}]
}' | jq '.choices[]'.message.content
EOS`

eval ${curl}

#post_execution() {
   # source /path/to/after_file.zsh
#}


#autoload -U add-zsh-hook
#add-zsh-hook precmd post_execution
}
