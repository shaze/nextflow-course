#!/usr/bin/env nextflow

/*
 Have a look at the data directory
 Run this program by saying
   nextflow plink1.nf --pops A,martian
*/

dir = "data"

populations = params.pops.split(",")

Channel
  .from(populations)
  .map 
   { pop ->
        [ file("$dir/${pop}.bed"),
          file("$dir/${pop}.bim"),
          file("$dir/${pop}.fam")] 
   }
  .set { plink_data }


process getFreq {
   input:
     file(plinks) from plink_data
   publishDir "output"
   output:
     file output into result
   echo true
   script:
     bed  = plinks[0]
     bim  = plinks[1]
     fam  = plinks[2]
     base = "${bed.baseName}"
     output = "${base}.frq"
     """
     #If you have plink, then uncomment the line below
     #plink --bed $bed --bim $bim --fam $fam --freq --out ${bed.baseName}
     #But since you probably don't have plink
     echo plink --bed $bed --bim $bim --fam $fam --freq --out ${bed.baseName}
     echo "Interesting numbers" >> $output
     """
}
      