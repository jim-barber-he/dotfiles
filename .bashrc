# ~/.bashrc: executed by bash(1) for non-login shells.

# shellcheck disable=SC1090,SC1091,SC2148

# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# Add the sbin directories to PATH.
PATH="$PATH:/usr/sbin:/sbin"

# Path additions.
[[ -d /usr/local/go ]] && PATH="/usr/local/go/bin:$PATH"
[[ -d $HOME/go/bin ]] && PATH="$HOME/go/bin:$PATH"
[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"

# Configure history settings.
shopt -s histappend
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in.
[[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]] && debian_chroot="$(cat /etc/debian_chroot)"

# Set parameters based on terminal
case "$TERM" in
	*-256color|cygwin|xterm*)
		color_prompt=bold_red
		set_win_title=yes
		;;
	screen)
		color_prompt=green
		stty erase ^?
		;;
esac

# Use starship (https://github.com/starship/starship) to manage the prompt if it is installed.                                      
# Install starship like so as root:                                                                                                 
#    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
if command -v starship > /dev/null
then
	if [[ $set_win_title = "yes" ]]
	then
		# shellcheck disable=SC2317
		set_win_title() { echo -ne "\\e]0;$USER@$HOSTNAME: ${PWD/#\/home\/$USER/\~}\\a"; }
		# shellcheck disable=SC2034
		starship_precmd_user_func="set_win_title"
	fi
	eval "$(starship init bash)"
else
	# Set the prompt prefix.
	# shellcheck disable=SC2016
	PS1_PREFIX='${debian_chroot:+($debian_chroot)}'
	case "$color_prompt" in
		bold_red)	PS1_PREFIX="$PS1_PREFIX"'\[\e[01;31m\]\u@\h\[\e[m\]:\[\e[01;34m\]\w\[\e[01;33m\]' ;;
		green)		PS1_PREFIX="$PS1_PREFIX"'\[\e[32m\]\u@\h\[\e[m\]:\[\e[01;34m\]\w\[\e[01;33m\]' ;;
		*)		PS1_PREFIX="$PS1_PREFIX"'\u@\h:\w'
	esac

	# Set the window title
	[[ $set_win_title = yes ]] && PS1_PREFIX="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1_PREFIX"

	# Define the prompt suffix and the prompt.
	case "$color_prompt" in
		bold_red|green) PS1_SUFFIX='\[\e[01;34m\]\$\[\e[m\] ' ;;
		*) PS1_SUFFIX='\$ '
	esac
	unset color_prompt
	PS1="$PS1_PREFIX$PS1_SUFFIX"

	# Override the prompt if kube-ps1.sh is installed:
	if [[ -f /usr/local/bin/kube-ps1.sh ]]
	then
		export KUBE_PS1_CTX_COLOR=cyan
		export KUBE_PS1_SEPARATOR=''
		# shellcheck disable=SC2016
		PS1_PREFIX="$PS1_PREFIX"'$(kube_ps1)'
		# Need to do this after git-prompt.sh for some reason...
		#. /usr/local/bin/kube-ps1.sh
	fi

	# Override the prompt if posh-git-sh is installed:
	if [[ -f /usr/local/bin/git-prompt.sh ]] && [[ -x /usr/bin/git ]]
	then
		source /usr/local/bin/git-prompt.sh
		PROMPT_COMMAND="__posh_git_ps1 '$PS1_PREFIX' '$PS1_SUFFIX'"
	fi

	# I don't know why, but I need to source this here after the git-prompt stuff.
	[[ -f /usr/local/bin/kube-ps1.sh ]] && . /usr/local/bin/kube-ps1.sh
fi
unset set_win_title

# Export the screen dimensions.
export COLUMNS LINES

