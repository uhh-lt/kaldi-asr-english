
lexicon = ''
with open('data/local/dict_nosp.tedlium/lexicon_words.txt') as file:
    lexicon = file.read()

lexicon = lexicon.split('\n')
wordlist = []
for line in lexicon:
    word = line.split(' ')[0]
    if '<' not in word:
        wordlist.append(word)

with open('data/local/dict_nosp.tedlium/wordlist_autogen.txt', 'w') as ofile:
    ofile.write(('\n').join(wordlist))