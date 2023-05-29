

inputs = "${params.input_dir}/${params.input_pat}.{bed,bim,fam}"

println "Using from"
Channel.from(inputs).view()

println "\n\n\n\nNow fromPath"
Channel.fromPath(inputs).view()



println "\n\n\n\nNow fromFilePairs -- group by file name"
Channel
    .fromFilePairs(inputs, size: 3) { file -> file.simpleName }
    .view { pref, files -> "Files with the prefix $pref are $files" }


//println "\n\n\n\nNow fromFilePairs -- group by extension"
//Channel
//    .fromFilePairs("${params.input_dir}/*", size: -1) { file -> file.extension }
//    .view { ext, files -> "Files with the extension $ext are $files" }


//NB I could put all of the above in one line but to make it more readable for my notes
//and avoid very wide lines I split