if [[ -d $HOME/.aws ]]
then
	# Set AWS profile.
	export AWS_DEFAULT_PROFILE=${AWS_DEFAULT_PROFILE:-$AWS_PROFILE}
	export AWS_PROFILE=${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}
	[[ -n $AWS_DEFAULT_PROFILE ]] || unset AWS_DEFAULT_PROFILE
	[[ -n $AWS_PROFILE ]] || unset AWS_PROFILE

	# Set AWS region.
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
EDITOR=$(command -v nvim || command -v vim || echo vi)
export EDITOR

# Coloured GCC warnings and errors
command -v gcc > /dev/null && export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Allow GPG to prompt for my password when I sign commits.
GPG_TTY="$(tty)"
export GPG_TTY

# If `bat` is installed syntax highlight manpages.
command -v batcat > /dev/null \
	&& export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | batcat -p -l man --paging=always'" \
	&& export MANROFFOPT="-c"

# Set MANPATH so it includes user's private man pages
[[ -d ~/man ]] && export MANPATH="$HOME/man:${MANPATH:-$(manpath)}"

# Use less as a pager.
command -v less >/dev/null && export PAGER="less -EX"

# Define a custom output format for the ps command
#export PS_FORMAT="user:19,pid,ppid,%cpu,%mem,rss,vsz,ni,nlwp,psr,stime,tname,time,cmd"
export PS_FORMAT="user:19,pid,ppid,stime,tname,time,cmd"

# By default journalctl uses less as the PAGER with the FRSXMK options.
# Remove the S so that lines wrap.
# Also because I set PAGER='less -EX', the E option is in effect, so I have aliased journalctl to use PAGER=less with no options.
export SYSTEMD_LESS=FRXMK

# Debian (and Ubuntu) specific aliases
if [[ -f /etc/debian_version ]]
then
	alias apt="sudo apt"
	alias apt-get="sudo apt-get"
	alias apt-file="sudo apt-file"
	alias aptitude="sudo aptitude"

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
command -v aws > /dev/null && alias sso='aws sso login 2>/dev/null'
command -v wg >/dev/null && alias wg='sudo wg'

# Alias definitions
alias cal='ncal -b'
alias cls="clear;ls"
alias df='df -h -x devtmpfs -x overlay -x tmpfs'
# shellcheck disable=SC2139
alias dotfiles="/usr/bin/git --git-dir=$HOME/.config/dotfiles/.git/ --work-tree=$HOME"
alias fgrep="fgrep --binary-files=without-match --color=auto --directories=skip"
alias grep="grep --binary-files=without-match --color=auto --directories=skip"
alias journalctl='PAGER=less journalctl'
alias ll="ls -l"
alias ls="ls -AF --color=auto"
alias more="less -EX"
alias zgrep="zgrep --binary-files=without-match --color=auto"

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

# Additional aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

[[ -d /usr/lib/python3/dist-packages/yapf ]] && alias yapf='python3 /usr/lib/python3/dist-packages/yapf'

# Customise ls colours
if [[ -x /usr/bin/dircolors ]]
then
	if [[ -r ~/.dircolors ]]
	then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
fi

ltr()
{
	# shellcheck disable=SC2010
	ls -ltr --time-style=long-iso "$@" | grep " $(date --rfc-3339=date) "
}

# Enable programmable completion features
# (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	fi
fi

command -v aws_completer &>/dev/null && complete -C "$(command -v aws_completer)" aws

command -v eksctl >/dev/null && source <(eksctl completion bash)
command -v gh >/dev/null && source <(gh completion -s bash)
command -v helm >/dev/null && source <(helm completion bash)
command -v kops >/dev/null && source <(kops completion bash)
command -v stern >/dev/null && source <(stern --completion bash)

if command -v kubectl >/dev/null
then
	source <(kubectl completion bash)

	# Alias kubectl and also allow command line completion to work for the alias.
	alias k=kubectl
	if [[ $(type -t compopt) = "builtin" ]]; then
		complete -o default -F __start_kubectl k
	else
		complete -o default -o nospace -F __start_kubectl k
	fi
fi
