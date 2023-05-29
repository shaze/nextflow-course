

process do_git {
    input:
     val(name)
    output:
     path(name)
    publishDir "results"
    script:
       """
       mkdir $name
       cd $name
       git init
       git --version > version
       git add version
       git commit -a -m First
    """
}


workflow {
    do_git(Channel.from(params.example))
}
