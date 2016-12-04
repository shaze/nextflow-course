#!/usr/bin/env nextflow

Channel.fromPath("data/*.dat").set { data }


process P1 {
   input:
      file(data)
   output:
      file  "${fbase}.pre" into channelA
      file  data           into channelB
   script:
      fbase=data.baseName
      "echo dummy > ${fbase}.pre"
}

process P2 {
   input:
     file pre from channelA
   output:
     file pre into channelC
   script:
      if (pre.baseName == "a")
      "sleep 4"
      else
      "sleep 1"

}

process P3 {
   input:
      set file(pre), file(data) from \
         channelB.phase(channelC) { fn -> fn.baseName }
   echo true
   script:
    """
     echo "${data} - $pre"
    """
}
