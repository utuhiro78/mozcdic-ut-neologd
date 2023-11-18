## Overview

Mozc UT NEologd Dictionary is a dictionary converted from [mecab-ipadic-NEologd](https://github.com/neologd/mecab-ipadic-neologd) for Mozc.

Thanks to the mecab-ipadic-NEologd team.

## License

mozcdic-ut-neologd.txt: [COPYING](https://github.com/neologd/mecab-ipadic-neologd/blob/master/COPYING)

Source code: Apache License, Version 2.0

## Usage

Add mozcdic-ut-*.txt to dictionary00.txt and build Mozc as usual.

```
tar xf mozcdic-ut-*.txt.tar.bz2
cat mozcdic-ut-*.txt >> ../mozc-master/src/data/dictionary_oss/dictionary00.txt
```

To modify the costs for words or merge multiple UT dictionaries into one, use this tool:

[merge-ut-dictionaries](https://github.com/utuhiro78/merge-ut-dictionaries)

## Update this dictionary with the latest stuff

Requirement(s): ruby, rsync

```
cd src/
sh make.sh
```

[HOME](http://linuxplayers.g1.xrea.com/mozc-ut.html)
