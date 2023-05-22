#!/usr/bin/env nextflow

Channel.from([1,"apple"],[2,"banana"],[3,"cherry"],[4,"date"]).set { fruits }
Channel.from([4,"pie"],[5,"sundae"],[2,"split"],[1,"tart"],[3,"ice cream"]). set { modes }


fruits.join(modes).view()




process silly {
    input:
      tuple val(name), val(serving)
    output:
      path(out_fname)
    publishDir "servings"
    script:
      out_fname = "${name}.dat"
      """
        echo $serving > ${out_fname}
      """
}

workflow  {
    main:
      fruits.join(modes).map{ num, fruit, mode -> [fruit, "I like $fruit $mode priority $num"] }.set { servings }
      silly(servings)
}
