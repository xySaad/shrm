
if [ -n "$SHRM_LOCATION" ]; then
    echo "shrm scripts already exists at $SHRM_LOCATION";
    exit 0;
fi

export SHRM_LOCATION=$HOME/.shrm

if [ -d "$SHRM_LOCATION" ]; then
    echo "shrm already installed at $SHRM_LOCATION.";
    printf "Do you want to update it? [y/N]: ";
    read ans </dev/tty

    if echo "$ans" | grep -Eiq '^(y|yes)$'; then
        echo "Updating..."
        git -C "$SHRM_LOCATION" pull
    else
        echo "Skipping update."
        return 0;
    fi
        
else 
    git clone https://github.com/xySaad/shrm $SHRM_LOCATION
fi

startup_files="$HOME/.bashrc $HOME/.bash_profile"

add_to_shell() {
    echo \
    "# written by shrm
    . $SHRM_LOCATION/src/index.sh
    " >> $1;
}

for file in $startup_files; do add_to_shell $file; done

. $SHRM_LOCATION/src/index.sh
