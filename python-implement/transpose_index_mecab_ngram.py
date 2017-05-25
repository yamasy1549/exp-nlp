import os
import re
import sys
import glob
from collections import defaultdict
from functions import *

token_table = defaultdict(list)

for file_name in glob.glob(sys.argv[2] + sys.argv[1] + 'gram*'):
    basename = os.path.basename(file_name)
    for text in open(file_name).readlines():
        match = re.match(r"(.*)\t(.*)\n", text)
        token_table[match.group(1)].append(re.match(r".*-(.*)", basename).group(1))
f = open(sys.argv[3] + 'word-' + sys.argv[1] + 'gram.txt', 'w')
[f.writelines(token + "\t" + ','.join(files) + "\n") for token, files in token_table.items()]
f.close()

# py transpose_index_mecab_ngram.py 2 ./result-word/ ./result-transpose/
