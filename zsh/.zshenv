# Setup Environment
	export BROWSER="firefox"
	export EDITOR='nvim'
	export VISUAL='nvim'
	export DIFFPROG='nvim -d'
    fastfetch && octofetch hafizdkren

# Adding XDG and Bin
#XDG
	[[ -z "$XDG_CACHE_HOME" ]]  && export XDG_CACHE_HOME="$HOME"/.cache
	[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME"/.config
	[[ -z "$XDG_DATA_HOME" ]]   && export XDG_DATA_HOME="$HOME"/.local/share

#Bin
	path=(
	  /usr/local/{bin,sbin}
	  $path
	)

# Adding Git Subrepo onto zsh so it also adding Git Subrepo command to zsh.
	fpath=('/opt/git-subrepo/share/zsh-completion' $fpath)

	export GIT_SUBREPO_ROOT="/opt/git-subrepo"
	export PATH="/opt/git-subrepo/lib:$PATH"
	export MANPATH="/opt/git-subrepo/man:$MANPATH"

# Adding Rust
	export RUSTUP_HOME=$XDG_DATA_HOME/rustup
	export CARGO_HOME=$XDG_DATA_HOME/cargo
	export PATH=$XDG_DATA_HOME/cargo/bin:$PATH

# Adding "nnn" for file manager on terminal
## -Adding "nnn"
#	export NNN_FIFO=/tmp/nnn.fifo nnn
	export NNN_COLORS='2581'
	export NNN_TRASH=1
	export NNN_USE_EDITOR=1
	export NNN_COPIER="$XDG_CONFIG_HOME/nnn/copier"
	export NNN_PLUG='f:finder;o:fzopen;p:ipinfo;d:diffs;t:nmount;v:!kitty +kitten icat $nnn;c:tooglex'

# Adding Ripgrep to finding keyword fast
	export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# Adding "exa"
	export env COLUMNS='100' 
	export EXA_COLORS= "lp=34:da=37:uu=33:sn=35:sb=35"

#SASS
	export PATH=$PATH:$HOME/.sass/dart-sass
