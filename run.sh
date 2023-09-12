#!/bin/sh

# start docker-compose services
docker-compose up -d

# split all input wav and TextGrid files
docker exec phonetic_segmentation_alignment /bin/bash -c "poetry run split_input_files"

# running alignment
docker exec mfa /bin/bash -c "bash ~/mfa.sh"


# Cleanup Notification
echo If you are finished with your analysis, please run docker-compose down.
