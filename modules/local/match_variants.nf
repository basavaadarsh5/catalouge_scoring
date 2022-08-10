process MATCH_VARIANTS {
    tag "$meta.id"
    label 'process_medium'
    errorStrategy 'finish'

    conda (params.enable_conda ? "$projectDir/environments/pgscatalog_utils/environment.yml" : null)
    def dockerimg = "dockerhub.ebi.ac.uk/gdp-public/pgsc_calc/pgscatalog_utils:${params.platform}-0.1.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://dockerhub.ebi.ac.uk/gdp-public/pgsc_calc/singularity/pgscatalog_utils:amd64-0.1.1' :
        dockerimg }"

    input:
    tuple val(meta), val(chrom), path('??.vars'), path(scorefile)

    output:
    tuple val(scoremeta), path("*.scorefile"), emit: scorefile
    path "*_log.csv"                         , emit: db
    path "versions.yml"                      , emit: versions

    script:
    def args = task.ext.args ?: ''
    def split = !chrom.contains(false) ? '--split': ''
    def format = meta.is_bfile ? 'bim' : 'pvar'
    def ambig = params.keep_ambiguous ? '--keep_ambiguous' : ''
    def multi = params.keep_multiallelic ? '--keep_multiallelic' : ''
    scoremeta = [:]
    scoremeta.id = "$meta.id"

    """
    match_variants \
        $args \
        --dataset ${meta.id} \
        --scorefile $scorefile \
        --target "\$PWD/*.vars" \
        $split \
        -n $task.cpus \
        $ambig \
        $multi \
        --outdir \$PWD \
        -v

    cat <<-END_VERSIONS > versions.yml
    ${task.process.tokenize(':').last()}:
        pgscatalog_utils: \$(echo \$(python -c 'import pgscatalog_utils; print(pgscatalog_utils.__version__)'))
    END_VERSIONS
    """
}
