#!/bin/sh

# start docker-compose services
docker-compose up -d

sleep 5

# split all input wav and TextGrid files
docker exec phonetic_segmentation_alignment /bin/bash -c "bash /home/app/split.sh"

# remove all files which are not valid:
find ./data/mfa_input/ -maxdepth 1 -name '*\?*' -print0 | xargs -0 rm -f

# copying custom dictionary to docker environment
docker cp ./data/dict/diss_german_mfa.dict mfa:/home/mfauser/german_mfa.dict

# running alignment
docker exec mfa /bin/bash -c "bash ~/align.sh"

# concat final results word wise
docker exec phonetic_segmentation_alignment /bin/bash -c "poetry run concat_mfa_files"

# Cleanup Notification
echo If you are finished with your analysis, please run docker-compose down.
