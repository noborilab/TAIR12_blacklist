# Bismap/Umap job submission commands follow.

JOBID=$(qsub -q tair12bl -terse -N Index-Bowtie -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome/index_genome.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome/index_genome.ERR -cwd -b y bowtie-build /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome/genome.fa /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome/Umap_bowtie.ind)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.UniqueKmers -terse -tc 120 -hold_jid 1 -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.ERR python get_kmers.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrs /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize_index.tsv --var_id SGE_TASK_ID --kmer k36)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.RunBowtie -terse -tc 120 -hold_jid $WAITID,$WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.ERR python run_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36  /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome Umap_bowtie.ind -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-5:1 -N Bismap.UnifyBowtie -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.ERR python unify_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36/*kmer* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36/*bowtie* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k36/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.UniqueKmers -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.ERR python get_kmers.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrs /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize_index.tsv --var_id SGE_TASK_ID --kmer k50)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.RunBowtie -terse -tc 120 -hold_jid $WAITID,$WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.ERR python run_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50  /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome Umap_bowtie.ind -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-5:1 -N Bismap.UnifyBowtie -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.ERR python unify_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50/*kmer* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50/*bowtie* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k50/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.UniqueKmers -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.ERR python get_kmers.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrs /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize_index.tsv --var_id SGE_TASK_ID --kmer k100)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.RunBowtie -terse -tc 120 -hold_jid $WAITID,$WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.ERR python run_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100  /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome Umap_bowtie.ind -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-5:1 -N Bismap.UnifyBowtie -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.ERR python unify_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100/*kmer* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100/*bowtie* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k100/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.UniqueKmers -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UniqueKmers.ERR python get_kmers.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrs /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize_index.tsv --var_id SGE_TASK_ID --kmer k150)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-146 -N Bismap.RunBowtie -terse -tc 120 -hold_jid $WAITID,$WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.RunBowtie.ERR python run_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150  /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/genome Umap_bowtie.ind -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -t 1-5:1 -N Bismap.UnifyBowtie -terse -tc 120 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.UnifyBowtie.ERR python unify_bowtie.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150 /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150/*kmer* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N Moving.Intermediary.Files -hold_jid $WAITID -terse -cwd -b y -o Bismap.FileMov.LOG -e Bismap.FileMov.ERR mv /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150/*bowtie* /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/k150/TEMPs)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"

JOBID=$(qsub -q tair12bl -N CombineUmappedFiles -terse -t 1-5 -hold_jid $WAITID -cwd -b y -o /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.combine.LOG -e /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers/Bismap.combine.ERR python combine_umaps.py /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/kmers /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/chrsize.tsv -var_id SGE_TASK_ID)
IDPARTS=($(echo $JOBID | tr "." "\n"))
WAITID=${IDPARTS[0]}
echo "Submitted JOB ID $WAITID"
