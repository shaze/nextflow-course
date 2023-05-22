




process getIDs {
    input:
       path(input)
    output:
       path("ids") 
       path("11.bim")  // obviously not best way to do things
    script:
       " cut -f 2 $input | sort > ids "
}

process getDups {
    input:
       path(input)
    output:
       path("dups")
    script:
       """
       uniq -d $input > dups 
       touch ignore  # file we create but don't stage out
       """
}


process removeDups {
    input:
       path badids 
       path orig   
    output:
       path "clean.bim" 
    script:
       "grep -v -f $badids $orig > clean.bim "
}


workflow {
    main:
       input = Channel.fromPath("data/*bim")
       getIDs(input)
       getDups(getIDs.out[0])
       removeDups(input, getDups.out)
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
