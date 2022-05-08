#!/bin/bash
set +e  # Continue on errors

COLOR_BLUE="\033[0;94m"
COLOR_GREEN="\033[0;92m"
COLOR_RESET="\033[0m"

RUN_CMD="go run -mod vendor ./main.go --debug"
DEBUG_CMD="dlv debug ./main.go --headless --api-version=2 --accept-multiclient --continue --listen=:2345 --output=/tmp/__debug --build-flags=\"-gcflags='all=-N -l' -mod=vendor\""
ARELO_CMD="arelo -p '**/*.go' -i '**/*_test.go' -- ${DEBUG_CMD}"

# Print useful output for user
echo -e "${COLOR_BLUE}
     %########%      
     %###########%       ____                 _____                      
         %#########%    |  _ \   ___ __   __ / ___/  ____    ____   ____ ___ 
         %#########%    | | | | / _ \\\\\ \ / / \___ \ |  _ \  / _  | / __// _ \\
     %#############%    | |_| |(  __/ \ V /  ____) )| |_) )( (_| |( (__(  __/
     %#############%    |____/  \___|  \_/   \____/ |  __/  \__,_| \___\\\\\___|
 %###############%                                  |_|
 %###########%${COLOR_RESET}


Welcome to your development container!

This is how you can work with it:
- Files will be synchronized between your local machine and this container
- Some ports will be forwarded, so you can access this container via localhost
- Run \`${COLOR_CYAN}${RUN_CMD}${COLOR_RESET}\` to start vcluster

If you wish to run app in the debug mode with delve, run:
  \`${COLOR_CYAN}${DEBUG_CMD}${COLOR_RESET}\`
  OR 
  \`${COLOR_CYAN}${ARELO_CMD}${COLOR_RESET}\`
  Wait until the \`${COLOR_CYAN}API server listening at: [::]:2345${COLOR_RESET}\` message appears
  Start the \"Debug app (localhost:2346)\" configuration in VSCode to connect your debugger session.
  ${COLOR_CYAN}Note:${COLOR_RESET} app won't start until you connect with the debugger.
  ${COLOR_CYAN}Note:${COLOR_RESET} app will be stopped once you detach your debugger session.
"

# Set terminal prompt
export PS1="\[${COLOR_BLUE}\]devspace\[${COLOR_RESET}\] ./\W \[${COLOR_BLUE}\]\\$\[${COLOR_RESET}\] "
if [ -z "$BASH" ]; then export PS1="$ "; fi

# Include project's bin/ folder in PATH
export PATH="./bin:$PATH"

# add useful commands to the history for convenience
export HISTFILE=/tmp/.bash_history
history -s $DEBUG_CMD
history -s $RUN_CMD
history -s $ARELO_CMD
history -a

# Open shell
# hide "I have no name!" from the bash prompt when running as non root
bash --init-file <(echo "export PS1=\"\\H:\\W\\$ \"")
