#!/usr/bin/env bash

# set the path
export CLASSPATH=./stanford-corenlp-full-2018-10-05/stanford-corenlp-3.9.2.jar
export DATA=To_Be_Clean/finished_files

# put all the news you want to summarize in my_news, and the result will be in To_Save_My_Files
# but, the files in my_news will be tokenized (so no longer readable)

# first, separate news sentences by dot, as did in the CNN dataset https://cs.nyu.edu/~kcho/DMQA/,
# by: python separate_sentences.py <your_news_dir>
python separate_sentences.py my_news

# now, tokenize it and make jsons by: python make_datafiles.py <your_news_dir>
python make_datafiles.py my_news

# now, unzip
tar -xvf To_Be_Clean/finished_files/test.tar -C To_Be_Clean/finished_files

# run the model
python decode_full_model.py --path=summarizations --model_dir=pretrained --beam=5 --test

# now, the results should be generated in summarizations/output

# generate refs files to rename the summaries
python make_eval_references.py rename

python rename_summaries.py --refs_path=To_Be_Clean/finished_files/refs --summarization_path=summarizations/output
