#!/bin/bash

# install acoustic in case it's not already
if [[ `mfa model list acoustic` == *german_mfa* ]]; then
    echo "acoustic german_mfa already installed ... continue"
else
    echo "installing german_mfa acoustic"
    mfa model download acoustic german_mfa
fi

# not needed as we use our own individual dictionary from ~/german_mfa.dict
# # install dictionary in case it's not already
# if [[ `mfa model list dictionary` == *german_mfa* ]]; then
#     echo "dictionary german_mfa already installed ... continue"
# else
#     echo "installing german_mfa dictionary"
#     mfa model download dictionary german_mfa
# fi
cp /home/mfauser/german_mfa.dict /mfa/pretrained_models/dictionary/german_mfa.dict

if [ ! -d "$MFA_OUTPUT" ]; then
  mkdir $MFA_OUTPUT
fi

# init and start database server
mfa server init && mfa server start

# # Loop through all subdirectories
# for word_dir in "$MFA_INPUT"/*/ ; do
#   echo "Starting with string: "$word_dir
#   # run alignment
#   mfa align -s 3 --clean $word_dir german_mfa german_mfa $MFA_OUTPUT --use_postgres --beam 100 --retry_beam 400 --fine_tune
# done

mfa align -s 3 --clean $MFA_INPUT german_mfa german_mfa $MFA_OUTPUT --use_postgres --beam 100 --retry_beam 400 --fine_tune
