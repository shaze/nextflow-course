#!/usr/bin/env nextflow


params.data_dir = "data"

input_ch = Channel.fromPath("${params.data_dir}/*.bim")

process getIDs {
    input:
       file input from input_ch
    output:
       file "${input.baseName}.ids" into id_ch
       file "$input" into orig_ch
    script:
       " cut -f 2 $input | sort > ${input.baseName}.ids "
}

process getDups {
    input:
       file input from id_ch
    output:
       file "${input.baseName}.dups" into dups_ch
    script:
       out = "${input.baseName}.dups"
       """
       uniq -d $input > $out
       touch ignore
       """
}


process removeDups {
    input:
       file badids  from dups_ch
       file "orig.bim"    from orig_ch
    output:
       file "${badids.baseName}.bim" into cleaned_ch
    publishDir "output", pattern: "${badids.baseName}.bim",\
                  overwrite:true, mode:'copy'

    script:
       "grep -v -f $badids orig.bim > ${badids.baseName}.bim "
}

splits = [400,500,600]

process splitIDs  {
    input:
       file bim from cleaned_ch
    each split from splits
    output:
       file ("*-$split-*") into output_ch;

    script:
    "split -l $split $bim ${bim.baseName}-$split- "
}


output_ch.subscribe { print "Done! ${it.baseName}\n" }
