




process getIDs {
    input:
       tuple val(base), path(input)
    output:
       path(ids)     // NB -- var not fixed
    script:
      ids = "${base}.ids"
      " cut -f 2 $input | sort > $ids "
}

process getDups {
    input:
       path(input)
    output:
       tuple val(base), path(dups) 
    script:
       base = input.simpleName
       dups = "${base}.dups"
       """
       uniq -d $input > $dups 
       """
}


process removeDups {
    input:
      tuple val(base), path(badids), path(orig)
    output:
      path(clean)
    publishDir("dups")
    script:
        clean = "${base}-clean.bim"
       "grep -v -f $badids $orig > $clean "
}


workflow {
    main:
       input = Channel.fromPath("data/*bim").map { fn ->  [ fn.simpleName, fn] }
       getIDs(input) | getDups | view | join(input)  | removeDups
       removeDups.out.subscribe { println "Done!" }
}













// Two problems with this code
//   -- silly mistake in that the parameters for removeDups should be switched
//   -- more serious -- only works for one bim file channels. If you put multiple bim files
//      there is no guaranteed that the inputs on the two channels coming in removeDups will
//      by synchronised
//
//  Note that the Nextflow comment indicator is // -- the rest of the line is a comment
//  But if you have a script and have a comment in that you must use the comment character for
//  the language concerned -- see getDups
