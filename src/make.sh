#!/bin/bash

# Author: UTUMI Hirosi (utuhiro78 at yahoo dot co dot jp)
# License: Apache License, Version 2.0

ruby convert_neologd_to_mozcdic.rb
ruby adjust_entries.rb mozcdic-ut-neologd.txt
ruby filter_unsuitable_words.rb mozcdic-ut-neologd.txt

tar cjf mozcdic-ut-neologd.txt.tar.bz2 mozcdic-ut-neologd.txt
mv mozcdic-ut-neologd.txt* ../

rm -rf ../../mozcdic-ut-neologd-release/
rsync -a ../* ../../mozcdic-ut-neologd-release --exclude=jawiki-* --exclude=mecab-* --exclude=mozcdic-ut-*.txt
