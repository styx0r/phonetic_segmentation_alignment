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

if [ ! -d "$DIR" ]; then
  mkdir $MFA_OUTPUT
fi

# run alignment
mfa align -s 4 --clean $MFA_INPUT german_mfa german_mfa $MFA_OUTPUT --use_postgres --beam 100 --retry_beam 400 --fine_tune