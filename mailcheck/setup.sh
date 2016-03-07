#!/bin/bash

if [ $# -eq 0 ]; then
    DEST="../build-mailcheck-Desktop-Default/src/"

    mkdir -p $DEST
    cp -r data/departments.json $DEST/
    cp -r data/renderer $DEST/
    cp -r data/images $DEST/
    
    echo "Setup complete."
    exit 0;
fi
