if [ ! -n "$SHRM_LOCATION" ]; then
    export SHRM_LOCATION="$HOME/.shrm"

    startup_files="$HOME/.bashrc $HOME/.bash_profile"    
    for file in $startup_files; do
        echo 'export SHRM_LOCATION="$HOME/.shrm"' >> $file;
        echo '. "$SHRM_LOCATION/index.sh"' >> $file; 
    done
fi

. "$SHRM_LOCATION/src/piscine_java.sh"