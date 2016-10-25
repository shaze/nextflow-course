#!/usr/bin/env nextflow


inp_channel = Channel.fromFilePairs("data/*dat", size: -1) \
              { f -> ...... }

process pasteData {
   input:
      set val(key), file(data) from inp_channel
   output:
      file "${key}.res" into concat_ch 
   publishDir ....
   script:
      " ... "
}




process concatData {
   input:
      file("*") from concat_ch.toList()
   output:
      ....
   publishDir "output", overwrite:true, mode:'move'
   script:
      " .... "
}


output_ch.subscribe { print "$it\n" }


