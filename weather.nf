#!/usr/bin/env nextflow


inp_channel = Channel.fromFilePairs("data/*dat", size: -1) \
              { f -> ...... }

process pasteData {
   input:
      set val(key), file(data) 
   output:
      file "${key}.res" 
   publishDir ....
   script:
      " ... "
}




process concatData {
   input:
      file("*") 
   output:
      ....
   publishDir "output", overwrite:true, mode:'move'
   script:
      " .... "
}


workflow  {



}


