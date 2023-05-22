

inputs = "${params.input_dir}/${params.input_pat}.{bed,bim,fam}"

process freqs {
    input:
      tuple val(base), path(plink) // plink is actualy an array
    output:
      path(frq)
    script:
      b = plink[0].baseName // easier to use "base" but to show use
      frq = "${b}.frq"
      """
	plink --bfile $b --freq --out $b
      """
}

process combineFreq {
    input:
      path(freqs) // list
    output:
      path(result)
    publishDir "results"
    script:
      result = "overall.frq"
      """
      cat $freqs > $result
    """
}

workflow {
    main:
      plink_ch = Channel
  	.fromFilePairs(inputs, size: 3) { file -> file.simpleName }
      freqs(plink_ch)   | combineFreq
}    
