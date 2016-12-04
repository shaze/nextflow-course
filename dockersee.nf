#!/usr/bin/env nextflow

/*
 Have a look at the data directory
 Run this program by saying
   nextflow plink1.nf --pops A,martian
*/



script = Channel.fromPath("*nf")


// NB: When this runs, it runs in a directory such as
// work/6b/6adfc8bc0760d67224e3cec381a839/ relative to the where you run it.


process showFiles {
   input:
     file script
   publishDir "output", overwrite: true
   output:
     file output into result
   echo true
   script:
     output = "${script.baseName}.out"
     """
     echo "I am running on `hostname`"
     echo "Current directory <`pwd`"
     echo "Check who owns  it"
     ls -ld .
     echo "This is a directory of the host that Docker mounts"
     ls ../../../..
     echo "This is the home directory of the Docker machine"
     ls \$HOME
     touch $output
     """
}
      