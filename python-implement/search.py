import sys
from functions import *

transpose_dir = sys.argv[1]

transpose_files = [
    transpose_dir + 'word-1gram.txt',
    transpose_dir + 'word-2gram.txt',
    transpose_dir + 'character-2gram.txt',
    transpose_dir + 'character-3gram.txt',
    transpose_dir + 'character-4gram.txt'
]

search_words = sys.argv[2:]
if isinstance(search_words, str): search_words = [search_words]

print("OR")
display_result(or_search(search_words, transpose_files))
print("AND")
display_result(and_search(search_words, transpose_files))

# py search.py ./result-transpose/ オオサンショウウオ
# py search.py ./result-transpose/ 広島 大阪
