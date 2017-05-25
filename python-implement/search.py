import sys
from functions import *

transpose_files = [
    './result-transpose/word-1gram.txt',
    './result-transpose/word-2gram.txt',
    './result-transpose/character-2gram.txt',
    './result-transpose/character-3gram.txt',
    './result-transpose/character-4gram.txt'
]

search_words = sys.argv[1:]
if isinstance(search_words, str): search_words = [search_words]

print("OR")
display_result(or_search(search_words, transpose_files)[0][0])
print("AND")
display_result(and_search(search_words, transpose_files)[0][0])

# py search.py オオサンショウウオ
# py search.py 広島 大阪
