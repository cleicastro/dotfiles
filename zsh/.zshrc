# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gnzh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	jsontools
	history
	dirhistory
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.ghidra:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"
export PATH="/usr/local/bin/terragrunt:$PATH"
export PATH="/usr/local/bin/platform-tools:$PATH"

# THIS IS FRAMEWORK KATOOLIN FOR INSTALL APPS FROM KALI-LINUX
export PATH="/usr/bin/katoolin:$PATH"
alias hacker="sudo python2 /usr/bin/katoolin/katoolin.py"

alias android-studio="sudo sh /usr/local/android-studio/bin/studio.sh"
alias emulator="~/Android/Sdk/emulator/emulator"
alias power-tv="wakeonlan D8:3A:DD:0A:AB:98"

# Environments to DRM
export WORKSPACE=$HOME/projects/drm-starter
export DRM_WRAPPER_HOME=$WORKSPACE/projects/drm-wrapper/drm-wrapper
export DRM=$HOME/DRM
export KEYSTORE=$WORKSPACE/projects/apkbuild/apkbuild/appstore.keystore
export WORK=$HOME/wrapper-v2/work/
export ANDROID_HOME=$HOME/DevTools/Android/
export PATH=$PATH:$WORKSPACE/shell-scripts
export PATH=$PATH:$WORKSPACE/shell-scripts/pidcat
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/27.0.1
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/snap/bin

#PYTHON
#export PYTHON="/usr/bin/python2:"$PATH
# export PYTHON="/usr/bin/python:"$PATH
#alias python=/usr/bin/python2

#GO LANG
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

alias awsbash="f(){ aws ecs execute-command --region us-east-1 --cluster appsclub-br-\""\$2\"" --task \$(aws ecs list-tasks --cluster=appsclub-br-\""\$2\"" --service-name=\""\$1\""-\""\$2\"" | grep 'arn:aws:ecs:us-east-1' -m 1 | sed 's/\"//g;s/,//g') --container \""\$1\""-\""\$2\"" --command \"/bin/sh \" --interactive }; f"

media-importer() {
    local mediaId=$1
    aws batch submit-job \
        --job-name media-importer-"${mediaId}" \
        --job-queue media-importer-job-queue \
        --job-definition media-importer-job-definition \
        --container-overrides '{
            "environment": [
                {
                    "name": "PAYLOAD_MEDIA_IMPORTER",
                    "value": "{\"action\":\"save_from_prod_id\",\"id\":\"'"${mediaId}"'\"}"
                }
            ]
        }'
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.tfenv/bin:$PATH"
export PATH=$PATH:/opt/jadx/bin
