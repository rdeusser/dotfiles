export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fish"

plugins=(
    aliases
    brew
    bun
    colored-man-pages
    colorize
    common-aliases
    docker
    emacs
    fzf
    fzf-tab
    git
    gitignore
    gnu-utils
    golang
    kubectl
    per-directory-history
    ssh
    ssh-agent
    systemadmin
    zsh-autosuggestions
    zsh-switchenv
    zsh-syntax-highlighting
)

# Core
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.config"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:/usr/share/man:${MANPATH}"
export EDITOR="vim"
export NO_PROXY="*.docker.internal,localhost,127.0.0.1"
export no_proxy="*.docker.internal,localhost,127.0.0.1"
export GPG_TTY="$(tty)"

export ME="$(whoami)"
export SSL_CERT_FILE="/etc/ssl/cert.pem"
export REQUESTS_CA_BUNDLE="/etc/ssl/cert.pem"

# SSH
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities id_ed25519 personal
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# Colorize
ZSH_COLORIZE_TOOL="chroma"
ZSH_COLORIZE_STYLE="emacs"
ZSH_COLORIZE_CHROMA_FORMATTER="terminal256"

alias cat="colorize_cat"
alias less="colorize_less"

# switchenv
[ -f ~/.switchenv ] && . ~/.switchenv

# fzf
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Bat
export BAT_THEME="gruvbox-dark"

# k9s
export K9S_EDITOR="vim"

# Go
export GOPATH="$HOME/go"
export GOTOOLCHAIN="local"

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"

# Node
export VOLTA_HOME="$HOME/.volta"

# Git
alias git="hub"

# zoxide
eval "$(zoxide init zsh)"

switchcompiler() {
    local mode=$1

    if [[ "$mode" == "homebrew" ]]; then
        # Homebrew LLVM configuration
        export CC="/opt/homebrew/opt/llvm/bin/clang"
        export CXX="/opt/homebrew/opt/llvm/bin/clang++"
        export LLVM_CONFIG="/opt/homebrew/opt/llvm/bin/llvm-config"

        # Include and library paths
        export C_INCLUDE_PATH="/opt/homebrew/include:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/include/c++/v1"
        export LD_LIBRARY_PATH="/opt/homebrew/lib:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/lib:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/lib/c++"
        export LIBRARY_PATH="/opt/homebrew/lib:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/lib:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/lib/c++"
        export CPATH="/opt/homebrew/include:$(/opt/homebrew/opt/llvm/bin/llvm-config --prefix)/include/c++/v1"

        # Flags
        export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
        export CFLAGS="-I/opt/homebrew/include $(/opt/homebrew/opt/llvm/bin/llvm-config --cflags)"
        export CPPFLAGS="-I/opt/homebrew/include $(/opt/homebrew/opt/llvm/bin/llvm-config --cppflags)"
        export CXXFLAGS="-I/opt/homebrew/include $(/opt/homebrew/opt/llvm/bin/llvm-config --cxxflags)"

        echo "Switched to Homebrew LLVM configuration"

    elif [[ "$mode" == "xcode" ]]; then
        # Xcode/System configuration
        export CC="/Library/Developer/CommandLineTools/usr/bin/clang"
        export CXX="/Library/Developer/CommandLineTools/usr/bin/clang++"
        export LLVM_CONFIG="xcrun --find llvm-config"

        # SDK path
        export SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"

        # Include and library paths - added C++ paths
        export C_INCLUDE_PATH="${SDKROOT}/usr/include:${SDKROOT}/usr/include/c++/v1"
        export CPLUS_INCLUDE_PATH="${SDKROOT}/usr/include/c++/v1"
        export LD_LIBRARY_PATH="${SDKROOT}/usr/lib:${SDKROOT}/usr/lib"
        export LIBRARY_PATH="${SDKROOT}/usr/lib:${SDKROOT}/usr/lib"
        export CPATH="${SDKROOT}/usr/include:${SDKROOT}/usr/include/c++/v1"

        # Flags - updated to include C++ paths
        export LDFLAGS="-L${SDKROOT}/usr/lib -L${SDKROOT}/usr/lib"
        export CFLAGS="-I${SDKROOT}/usr/include -I${SDKROOT}/usr/include/c++/v1"
        export CPPFLAGS="-I${SDKROOT}/usr/include -I${SDKROOT}/usr/include/c++/v1"
        export CXXFLAGS="-stdlib=libc++ -I${SDKROOT}/usr/include/c++/v1"

        echo "Switched to Xcode/System configuration"

    else
        echo "Usage: switchcompiler [homebrew|xcode]"
        return 1
    fi
}

path=(
    ~/.bin
    ~/.local/bin
    ~/.bun/bin
    ~/.krew/bin
    ~/.cargo/bin
    ~/.dotnet
    ~/.rahu/toolchains/tcc/bin
    ~/.pub-cache/bin
    ~/.sg
    ~/.volta/bin
    ~/.kube/current
    ~/scripts
    $GOPATH/bin
    $GOROOT/bin
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /opt/homebrew/opt/protobuf@3/bin
    /opt/homebrew/opt/llvm/bin
    /opt/homebrew/opt/grep/libexec/gnubin
    /opt/homebrew/opt/coreutils/libexec/gnubin
    /opt/homebrew/opt/gnu-sed/libexec/gnubin
    /opt/homebrew/opt/gnu-tar/libexec/gnubin
    /opt/homebrew/opt/gnu-indent/libexec/gnubin
    /opt/homebrew/opt/libtool/libexec/gnubin
    /opt/homebrew/opt/expat/bin
    /opt/homebrew/opt/libiconv/bin
    /opt/homebrew/opt/file-formula/bin
    /opt/homebrew/opt/curl/bin
    /opt/homebrew/Cellar/ruby/3.2.2_1/bin
    /Applications/Emacs.app/Contents/MacOS/bin
    ${HOME}/Library/Python/3.12/bin
    ${HOME}/Library/Python/3.11/bin
    ${HOME}/Library/Python/3.10/bin
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
    /Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/bin
    /usr/local/bin
    /usr/bin
    /bin
)

. "$HOME/.cargo/env"

PROMPT_EOL_MARK=""

export PATH

. $ZSH/oh-my-zsh.sh

autoload -Uz compinit && compinit
