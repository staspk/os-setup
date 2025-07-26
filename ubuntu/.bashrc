if [ -f ~/.bash_aliases ];          then . ~/.bash_aliases;           fi
if [ -f ~/.bash/.bash_print ];      then . ~/.bash/.bash_print;       fi
if [ -f ~/.bash/.bash_os ];         then . ~/.bash/.bash_os;          fi
if [ -f ~/.bash/.bash_python ];     then . ~/.bash/.bash_python;      fi
if [ -f ~/.bash/.bash_runtime ];    then . ~/.bash/.bash_runtime;     fi


setup_ubuntu() {
    cp -r "$HOME/os-setup/ubuntu/boilerplate" "$HOME/boilerplate"
    
    sudo apt update
    sudo apt install -y git
    git config --global user.name "Stanislav Kozubenko"
    git config --global user.email "staspk@gmail.com"
}

setup_python() {
    sudo apt install -y python3-pip
    sudo apt install -y python3-venv
}


# (do not change the next line):
# -------------------------------------------------------------------------