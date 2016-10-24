#!/usr/bin/env nextflow


input_ch = Channel.fromPath("data/11.bim")

process getIDs {
    input:
       file input from input_ch
    output:
       file "ids" into id_ch
       file "11.bim" into orig_ch
    script:
       " cut -f 2 $input | sort > ids "
}

process getDups {
    input:
       file input from id_ch
    output:
       file "dups" into dups_ch
    script:
       """
       uniq -d $input > dups 
       touch ignore
       """
}


process removeDups {
    input:
       file badids  from dups_ch
       file orig    from orig_ch
    output:
       file "clean.bim" into output
    script:
       "grep -v -f $badids $orig > clean.bim "
}


output.subscribe { print "Done!" }
