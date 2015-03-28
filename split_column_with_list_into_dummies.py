import pandas as pd
import os
from collections import Counter

def main(current_filepath,new_filepath):
    df = read_csv(current_filepath)
    c = Counter()
    for programlist in df.programlist.values:
        if pd.notnull(programlist):
            for program_name in programlist.split(','):
                c.update([program_name])
    for program_name in c.keys():
        if c[program_name] > 1:
            df[program_name] = df.programlist.apply(lambda p_list: program_name in p_list.split(',') if pd.notnull(p_list) else False)
    df.to_csv(os.path.expanduser(new_filepath))

    
