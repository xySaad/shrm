if [ ! -n "$SHRM_LOCATION" ]; then
    SHRM_LOCATION="$HOME/.shrm"
fi

if [ -d "$SHRM_LOCATION" ]; then
    echo "shrm already installed at $SHRM_LOCATION.";
    printf "Do you want to update it? [y/N]: ";
    read ans </dev/tty

    if echo "$ans" | grep -Eiq '^(y|yes)$'; then
        echo "Updating..."
        git -C "$SHRM_LOCATION" pull
    else
        echo "Skipping update."
        exit 0;
    fi
        
else 
    git clone https://github.com/xySaad/shrm $SHRM_LOCATION
fi

if [ ! -n "$SHRM_LOCATION"]; then
    startup_files="$HOME/.bashrc $HOME/.bash_profile"    
    for file in $startup_files; do
        echo '. "$SHRM_LOCATION/index.sh"' >> $file; 
    done
fi

echo
echo "Installation complete!"
echo "Run the following command to apply changes now:"
echo '  . "$HOME/.shrm/src/index.sh"'