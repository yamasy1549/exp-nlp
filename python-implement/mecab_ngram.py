import os
import sys
import glob
from collections import defaultdict
from functions import *

file_token_count = defaultdict(lambda:0)
token_table = defaultdict(dict)

for file_name in glob.glob(sys.argv[2] + '*'):
    basename = os.path.basename(file_name)
    text = open(file_name).read()
    text = remove_symbols(remove_url(text))
    ngram = word_ngram(text, int(sys.argv[1]), ["名詞", "動詞", "形容詞", "副詞", "感動詞"])
    file_token_count[basename] += len(ngram)
    for token in ngram:
        if not(basename in token_table[token]):
            token_table[token][basename] = ngram.count(token)
    print(basename)

document_count = len(file_token_count)
for basename, token_count in file_token_count.items():
    f = open(sys.argv[3] + sys.argv[1] + 'gram-' + basename, 'w')
    for token, count in token_table.items():
        if basename in count:
            f.writelines(token + "\t" + str(tf_idf(count[basename], token_count, document_count, len(count))) + "\n")
    f.close()

# py mecab_ngram.py 2 ../data/ ../result-word/
