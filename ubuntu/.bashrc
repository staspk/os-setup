if [ -f ~/.bash_aliases ];          then . ~/.bash_aliases;           fi
if [ -f ~/.bash/.bash_print ];      then . ~/.bash/.bash_print;       fi
if [ -f ~/.bash/.bash_python ];     then . ~/.bash/.bash_python;      fi
if [ -f ~/.bash/.bash_runtime ];    then . ~/.bash/.bash_runtime;     fi


setup_ubuntu() {
    cp -r "$HOME/OS-Setup/Ubuntu/boilerplate" "$HOME/boilerplate"

    sudo apt update -y
    sudo apt install -y python3-pip
    sudo apt install -y python3-venv
}


# (do not change the next line):
# -------------------------------------------------------------------------