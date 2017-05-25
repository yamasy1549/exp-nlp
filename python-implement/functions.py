import os
import re
import glob
import math
import MeCab
from collections import defaultdict

def tf(freq, count):
    return freq / count

def idf(count, freq):
    return math.log2(count / freq) + 1

def tf_idf(word_frequency, word_count, document_count, document_frequency):
  return tf(word_frequency, word_count) * idf(document_count, document_frequency)

def simcos(vec_a, vec_b):
    result = 0
    for token, value in vec_a.items():
        if token in vec_b:
            result += value * vec_b[token]
        sum_a2 = sum(value**2 for token, value in vec_a.items())
        sum_b2 = sum(value**2 for token, value in vec_b.items())
    return result / (math.sqrt(sum_a2) * math.sqrt(sum_b2))

def char_ngram(text, n):
    return [text[i:i+n] for i in range(0, len(text)-1)]

def word_ngram(text, n, pos=["名詞"]):
    words = []
    m = MeCab.Tagger("")
    m.parse('')
    node = m.parseToNode(text)
    while node:
        if node.feature.split(",")[0] in pos:
            words.append(node.surface)
        node = node.next
    return [''.join(words[i:i+n]) for i in range(0, len(words)-1)]

def remove_url(text):
    return re.sub(r'https?:\/\/[A-Za-z0-9|\.|/|%|_|(|)]*', '', text)

def remove_symbols(text):
    return re.sub(r'[\n\r!"#$%&\'()\*\+\-\.,\/:;<=>?@\[\\\]^_`{\|}~「」【】『』〈〉《》〔〕〘〙（）！？"＃＄％＆’＝〜｜＿＜＞：；、。\｀｛｝＋＊＾・…　 ]', '', text)

def tf_idf_of(word, basename):
    tf_idf_dirs = [
        './result-word/1gram-',
        './result-word/2gram-',
        './result-character/2gram-',
        './result-character/3gram-',
        './result-character/4gram-'
    ]
    for tf_idf_dir in tf_idf_dirs:
        for line in open(tf_idf_dir + basename).readlines():
            match = re.match(r"(.*)\t(.*)", line)
            if match.group(1) == word: return float(match.group(2))

def prioritize(words, files):
    priority = defaultdict(lambda:0)
    for file_name in files:
        basename = os.path.basename(file_name)
        for word in words:
            if tf_idf_of(word, basename): priority[basename] += tf_idf_of(word, basename)
    return sorted(priority.items(), key=lambda x:-x[1])

def search(word, transpose_files):
    results = set()
    for transpose_file in transpose_files:
        result = set()
        for line in open(transpose_file).readlines():
            match = re.match(r"(.*)\t(.*)", line)
            if match.group(1) in [word]: result = result | set(match.group(2).split(','))
        if result:
            results = set(results) | set(result)
            break
    return set(results)

def or_search(search_words, transpose_files):
    results = set()
    for word in search_words:
        results = results | search(word, transpose_files)
    return prioritize(search_words, results)

def and_search(search_words, transpose_files):
    results = set()
    for word in search_words:
        results = search(word, transpose_files) if not len(results) else results & search(word, transpose_files)
    return prioritize(search_words, results)

def display_with_title(file_name):
    print(file_name + ': ' + open(file_name).readline().rstrip('\n'))

def display_result(searched_list):
    most_proper_file_name = searched_list
    vec_a = {}
    for line in open('./result-word/1gram-' + most_proper_file_name).readlines():
        match = re.match(r"(.*)\t(.*)", line)
        vec_a[match.group(1)] = float(match.group(2))

    files_with_simcos = {}
    for file_name in glob.glob('./result-word/1gram-*'):
        vec_b = {}
        for line in open(file_name).readlines():
            match = re.match(r"(.*)\t(.*)", line)
            vec_b[match.group(1)] = float(match.group(2))
        files_with_simcos[file_name] = simcos(vec_a, vec_b)

    for file_name, simcos_value in sorted(files_with_simcos.items(), key=lambda x:-x[1])[0:10]:
        match = re.match(r"./result-word/1gram-(.*)", file_name)
        display_with_title('../exp-rb/data/' + match.group(1))
        print(file_name + ' ' + str(simcos_value))
