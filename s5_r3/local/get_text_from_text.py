
# raw_text_string = ""
text_list = []

with open ("../data/train/text") as file:
    raw_text = file.read()
text_list = raw_text.split("\n")
textL = []

for text in text_list:
    text = text.lower()
    finish = []
    sentence = text.split(" ")
    sentence = sentence[1:]
    for word in sentence:
        if word == "<unk>":
            continue
        else:
            finish.append(word)
    finish_s = (" ").join(finish)
    textL.append(finish_s)
textf = ("\n").join(textL)

with open("text_for_lm", "w") as fileo:
    fileo.write(textf)

