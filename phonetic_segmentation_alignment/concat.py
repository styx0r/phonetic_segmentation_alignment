import os

import tgt
from tgt import Interval

from pathlib import Path
from pydub import AudioSegment
from copy import deepcopy

FOLDER_MFA_OUTPUT = os.getenv('FOLDER_MFA_OUTPUT', 'data/mfa_output')
FOLDER_SPLIT_WAV = os.getenv('FOLDER_SPLIT_WAV', 'data/mfa_input')

FOLDER_FINAL = os.getenv('FOLDER_FINAL', 'data/final')

def concat():
    textgrid_files = {}
    for file_mfa_output in sorted(os.listdir(FOLDER_MFA_OUTPUT)):

        stem = Path(file_mfa_output).stem
        file_tg = os.path.join(FOLDER_MFA_OUTPUT, stem + '.TextGrid')
        file_wav = os.path.join(FOLDER_SPLIT_WAV, stem + '.wav')

        # skip if is not a valid wav file
        if not os.path.isfile(file_tg) or not os.path.isfile(file_wav): continue

        word = ((Path(file_tg).stem).split('_')[3])
        if textgrid_files.get(word) is None:
            textgrid_files[word] = []
        textgrid_files[word].append(file_tg)

    # next we go through all files and concatenate the wav files and TextGrid-Files
    for word, tg_files in textgrid_files.items():
        concatenated_wav = AudioSegment.empty()
        concatenated_tg = tgt.TextGrid()

        current_time_offset = 0.0  # This will keep track of the total duration of concatenated audio

        for tg_file in tg_files:

            file_tg = tgt.read_textgrid(tg_file)
            tier_origin = deepcopy(file_tg.tiers[0])
            tier_origin.name='origin'
            tier_origin.intervals[0] = Interval(tier_origin.start_time, tier_origin.end_time, Path(tg_file).stem)
            file_tg.add_tier(tier_origin)


            file_wav = os.path.join(FOLDER_SPLIT_WAV, Path(tg_file).stem + '.wav')

            wav = AudioSegment.from_wav(file_wav)
            concatenated_wav += wav

            # Shift all intervals in the TextGrid by the current time offset
            for tier in file_tg.tiers:
                tier.end_time += current_time_offset
                for interval in tier:
                    interval.end_time += current_time_offset
                    interval.start_time += current_time_offset
                tier.start_time += current_time_offset

                # Append the shifted tier to the concatenated TextGrid
                if concatenated_tg.has_tier(tier.name):
                    concatenated_tg.get_tier_by_name(tier.name).intervals.extend(tier.intervals)
                else:
                    concatenated_tg.add_tier(tier)

            # Update the time offset for the next iteration
            current_time_offset += len(wav) / 1000.0  # Convert milliseconds to seconds

        # check if output folder is present, if not create
        if not os.path.isdir(FOLDER_FINAL):
            os.mkdir(FOLDER_FINAL)

        # Save the concatenated WAV and TextGrid files    
        concatenated_wav.export(os.path.join(FOLDER_FINAL, word + "_concatenated.wav"), format="wav")
        tgt.write_to_file(concatenated_tg, os.path.join(FOLDER_FINAL, word + "_concatenated.TextGrid"), format='long')