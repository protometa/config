set -U fish_greeting

# homebrew path
test -x /opt/homebrew/bin/brew # Apple Silicon install location
and eval "$(/opt/homebrew/bin/brew shellenv)"
test -x /usr/local/bin/brew # Intel install location
and eval "$(/usr/local/bin/brew shellenv)"

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x EDITOR hx

    which -s kubectl
    and kubectl completion fish | source

    set -x JAVA_HOME "/Users/LNimtz/Library/Caches/Coursier/arc/https/github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_mac_hotspot_8u292b10.tar.gz/jdk8u292-b10/Contents/Home"
end
