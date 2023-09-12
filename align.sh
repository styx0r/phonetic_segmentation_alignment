#!/bin/bash

# install dictionary in case it's not already
if [[ `mfa model list dictionary` == *german_mfa* ]]; then
    echo "dictionary german_mfa already installed ... continue"
else
    echo "installing german_mfa dictionary"
    mfa model download dictionary german_mfa
fi

# install acoustic in case it's not already
if [[ `mfa model list acoustic` == *german_mfa* ]]; then
    echo "acoustic german_mfa already installed ... continue"
else
    echo "installing german_mfa acoustic"
    mfa model download acoustic german_mfa
fi

# run alignment
mfa align -s 4 --clean $MFA_INPUT german_mfa german_mfa $MFA_OUTPUT --beam 1000