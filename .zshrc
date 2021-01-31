[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2

if ! zplug check; then
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

if zplug check "seebi/dircolors-solarized"; then
  which gdircolors &> /dev/null && alias dircolors='() { $(whence -p gdircolors) }'
  which dircolors &> /dev/null && \
	  eval $(dircolors ~/.zplug/repos/seebi/dircolors-solarized/dircolors.256dark)
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi

if zplug check "zsh-users/zsh-autosuggestions"; then
    pasteinit() {
        OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic
    }

    pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
    }
    zstyle :bracketed-paste-magic paste-init pasteinit
    zstyle :bracketed-paste-magic paste-finish pastefinish

    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste accept-line)
fi

if zplug check "zsh-users/zsh-syntax-highlighting"; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)	
	ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')	

	typeset -A ZSH_HIGHLIGHT_STYLES	
	ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'	
	ZSH_HIGHLIGHT_STYLES[globbing]='none'	
	ZSH_HIGHLIGHT_STYLES[path]='fg=white'	
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'	
	ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'	
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'	
	ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'	
	ZSH_HIGHLIGHT_STYLES[command]='fg=green'	
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'	
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'	
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'	
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'	
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'	
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'	
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'	
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'	
fi

if zplug check "bhilburn/powerlevel9k"; then
    DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
    DEFAULT_COLOR=$DEFAULT_FOREGROUND

    POWERLEVEL9K_MODE="nerdfont-complete"
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=0
    POWERLEVEL9K_SHORTEN_DELIMITER=""

    POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true

    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
    POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

    POWERLEVEL9K_STATUS_CROSS=true

    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status dir vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$(( $DEFAULT_BACKGROUND + 4 ))"
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND="green"
    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$(( $DEFAULT_BACKGROUND + 4 ))"
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="yellow"
    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$(( $DEFAULT_BACKGROUND + 4 ))"
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="magenta"

    POWERLEVEL9K_DIR_HOME_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_FOREGROUND"

    POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
    POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
    POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
    POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
    POWERLEVEL9K_VCS_GIT_ICON=""
    POWERLEVEL9K_HOME_ICON=''
    POWERLEVEL9K_HOME_SUB_ICON=''
    POWERLEVEL9K_FOLDER_ICON=''
    POWERLEVEL9K_ETC_ICON=''
fi

zplug load

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export PATH=~/Library/Python/3.7/bin:$PATH

alias zshconfig="code ~/.zshrc"
alias brewfix="brew update && brew upgrade && brew cleanup && brew doctor"
