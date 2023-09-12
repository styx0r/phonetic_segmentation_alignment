import os
from pathlib import Path
import tgt
from pydub import AudioSegment

# Get environment variables
RAW_DATA_FOLDER = os.getenv('RAW_DATA_FOLDER', 'data/raw')
SPLIT_DATA_FOLDER = os.environ.get('SPLIT_DATA_FOLDER', 'data/mfa_input')

def split():    

    for file_tgt in os.listdir(RAW_DATA_FOLDER):
        if file_tgt.endswith(".TextGrid"):

            stem = Path(file_tgt).stem
            file_wav = os.path.join(RAW_DATA_FOLDER, stem + '.wav')

            # skip if is not a valid wav file
            if not os.path.isfile(file_wav): continue

            full_wav = AudioSegment.from_wav(file_wav)            
            tg = tgt.read_textgrid(os.path.join(RAW_DATA_FOLDER, file_tgt))

            FOLDER_WAV = RAW_DATA_FOLDER + '/' + stem
            # check if output folder is present, if not create
            if not os.path.isdir(SPLIT_DATA_FOLDER):
                os.mkdir(SPLIT_DATA_FOLDER)

            for interval in tg.get_tier_by_name("utterance"):

                # skip pause intervals denoted by xxx
                if interval.text == 'xxx': continue 

                # get word from text annotation in textgrid file
                word = interval.text.split("_")[3]

                # split wav and export to target folder
                interval_wav = full_wav[int(interval.start_time * 1000):int(interval.end_time * 1000)]
                interval_wav.export(f'''{SPLIT_DATA_FOLDER}/{interval.text}.wav''', format='wav')

                # Create a TextGrid object with the duration of the WAV file
                duration = interval.end_time - interval.start_time
                tg = tgt.TextGrid(duration)            

                # Create an IntervalTier object with the word from the WAV file as text
                word_interval = tgt.Interval(0, duration, word)
                tier = tgt.IntervalTier(name="utterance")
                tier.add_interval(word_interval)                
                # Add the tier to the TextGrid
                tg.add_tier(tier)
                # Save the TextGrid to file in target folder
                tgt.io.write_to_file(tg, f'''{SPLIT_DATA_FOLDER}/{interval.text}.TextGrid''', format='long')