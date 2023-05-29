

process hwe {
    cpus 4
    memory "4.GB"
    input:
      tuple val(base), path(plinks)
    output:
      path("${base}.hwe")
    script:
     """
     plink --threads 4  --bfile $base --hardy --out $base
    """
}


process getRS {
    cpus 1
    memory "1.GB"
    input:
      path(hwe)
    output:
     path(rs)
    script:
     rs="${hwe.simpleName}.rs"
    """
    grep " rs" $hwe > $rs
    """
}


process rs_combine {
    input:
      path(all)
    output:
     path("combined.hwe")
    publishDir "results"
    script:
      """
      cat *rs > combined.hwe
    """
}

workflow {
    plinks = Channel.fromFilePairs("${params.input}/*.{bed,bim,fam}",size:3) { f -> f.simpleName }
    main:
      hwe(plinks) | getRS | toList | rs_combine

}
