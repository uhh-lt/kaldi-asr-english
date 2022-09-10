g2p_model=en_g2p_model
final_g2p_model=${g2p_model}-6
train_file=data/local/dict/lexicon.txt
python3 sequitur-g2p/g2p.py -e utf8 --train $train_file --devel 3% --write-model ${g2p_model}-1
python3 sequitur-g2p/g2p.py -e utf8 --model ${g2p_model}-1 --ramp-up --train $train_file --devel 3% --write-model ${g2p_model}-2
python3 sequitur-g2p/g2p.py -e utf8 --model ${g2p_model}-2 --ramp-up --train $train_file --devel 3% --write-model ${g2p_model}-3
python3 sequitur-g2p/g2p.py -e utf8 --model ${g2p_model}-3 --ramp-up --train $train_file --devel 3% --write-model ${g2p_model}-4
python3 sequitur-g2p/g2p.py -e utf8 --model ${g2p_model}-4 --ramp-up --train $train_file --devel 3% --write-model ${g2p_model}-5
python3 sequitur-g2p/g2p.py -e utf8 --model ${g2p_model}-5 --ramp-up --train $train_file --devel 3% --write-model ${g2p_model}-6

