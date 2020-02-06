#!/usr/bin/env bash
echo $1,$2
PWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
j=0
if [ ! -d $PWD/log ];then
  mkdir $PWD/log
fi


for((i=$1;i<=$2;i++));
do
  #random_seed=`expr 12345 + $i `
  #echo $random_seed
  printf -v l "%07d" $i
  echo $l
  python3 create_pretraining_data.py  --input_file=gs://raw_text/wiki_all_raw/wiki_"$i"_string.txt_new.txt \
    --output_file=gs://clue_pretrain_corpus/tfrecords/bert_base_wiki_128/wiki_$i.tfrecord --vocab_file=./resources/vocab.txt \
    --do_lower_case=True --max_seq_length=128 --max_predictions_per_seq=20 --masked_lm_prob=0.15 --random_seed=12345 --dupe_factor=5 >$PWD/log_wiki/tfrecord_$i.log 2>&1 &

  j=$[j+1]
  if [ $j -eq 7 ];then
    wait
    j=0
  fi
done
wait
echo "Finish"
