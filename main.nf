#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.num_process = 3

process generate {
  container = 'quay.io/nextflow/bash'

  output:
    val num_parallel, emit: parallel

  exec:
    def list = []
    for(int i=0;i<params.num_process;i++) { 
        list.add(i)
    }  
    num_parallel = list
}

process parallel_process {
  echo true
  container = 'quay.io/nextflow/bash'

  input:
    val process_num

  output:
    val process_num, emit: aggregate

  script:
  """
    echo parallel_process $process_num
  """
}

process parallel_process_collect {
  echo true
  container = 'quay.io/nextflow/bash'

  input:
    val input1

  output:

  script:
  """
    echo parallel_process_collect $input1
  """
}

workflow {
  generate()
  parallel_process(generate.out.parallel.flatten())
  parallel_process_collect(parallel_process.out.aggregate.collect())
}
