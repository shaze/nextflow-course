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
     set file(bed), file(bim), file(fam) from plink_data
   publishDir "output"
   output:
     file output into result
   echo true
   script:
     output = "${bed.baseName}.frq"
     """
     #If you have plink, then uncomment the line below
     #plink --bed $bed --bim $bim --fam $fam --freq --out ${bed.baseName}
     #But since you probably don't have plink
     #Just put the command itself
     echo plink --bed $bed --bim $bim --fam $fam --freq --out ${bed.baseName}
     echo "Interesting numbers" >  $output
     """
}
      