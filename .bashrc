#  /\/|  ___               _              
# |/\/  / / |__   __ _ ___| |__  _ __ ___ 
#      / /| '_ \ / _` / __| '_ \| '__/ __|
#     / /_| |_) | (_| \__ \ | | | | | (__ 
#    /_/(_)_.__/ \__,_|___/_| |_|_|  \___|
#                                         

. ~/.bash_aliases

setxkbmap -option caps:swapescape
stty -ixon #disable ctrl-s and ctrl-q in terminal
shopt -s autocd #cd yazmadan klasöre gir
shopt -s no_empty_cmd_completion #bos satırda tab çalıştırma

unset HISTSIZE 
unset HISTFILESIZE
HISTCONTROL=erasedups


#     _            _             _ _       _     ____ ___ _____ _     
#    / \   _ __ __| |_   _ _ __ (_) | ___ | |_  / ___|_ _|_   _| |    
#   / _ \ | '__/ _` | | | | '_ \| | |/ _ \| __| \___ \| |  | | | |    
#  / ___ \| | | (_| | |_| | |_) | | | (_) | |_   ___) | |  | | | |___ 
# /_/   \_\_|  \__,_|\__,_| .__/|_|_|\___/ \__| |____/___| |_| |_____|
#                         |_|                                         
# 

export PATH="$PATH:$HOME/Documents/GitHub/ardupilot/Tools/autotest"
export PATH="/usr/lib/ccache:$PATH"
export PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin:$PATH


#        _ _   
#   __ _(_) |_ 
#  / _` | | __|
# | (_| | | |_ 
#  \__, |_|\__|
#  |___/       

. /usr/share/git/completion/git-completion.bash


#  ____  ____  _ 
# |  _ \/ ___|/ |
# | |_) \___ \| |
# |  __/ ___) | |
# |_|   |____/|_|
#                

if [ "$EUID" -ne 0 ]
    # user
    then export PS1='\[\e[37m\]C:\w\n> \[\e[0m\]'

    # root 
    else export PS1='\[\e[1m\e[37m\][\A]\[\e[32m\][\!]\[\e[37m\]:[\[\e[34m\]\w\[\e[37m\]]\[\e[31m\e[1m\]\n> \[\e[0m\]'
fi


#  __  __ ____        ____   ___  ____    ____                            _   
# |  \/  / ___|      |  _ \ / _ \/ ___|  |  _ \ _ __ ___  _ __ ___  _ __ | |_ 
# | |\/| \___ \ _____| | | | | | \___ \  | |_) | '__/ _ \| '_ ` _ \| '_ \| __|
# | |  | |___) |_____| |_| | |_| |___) | |  __/| | | (_) | | | | | | |_) | |_ 
# |_|  |_|____/      |____/ \___/|____/  |_|   |_|  \___/|_| |_| |_| .__/ \__|
#                                                                  |_|        

ver=$( uname -r | cut -c1-5 )

echo 
echo
echo "Microsoft® Windows 95 [Version $ver]"
echo "   © Copyright Microsoft Corp 1981-1996."
echo
echo

