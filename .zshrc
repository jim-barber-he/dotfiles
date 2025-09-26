# Path additions
[[ -d /usr/local/go ]] && PATH="/usr/local/go/bin:$PATH"
[[ -d $HOME/go/bin ]] && PATH="$HOME/go/bin:$PATH"
[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"

#------------------------------------------------------------------------------
# The majority of this section is the standard .zshrc file installed for users by Debian but with local tweaks.

# The zsh global config files aren't looking at the /etc/profile.d/*.sh files so do it here.
if [[ -d /etc/profile.d ]]
then
	for i in /etc/profile.d/*.sh
	do
		[[ -r $i ]] && source $i
	done
	unset i
fi

# Use starship (https://github.com/starship/starship) to manage the prompt if it is installed.
# Install starship like so as root:
#    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
# Otherwise use zsh's prompt handling.
if command -v starship >/dev/null
then
	eval "$(starship init zsh)"
else
	autoload -Uz promptinit
	promptinit
	prompt redhat
fi

setopt histignorealldups

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Use modern completion system
mkdir -p ~/.cache/zsh
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#===============================================================================
# Additional local configuration that zsh's default does not supply.

# Example entries shown in Oh My Zsh docs that I need to research.
#fpath+=~/.zfunc
#compinit -U

#------------------------------------------------------------------------------
# The Oh My Zsh plugin
# Install it like so:
#   git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh

if [[ -d $HOME/.oh-my-zsh ]]
then
	# Oh My Zsh requires this to be set.
	export ZSH="$HOME/.oh-my-zsh"

	CASE_SENSITIVE=true            # For case sensitivity on tab completion.
	COMPLETION_WAITING_DOTS=true
	DISABLE_AUTO_UPDATE=true
	ENABLE_CORRECTION=false
	# These aliases won't be auto-expanded.
	GLOBALIAS_FILTER_VALUES=(
		cls
		cp
		df
		diff
		dotfiles
		egrep
		fgrep
		grep
		journalctl
		ls
		ll
		man
		mkdir
		more
		mv
		service
		ssh
		sudo
		systemctl
		vi
		view
		vimdiff
		zgrep
	)
	HIST_STAMPS=yyyy-mm-dd
	#HYPHEN_INSENSITIVE=false       # Tab completion will no longer treat hyphens and underscores as interchangable.
	SHOW_AWS_PROMPT=false           # Stop aws plugin from setting RPROMPT
	VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
	# This is so when I run `sudo -s` it won't pick on the permissions of the .zsh* files since they are not owned by root.
	ZSH_DISABLE_COMPFIX=true

	# Oh My Zsh variable to define what plugins to load.
	plugins=(
		gitfast
		# Below I modify the function this installs.
		globalias
		#history-substring-search  # Needs extra stuff installed, but seems interesting.
		thefuck
	)
	command -v aws >/dev/null && plugins+=(aws)
	command -v docker >/dev/null && plugins+=(docker docker-compose)
	command -v go >/dev/null && plugins+=(golang)
	command -v helm >/dev/null && plugins+=(helm)
	command -v kops >/dev/null && plugins+=(kops)
	command -v kubectl >/dev/null && plugins+=(kubectl)
	source ~/.oh-my-zsh/oh-my-zsh.sh

	# Override the globalias implementation.
	globalias() {
		# Get last word to the left of the cursor:
		# (z) splits into words using shell parsing
		# (A) makes it an array even if there's only one element
		local word=${${(Az)LBUFFER}[-1]}
		# My own hack to strip characters off $word keeping only alphanumerics, underscores, dots, and hyphens.
		# This stops for example '$(alias' getting expanded if 'alias' is in the GLOBALIAS_FILTER_VALUES array.
		word="${word//[^A-Za-z0-9_.-]/}"
		if [[ $GLOBALIAS_FILTER_VALUES[(Ie)$word] -eq 0 ]]; then
			zle _expand_alias
			# Removed expand-word since I don't want things like {1..10} expanding.
			# Also in certain situations it was running commands when it shouldn't.
			#zle expand-word
		fi
		zle self-insert
	}
fi

#------------------------------------------------------------------------------
# The zsh-autosuggestions plugin

if [[ -d /usr/share/zsh-autosuggestions ]]
then
	bindkey '^F' autosuggest-accept
	bindkey '^K' forward-word
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

#------------------------------------------------------------------------------
# The zsh-syntax-highlighting plugin

if [[ -d /usr/share/zsh-syntax-highlighting ]]
then
	# Don't underline filenames in syntax highlighting.
	(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[path]=none

	# Make comments on the command line a grey (instead of black which is not visible on terminals with black backgrounds).
	ZSH_HIGHLIGHT_STYLES[comment]="fg=#666666"

	# Fix slow pastes with zsh-syntax-highlighting
	pasteinit() {
		OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
		zle -N self-insert url-quote-magic
	}
	pastefinish() {
		zle -N self-insert $OLD_SELF_INSERT
	}
	zstyle :bracketed-paste-magic paste-init pasteinit
	zstyle :bracketed-paste-magic paste-finish pastefinish

	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#------------------------------------------------------------------------------
# Regular zsh settings.

# Oh My Zsh turns on history sharing but I find it annoying and want each window to remember its own history.
unsetopt sharehistory

# Override the colours given by Oh My Zsh for completion for the kill command.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Multiple zsh sessions will append to the history file instead of truncating it.
APPEND_HISTORY=1

# Don't use dot files as suggestions for corrections.
CORRECT_IGNORE_FILE='.*'

# Don't show an inverse % symbol at the end of output that didn't end in a newline.
PROMPT_EOL_MARK=''

#------------------------------------------------------------------------------
# Other environment variables

# AWS
if [[ -d $HOME/.aws ]]
then
	export AWS_DEFAULT_PROFILE=${AWS_DEFAULT_PROFILE:-$AWS_PROFILE}
	export AWS_PROFILE=${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}
	[[ -n $AWS_DEFAULT_PROFILE ]] || unset AWS_DEFAULT_PROFILE
	[[ -n $AWS_PROFILE ]] || unset AWS_PROFILE

	export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-${AWS_REGION:-$(aws configure get region 2>/dev/null)}}
	export AWS_REGION=${AWS_REGION:-$AWS_DEFAULT_REGION}
	[[ -n $AWS_DEFAULT_REGION ]] || unset AWS_DEFAULT_REGION
	[[ -n $AWS_REGION ]] || unset AWS_REGION

	# Enable AWS SDKs to look at the ~/.aws/config file by default so that AWS SSO works.
	export AWS_SDK_LOAD_CONFIG=1
fi

# Variables so that Docker builds show full logs that aren't truncated.
if command -v docker > /dev/null
then
	export BUILDKIT_PROGRESS=plain
	export PROGRESS_NO_TRUNC=1
fi

# Set the preferred editor.
export EDITOR=$(command -v nvim || command -v vim || echo vi)

# Coloured GCC warnings and errors
command -v gcc > /dev/null && export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Allow GPG to prompt for my password when I sign commits.
command -v gpg > /dev/null && export GPG_TTY=$(tty)

# If `bat` is installed syntax highlight manpages.
#command -v batcat > /dev/null && export MANPAGER="sh -c 'col -bx | batcat -l man --paging=auto -p'" && export MANROFFOPT="-c"
command -v batcat > /dev/null \
	&& export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | batcat -p -l man --paging=always'" \
	&& export MANROFFOPT="-c"

# Use less as a pager.
command -v less >/dev/null && export PAGER='less -EX'

# Define a custom output format for the ps command
#export PS_FORMAT='user:19,pid,ppid,%cpu,%mem,rss,vsz,ni,nlwp,psr,stime,tname,time,cmd'
export PS_FORMAT='user:19,pid,ppid,stime,tname,time,cmd'

# Don't have AWS SAM send telemetry.
command -v sam > /dev/null && export SAM_CLI_TELEMETRY=0

# By default journalctl uses less as the PAGER with the FRSXMK options. Remove the S so that lines wrap.
# Also because I set PAGER='less -EX', the E option is in effect, so alias journalctl to use PAGER=less with no options later.
export SYSTEMD_LESS=FRXMK

#------------------------------------------------------------------------------
# Command line completion

command -v eksctl >/dev/null && source <(eksctl completion zsh)
command -v gh >/dev/null && source <(gh completion -s zsh)
command -v helmfile >/dev/null && source <(helmfile completion zsh)
command -v stern >/dev/null && source <(stern --completion zsh)
command -v ssm >/dev/null && source <(ssm completion zsh)

#------------------------------------------------------------------------------
# Functions

ltr()
{
	ls -ltr --time-style=long-iso "$@" | grep " $(date --rfc-3339=date) "
}

# Function to create a new git worktree and cd into it.
# Using `zsh -c 'script' _ $ARGS` is a way to get `set -e` working in an interactive zsh session.
worktree()
{
	(( $# == 1 )) || { echo >&2 "Usage: worktree BRANCH_NAME"; return 1 }
	zsh -c '
		set -e
		if git status -sb | head -1 | fgrep '...' >/dev/null
		then
			echo "== Making sure current branch is up to date..."
			git pull
		fi
		printf "\n== Creating worktree at ../$1\n"
		git worktree add "../$1"
	' _ "$1" && cd "../$1"
}

# Function to create a worktree from an existing branch and cd into it.
# Using `zsh -c 'script' _ $ARGS` is a way to get `set -e` working in an interactive zsh session.
worktree-branch()
{
	(( $# == 1 )) || { echo >&2 "Usage: worktree-branch BRANCH_NAME"; return 1 }
	zsh -c '
		set -e
		echo "== Making sure current branch is up to date..."
		git pull
		printf "\n== Checking out $1 branch\n"
		CURRENT_BRANCH="$(git branch --show-current)"
		[[ -n $CURRENT_BRANCH ]] || { echo >&2 "Could not determine current git branch" ; exit 1 }
		git checkout "$1" --
		git checkout "$CURRENT_BRANCH" --
		printf "\n== Creating worktree at ../$1\n"
		git worktree add "../$1" "$1"
	' _ "$1" && cd "../$1"
}

#------------------------------------------------------------------------------
# Alias definitions

# Debian (and Ubuntu) specific aliases
if [[ -f /etc/debian_version ]]
then
	alias apt='sudo apt'
	alias apt-get='sudo apt-get'
	alias apt-file='sudo apt-file'
	alias aptitude='sudo aptitude'

	alias list_all_backports="aptitude search '~Abackports ?not(~S~i~Abackports)'"
	alias list_all_experimental="aptitude search '~Aexperimental ?not(~S~i~Aexperimental)'"
	alias list_all_unstable="aptitude search '~Aunstable ?not(~S~i~Aunstable)'"

	alias list_installed_backports="aptitude search '~S~i~Abackports'"
	alias list_installed_experimental="aptitude search '~S~i~Aexperimental'"
	alias list_installed_unstable="aptitude search '~S~i~Aunstable'"

	alias list_intersect_backports="aptitude search '?and(~i,~Abackports)'"
	alias list_intersect_experimental="aptitude search '?and(~i,~Aexperimental)'"
	alias list_intersect_unstable="aptitude search '?and(~i,~Aunstable)'"
fi

# Alias commands where sudo is needed to invoke them
alias dmesg='sudo dmesg'
alias service='sudo service'
alias systemctl='sudo systemctl'

command -v atop >/dev/null && alias atop='sudo atop'
command -v ipcalc > /dev/null && alias ipcalc='ipcalc -n'
command -v aws > /dev/null && alias sso='aws sso login --profile default 2>/dev/null'
command -v wg >/dev/null && alias wg='sudo wg'

alias cal='ncal -b'
alias cls='clear;ls'
alias df='df -h -x devtmpfs -x overlay -x tmpfs'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.config/dotfiles/.git/ --work-tree=$HOME"
alias journalctl='PAGER=less journalctl'
alias ll='ls -l'
alias ls='ls -AF --color=auto'
alias more='less -EX'
alias zgrep='zgrep --binary-files=without-match --color=auto'

if command -v nvim > /dev/null
then
	alias vi=nvim
	alias view='nvim -R'
	alias vimdiff='nvim -d'
elif command -v vim > /dev/null
then
	alias vi=vim
	alias view='vim -R'
fi

if command -v kubectl > /dev/null
then
	# Extra kube aliases
	alias kd='kubectl describe'
	alias kg='kubectl get'
	for i in hpa:hpa pv:pv
	do
		_KEY="${i%:*}"
		_CMD="${i#*:}"

		alias kd$_KEY="kubectl describe $_CMD"
		alias kdel$_KEY="kubectl delete $_CMD"
		alias ke$_KEY="kubectl edit $_CMD"
		alias kg$_KEY="kubectl get $_CMD"
		alias kg${_KEY}a="kubectl get $_CMD --all-namespaces"
	done
	for i in j:job
	do
		_KEY="${i%:*}"
		_CMD="${i#*:}"

		alias kg${_KEY}a="kubectl get $_CMD --all-namespaces"
	done
	unset i _KEY _CMD
fi

[[ -r $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"
