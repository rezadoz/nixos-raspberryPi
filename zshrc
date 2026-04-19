# ─────────────────────────────────────────────────────────────────────────────
# ~/.zshrc — Raspberry Pi / Raspbian Quality-of-Life Config
# ─────────────────────────────────────────────────────────────────────────────

# ── Oh My Zsh (optional — comment out if not installed) ──────────────────────
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git z sudo colored-man-pages)
# source $ZSH/oh-my-zsh.sh

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space
setopt SHARE_HISTORY          # Share history across sessions
setopt APPEND_HISTORY         # Append rather than overwrite history file
setopt EXTENDED_HISTORY       # Record timestamps in history

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                   # Arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Key Bindings ──────────────────────────────────────────────────────────────
bindkey -e                          # Emacs-style line editing
bindkey '^[[A' history-search-backward   # Up arrow → history search
bindkey '^[[B' history-search-forward    # Down arrow → history search
bindkey '^[[H' beginning-of-line         # Home key
bindkey '^[[F' end-of-line              # End key
bindkey '^[[3~' delete-char             # Delete key

# ── Options ───────────────────────────────────────────────────────────────────
setopt AUTO_CD               # Type a directory name to cd into it
setopt CORRECT               # Suggest corrections for mistyped commands
setopt GLOB_DOTS             # Include dotfiles in globbing
setopt NO_BEEP               # Silence the terminal bell
setopt INTERACTIVE_COMMENTS  # Allow # comments in interactive shell

# ── Prompt ────────────────────────────────────────────────────────────────────
autoload -Uz colors && colors
# user@host:dir (git branch) $
setopt PROMPT_SUBST
_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) && echo " %F{yellow}($branch)%f"
}
PROMPT='%F{green}%n@%m%f:%F{cyan}%~%f$(_git_branch) %F{white}$%f '

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR=nano            # Change to vim/nvim if preferred
export VISUAL=nano
export PAGER=less
export LESS='-R --quit-if-one-screen'
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ── Raspberry Pi: GPIO / Hardware ─────────────────────────────────────────────
alias pinout='pinout'                          # GPIO pinout diagram (python3-gpiozero)
alias cpuinfo='cat /proc/cpuinfo | grep -i model'
alias vcgencmd='sudo vcgencmd'
alias cputemp='vcgencmd measure_temp'          # CPU temperature
alias cpufreq='vcgencmd get_throttled'         # Throttling status (0x0 = healthy)
alias gpumem='vcgencmd get_mem gpu'            # GPU memory split
alias armmem='vcgencmd get_mem arm'            # ARM memory split

# ── System ────────────────────────────────────────────────────────────────────
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove -y'
alias search='apt search'
alias syslog='sudo journalctl -xe'
alias dmesg='sudo dmesg --color=always | less -R'
alias services='systemctl list-units --type=service --state=running'

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'           # Go back to previous directory

# ── File listing (use eza/exa if available, fallback to ls) ───────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -alF --group-directories-first --icons --git'
  alias la='eza -a --group-directories-first --icons'
  alias lt='eza --tree --icons'
elif command -v exa &>/dev/null; then
  alias ls='exa --group-directories-first'
  alias ll='exa -alF --group-directories-first --git'
  alias la='exa -a --group-directories-first'
  alias lt='exa --tree'
else
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -alFh --color=auto'
  alias la='ls -A --color=auto'
  alias lt='tree -C'        # requires: sudo apt install tree
fi

# ── File Operations ───────────────────────────────────────────────────────────
alias cp='cp -iv'           # Interactive + verbose
alias mv='mv -iv'
alias rm='rm -iv'           # Confirm before deleting
alias mkdir='mkdir -pv'     # Create parent dirs, verbose
alias df='df -h'            # Human-readable disk usage
alias du='du -h'
alias duh='du -sh *'        # Size of items in current dir
alias free='free -h'        # Human-readable RAM

# ── Networking ────────────────────────────────────────────────────────────────
alias ip='ip --color=auto'
alias myip='hostname -I | awk "{print \$1}"'           # Local IP
alias extip='curl -s https://ipinfo.io/ip'             # External IP
alias ports='ss -tulnp'                                # Open ports
alias ping='ping -c 5'                                 # Limit to 5 pings
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias wifi='nmcli device wifi list'                    # List nearby WiFi
alias wifistatus='nmcli device status'

# ── Process Management ────────────────────────────────────────────────────────
alias psg='ps aux | grep -v grep | grep'   # e.g. psg python
alias top='htop'                           # requires: sudo apt install htop
alias topu='top -u $USER'
alias killall='killall -v'
alias memhogs='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -15'
alias cpuhogs='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -15'

# ── Git ───────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ── Python / pip ──────────────────────────────────────────────────────────────
alias python='python3'
alias pip='pip3'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias activate='source venv/bin/activate'
alias serve='python3 -m http.server 8080'  # Quick local HTTP server

# ── Productivity ──────────────────────────────────────────────────────────────
alias c='clear'
alias h='history | tail -40'
alias hg='history | grep'    # e.g. hg docker
alias path='echo $PATH | tr ":" "\n"'
alias reload='source ~/.zshrc && echo "✓ .zshrc reloaded"'
alias zshrc='$EDITOR ~/.zshrc'
alias cls='clear && ls'

# ── Misc / Fun ────────────────────────────────────────────────────────────────
alias weather='curl wttr.in'                           # Requires internet
alias cal='cal -3'                                     # Show 3-month calendar
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'
alias week='date +"%V"'                                # ISO week number

# ── Functions ─────────────────────────────────────────────────────────────────

# Extract any archive type
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"    ;;
      *.tar.gz)   tar xzf "$1"    ;;
      *.tar.xz)   tar xJf "$1"    ;;
      *.bz2)      bunzip2 "$1"    ;;
      *.rar)      unrar x "$1"    ;;
      *.gz)       gunzip "$1"     ;;
      *.tar)      tar xf "$1"     ;;
      *.tbz2)     tar xjf "$1"    ;;
      *.tgz)      tar xzf "$1"    ;;
      *.zip)      unzip "$1"      ;;
      *.Z)        uncompress "$1" ;;
      *.7z)       7z x "$1"       ;;
      *)          echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Find a file by name in current tree
ff() { find . -name "*$1*" 2>/dev/null; }

# Show disk usage of a path, sorted
dus() { du -sh "${1:-.}"/* 2>/dev/null | sort -rh | head -20; }

# Quick backup of a file (copies with .bak suffix)
bak() { cp -v "$1" "${1}.bak"; }

# Watch CPU temp every 2 seconds
watchtemp() { watch -n 2 'vcgencmd measure_temp'; }

# Service shortcuts
svc() {
  case "$1" in
    start|stop|restart|status|enable|disable)
      sudo systemctl "$1" "$2" ;;
    *)
      echo "Usage: svc [start|stop|restart|status|enable|disable] <service>" ;;
  esac
}

# ─────────────────────────────────────────────────────────────────────────────
# End of .zshrc
# ─────────────────────────────────────────────────────────────────────────────
