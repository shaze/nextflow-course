
inp = Channel.fromPath("check.nf")


process Sorter {

   input:
      file data from inp
   output:
      file 'lines.srt' into sorted
   """
      sleep 10
      hostname > whoami
      sort $data > lines.srt
   """
}


process Counter {
   input:
      file sortf from sorted
   output:
      file 'answer' into answer
   """
      sleep 2
      hostname  > whoami
      wc -l $sortf > answer
   """
}

answer.subscribe { print it }
