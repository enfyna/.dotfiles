#    ____            _            _    _ _                     
#   | __ )  __ _ ___| |__        / \  | (_) __ _ ___  ___  ___ 
#   |  _ \ / _` / __| '_ \      / _ \ | | |/ _` / __|/ _ \/ __|
#  _| |_) | (_| \__ \ | | |    / ___ \| | | (_| \__ \  __/\__ \
# (_)____/ \__,_|___/_| |_|___/_/   \_\_|_|\__,_|___/\___||___/
#                        |_____|                               

alias con='connmanctl'

alias ll='ls -Shlac --group-directories-first'

alias n='nvim .'
alias ng='nvim . --listen 127.0.0.1:55432' # godot lsp

alias t='tree -L 1 -C -a --dirsfirst'
alias tree='tree --dirsfirst -a -C'

alias kitty='sh -c "kitty --start-as fullscreen --override background_image_layout=cscaled --override background_image=\$(find /usr/share/wallpapers/kitty -type f -name '*.png' | shuf -n 1)"'

alias cdg='cd ~/Documents/GitHub'
alias cdd='cd ~/Documents/Dersler'
alias cdt='cd ~/Documents/Test'

alias scrcpy='scrcpy --turn-screen-off'
