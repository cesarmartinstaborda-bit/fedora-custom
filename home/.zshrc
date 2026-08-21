# Minimal macOS-inspired interactive Zsh setup, installed 2026-08-19.
export LANG="${LANG:-pt_BR.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-pt_BR.UTF-8}"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history share_history hist_ignore_dups hist_reduce_blanks
setopt auto_cd interactive_comments prompt_subst

autoload -Uz compinit vcs_info
compinit -d "$HOME/.cache/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

zstyle ':vcs_info:git:*' formats ' %F{244}(%b)%f'
precmd() { vcs_info }
PROMPT='%F{250}%n@%m%f %F{252}%1~%f${vcs_info_msg_0_} %# '

bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

alias ls='eza --color=auto --group-directories-first'
alias ll='eza -lah --git --group-directories-first'
alias la='eza -a --group-directories-first'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'

eval "$(zoxide init zsh)"
if [[ -o interactive && -t 0 && -r /usr/share/fzf/shell/key-bindings.zsh ]]; then
  source /usr/share/fzf/shell/key-bindings.zsh
fi
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# OSC 7 keeps Ptyxis tabs and new shells in the current directory.
precmd_functions+=(macos_ptyxis_title)
macos_ptyxis_title() {
  print -Pn '\e]7;file://%m%~\a'
  print -Pn '\e]0;%n@%m — %~\a'
}
export PATH="$HOME/.codex/packages/standalone/releases/0.148.0-x86_64-unknown-linux-musl/bin:$PATH"
