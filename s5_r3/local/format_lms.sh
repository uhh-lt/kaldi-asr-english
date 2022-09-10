#!/usr/bin/env bash
#
# Copyright  2014 Nickolay V. Shmyrev
# Apache 2.0

if [ -f path.sh ]; then . path.sh; fi


small_arpa_lm=data/local/local_lm/data/arpa/4gram_small.arpa.gz
big_arpa_lm=data/local/local_lm/data/arpa/4gram_big.arpa.gz

for f in $small_arpa_lm $big_arpa_lm data/lang_nosp/words.txt; do
  [ ! -f $f ] && echo "$0: expected file $f to exist" && exit 1
done


set -e

if [ -f data/lang_nosp/G.fst ] && [ data/lang_nosp/G.fst -nt $small_arpa_lm ]; then
  echo "$0: not regenerating data/lang_nosp/G.fst as it already exists and "
  echo ".. is newer than the source LM."
else
  # # https://github.com/uhh-lt/kaldi-tuda-de/blob/master/s5_r2/local/format_data.sh#L53
  # gunzip -c "$small_arpa_lm" | \
  #  grep -v '<s> <s>' | \
  #  grep -v '</s> <s>' | \
  #  grep -v '</s> </s>' | \
  #  arpa2fst --disambig-symbol="<eps>" --read-symbol-table=data/lang_nosp/words.txt \
  #   "gunzip -c $small_arpa_lm|" data/lang_nosp/G.fst | fstprint | \
  #  utils/remove_oovs.pl /dev/null | \
  #  utils/eps2disambig.pl | utils/s2eps.pl | fstcompile --isymbols=${lang_out_dir}/words.txt \
  #    --osymbols=${lang_out_dir}/words.txt  --keep_isymbols=false --keep_osymbols=false | \
  #   fstrmepsilon | fstarcsort --sort_type=ilabel > ${lang_out_dir}/G.fst
  # fstisstochastic data/lang_nosp/G.fst/G.fst
  # utils/validate_lang.pl --skip-determinization-check data/lang_nosp

# exit 0;
  arpa2fst --disambig-symbol="#0" --read-symbol-table=data/lang_nosp/words.txt --bos-symbol="<s>" --eos-symbol="</s>" \
  "gunzip -c $small_arpa_lm|" data/lang_nosp/G.fst
  echo  "$0: Checking how stochastic G is (the first of these numbers should be small):"
  fstisstochastic data/lang_nosp/G.fst || true
  utils/validate_lang.pl --skip-determinization-check data/lang_nosp

  # arpa2fst --disambig-symbol="<eps>" --read-symbol-table=data/lang_nosp/words.txt \
  #   "gunzip -c $small_arpa_lm|" data/lang_nosp/G.fst
  # echo  "$0: Checking how stochastic G is (the first of these numbers should be small):"
  # fstisstochastic data/lang_nosp/G.fst || true
  # utils/validate_lang.pl --skip-determinization-check data/lang_nosp
fi



if [ -f data/lang_nosp_rescore/G.carpa ] && [ data/lang_nosp_rescore/G.carpa -nt $big_arpa_lm ] && \
    [ data/lang_nosp_rescore/G.carpa -nt data/lang_nosp/words.txt ]; then
  echo "$0: not regenerating data/lang_nosp_rescore/ as it seems to already by up to date."
else
  utils/build_const_arpa_lm.sh $big_arpa_lm data/lang_nosp data/lang_nosp_rescore || exit 1;
fi

exit 0;
