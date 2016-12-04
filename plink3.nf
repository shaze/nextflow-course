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
   publishDir "output", overwrite: true
   output:
     file output into result
   echo true
   script:
     output = "${bed.baseName}.frq"
     """
     pwd
     echo "Current directory"
     ls -ld .
     echo "Now home"
     ls \$HOME
     #Finally fake result
     touch $output
     """
}
      