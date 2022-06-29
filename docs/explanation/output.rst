Understanding workflow output
=============================


The output of the pipeline is currently quite simple. The results directory
(``--outdir`` default is ``./results/``) will contain three subdirectories:

- ``score/``
- ``match/``
- ``pipeline_info/``

``score/``
---------

Calculated scores are stored in a text file called
``aggregated_scores.txt``. The file is a space delimited file. Each row
represents an individual, and there should be at least three columns with the
following headers:

- dataset: the name of the input dataset
- IID: the name of each sample
- PGS001229_22_SUM: this is the name of the calculated score. It will be
  different depending on which scores you have chosen to use. 

At least one score must be present in this file (the third column). Extra
columns might be present if you calculated more than one score.

A summary report is also available (``report.html``). The report should open in
a web browser and contain useful information about the processes that calculated
scores. For example, the number of variants in the scoring file that were
successfully matched against the input target genomes.

``match/``
---------

This directory contains the raw data that is summarised in the scoring
report. The log file is a :term:`CSV` that contains a row for each variant in
the aggregated input scoring files. Columns contain information about how each
variant was matched against the target genomes. For example, a variant in a
scoring file may be:

- Simple to match, with the effect allele being REF and the other allele being
  ALT in the target genomes
- Lifted from its original genome build to match the target genome build
- The effect allele may have matched ALT and the other allele may have matched
  REF in the target genomes

This information might be useful to debug a score that is causing problems.

Processed scoring files are also present in this directory. Briefly, variants in
the scoring files are matched against the target genomes. Common variants across
different scores are combined (left joined, so each score is an additional
column). The combined scores are then partially split to overcome PLINK2
technical limitations (e.g. calculating different effect types such as dominant
/ recessive). Once scores are calculated from these partially split scoring
files, scores are aggregated to produce the final results in ``score/``.

``pipeline_info/``
------------------

Summary reports generated by nextflow describes the execution of the pipeline in
a lot of technical detail. The execution report can be useful to see how long a
job takes to execute. The DAG is a diagram that may be useful to understand how
the pipeline processes data. 