set -gx PATH \
    ~/.bin \
    ~/.local/bin \
    ~/.krew/bin \
    ~/.cargo/bin \
    ~/.dotnet \
    ~/go/bin \
    /usr/local/opt/krb5/bin \
    /usr/local/opt/krb5/sbin \
    /usr/local/opt/coreutils/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/grep/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubin \
    /usr/local/opt/make/libexec/gnubin \
    /usr/local/opt/llvm/bin \
    /usr/local/Cellar/lsof/4.93.2/bin \
    /usr/local/opt/ncurses/bin \
    /usr/local/bin \
    /usr/local/kubebuilder/bin \
    /usr/local/opt/helm@2/bin \
    /usr/local/opt/node@12/bin \
    /usr/local/opt/ruby/bin \
    /usr/local/lib/ruby/gems/2.7.0/bin \
    /usr/local/opt/python/libexec/bin \
    /usr/local/Cellar/swift/4.2.1/Swift-4.2.1.xctoolchain/usr/bin \
    /usr/local/opt/openjdk/bin \
    /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin \
    $PATH

set -gx MANPATH \
    /usr/local/opt/coreutils/libexec/gnuman \
    $MANPATH

set -gx GOPATH "$HOME/go"

set -gx TOOLCHAINS swift
set -gx LDFLAGS "-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib -mlinker-version=450"
set -gx CPPFLAGS "-I/usr/local/opt/llvm/include -I/usr/local/opt/openjdk/include"

set -gx CC "/usr/local/opt/llvm/bin/clang -mlinker-version=450"
set -gx LLVM_CONFIG "/usr/local/opt/llvm/bin/llvm-config"

set -gx EDITOR "emacsclient -c"
set -gx K9S_EDITOR "emacsclient -c"

set -gx NO_PROXY "*.docker.internal,localhost,127.0.0.1"
set -gx no_proxy "*.docker.internal,localhost,127.0.0.1"

set -gx GPG_TTY (tty)

function git
    hub $argv
end

function update-gopls
    go install golang.org/x/tools/gopls@latest
end

function update-gopls-unstable
    # Create an empty go.mod file, only for tracking requirements.
    set currentDirectory (pwd)

    cd (mktemp -d)
    go mod init gopls-unstable

    # Use 'go get' to add requirements and to ensure they work together.
    go get -d golang.org/x/tools/gopls@master golang.org/x/tools@master

    go install golang.org/x/tools/gopls

    cd $currentDirectory
end

function garbagecollector-stats
    printf "%s%s%s%10s    %s%s%-10s\n\n" (set_color normal) (set_color green) (set_color -o) "Environment" (set_color normal) (set_color -o) "Total restarts"
    for env in qa prod
        set output (curl -ksg "https://prometheus.lol/api/v1/query?query=kube_pod_container_status_restarts_total{container=\"lol\"}" | jq -r '.data.result[].value[1]')
        printf "%s%s%10s    %s%s%-10s\n" (set_color normal) (set_color green) (string upper $env) (set_color normal) (set_color -o) $output
    end
end
