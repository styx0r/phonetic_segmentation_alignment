# Phonetic Segmentation Alignment

This repository provides tools and scripts for phonetic segmentation, alignment and concatenation.

## Features

- Docker support for easy setup and deployment.
- Integration with the Montreal Forced Aligner (MFA).
- Utility scripts for data processing (`concat.py` and `split.py`).

## Prerequisites

- Docker
- Docker Compose

## Setup and Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/styx0r/phonetic_segmentation_alignment.git
   cd phonetic_segmentation_alignment

2. **(Optional) Build the Docker Image**
   ```bash
   docker-compose build

3. **Run the application**
   ```bash
   ./run.sh
   ```
   The docker environment is started and the pipeline (split, align and concatenate) is running. You can optionally run it as often as you wish, e.g. if you
   provide different sets of input files. The docker environment is started just once and after the first run, the consecutive runs will take less time.

4. **Shutting down the application
   ```bash
   docker-compose down
   ```
   After finishing the analysis, you can run docker-compose down to shut down the docker containers.

## Data Provision

Raw data folder should be provided in the ENV var `RAW_DATA_FOLDER` in `docker-compose.yml`. It defaults to
`data/raw`. The output folders can be defined also in the
`docker-compose.yml`. For each raw wav file a corresponding
TextGrid file should be provided with the same name.
In the TextGrid file the words and corresponding intervals
are defined in the `utterance` tier.

