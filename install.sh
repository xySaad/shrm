git clone https://github.com/xySaad/shrm $HOME/.shrm

startup_files=(~/.bashrc ~/.bash_profile)

function add_to_shell() {
    echo \$1: $1
    echo \
    "# written by shrm
    source $HOME/.shrm/src/index.sh
    export SHRM_LOCATION=$HOME/.shrm
    " >> $1
}

if [ -n "$SHRM_LOCATION" ]; then echo "a"; fi

for file in $startup_files; do add_to_shell $file; done
