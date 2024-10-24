###############################################################################
# zsh config
###############################################################################

# export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu

! [ -d ~/.config/shellz ] && mkdir -p ~/.config/shellz

# put this nix hack in so that in macos
# nix intalled zulu java hits the path
# before the native macos java
# export PATH=/etc/profiles/per-user/$USER/bin:$PATH
export PATH=/usr/local/opt/openjdk/bin:$PATH
export PATH=~/bin:$PATH

function load_shellz_mod() {
	[ -d ~/.config/shellz/"$1" ] && source ~/.config/shellz/$1/main.sh
}

declare -a shellz_mods=(
	direnv
	path
	xdg
	nix
	tmux
	zstyle
	completions
	ssh_agent
)

for m in "${shellz_mods[@]}"; do
	load_shellz_mod $m
done

# load gh token from sops-nix location if exists
# [ -e ~/.config/gh/env/GH_TOKEN ] &&
# 	export GH_TOKEN=$(cat ~/.config/gh/env/GH_TOKEN)

# some aliases
alias grep=rg
alias cat=bat
alias cd=z

# integrate zoxide
eval "$(zoxide init zsh)"
#
###############################################################################
# android
###############################################################################

export ANDROID_HOME=~/Android/Sdk
export ANDROID_STUDIO=/opt/android-studio
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_STUDIO/bin
export PATH=$PATH:/bin
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
# export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

###############################################################################
# shellhooks
###############################################################################

[ -d ~/.config/shellz/hooks ] && mkdir -p ~/.config/shellz/hooks
[ -f ~/.config/shellz/hooks/main.sh ] && source ~/.config/shellz/hooks/main.sh

# end zsh config
#
# export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/root/perl5";
# export PERL_MB_OPT="--install_base /root/perl5"
# export PERL_MM_OPT="INSTALL_BASE=/root/perl5"
export PERL5LIB="/usr/share/perl/5.34.0/:$PERL5LIB"
export PATH="$PERL5LIB/bin:$PATH"
export C_INCLUDE_PATH=/usr/include:$C_INCLUDE_PATH
export CPATH=$CPATH:/usr/include

# load these before anything in nix
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export PATH=~/.nix-profile/bin:$PATH

# help cargo find libiconv
export PATH="/usr/local/opt/libiconv/bin:$PATH"

# PATH up rbenv at the end
# [ -d ~/.rbenv/bin ] && eval "$(~/.rbenv/bin/rbenv init - zsh)"

# load NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# load YVM
# export YVM_DIR=/usr/local/opt/yvm
# [ -r "$YVM_DIR/yvm.sh" ] && . "$YVM_DIR/yvm.sh"

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH

# set EDITOR
export EDITOR=nvim

# set gpg-agent stuff
export GPG_TTY
GPG_TTY=$(tty)

export AWS_PROFILE=pinger-organization
if [[ "$(uname)" == "Darwin" ]]; then
	export LIBRARY_PATH="/usr/local/opt/libiconv/lib"
	export CPATH="/usr/local/opt/libiconv/include"
	export SDKROOT
	SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
	export CGO_CFLAGS
	CGO_CFLAGS="-isysroot $(xcrun --sdk macosx --show-sdk-path)"
	export CGO_LDFLAGS
	CGO_LDFLAGS="-isysroot $(xcrun --sdk macosx --show-sdk-path)"
fi
