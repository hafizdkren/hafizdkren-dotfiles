# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#SSH-GPG Automate
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
	gpgconf --launch gpg-agent

# List of aliases
	alias ls='nnn -de'
	alias lse='exa -lh --icons --inode --links --blocks --git'
	alias lsg='exa --icons --long --grid --git'
	alias lst='exa --icons --tree --level=2 -lh --inode --links --blocks --git'
	alias img='kitty +kitten icat'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hafizdkren/.zshrc'

autoload -Uz compinit promptinit
compinit -i
promptinit

zstyle ':completion:*:*:cd:*' menu yes select
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%p
zstyle ':completion:*' menu yes select
# End of lines added by compinstall

# List of source for plugins and command

#Highlight
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#Keybinds
source ~/.zsh/keybinds/keybinds.zsh

#wakatime
source ~/.zsh/wakatime-zsh-plugin/wakatime-plugin.zsh

#VScode
source ~/.zsh/vscode/vscode.zsh

#Github CLI
source ~/.zsh/github-cli/github-cli.zsh

#ZSH Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#Powerlevel10k
# To easily setting up P10K, you should build from from GH,
# Link to P10K Installations : https://github.com/romkatv/powerlevel10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
