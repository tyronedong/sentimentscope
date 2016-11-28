#!/bin/bash
cat email_succ.temp > email_succ.txt
date >> email_succ.txt
curr_date=$(date +%Y%m%d_%H%M)
seperator="_"
lang="$1"
set="$2"
beginIndex=1
endIndex=1

if [ "$set" == "full" ] 
then
beginIndex=2
endIndex=10
fi

l2=0.0005
NElen=6

if [ "$lang" == 'es' ]
then
l2=0.001
NElen=7
fi

modelname="baseline_joint_exact"

task=$lang"_"$curr_date"_"$set

echo "set=$set task=$task begin=$beginIndex end=$endIndex"
mkdir experiments/sentiment/model/$modelname/Twitter_$lang/$task

logfile=$task".log"


echo "more "$logfile" | grep Iteration | wc -l" > check.sh
chmod +x check.sh
CLASSPATH=/usr/local/share/java/zmq.jar:lib/json-20140107.jar:lib/stanford-corenlp-3.5.2.jar:bin:.
LD_LIBRARY_PATH=/usr/local/lib


java -Xmx32g -Djava.library.path=$LD_LIBRARY_PATH -cp $CLASSPATH com.nlp.targetedsentiment.util.TargetSentimentGlobal $modelname 1000 $l2 $beginIndex $endIndex $lang weightnotpush $task $NElen > $logfile 2>&1

#python scripts/sentiment.py $beginIndex $endIndex sentimentspan_nonlatent $lang $task N

date >> email_succ.txt
#sendmail lihao.leolee@gmail.com < email_succ.txt