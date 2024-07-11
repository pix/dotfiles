# Function to set up docker_context segment for p10k
function setup_p10k_docker_context() {
  # Define the docker_context prompt segment
  function prompt_docker_context() {
    if [ -f /.dockerenv ] || [ -n "$(env | grep "^GITPOD")" ]; then
      local docker_info=$(hostname)
      p10k segment -b 4 -f 7 -i '🐳' -t "${docker_info}"
    fi
  }
 
  # Define the instant prompt function
  # function instant_prompt_docker_context() {
  #   prompt_docker_context
  # }
 
  # Set colors and icon
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=2
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND=0
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='🐳'
}

setup_p10k_docker_context