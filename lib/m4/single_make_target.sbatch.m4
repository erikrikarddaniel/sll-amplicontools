changecom('<!--', '>')changequote(`<<<', `>>>')#!/bin/bash -l
#SBATCH -N __N_NODES__ -n ifelse(__PARTITION__,node,eval(__N_NODES__ * __CORES_PER_NODE__), 1)
#SBATCH -t 10-00:00:00
#SBATCH -J __PREFIX__-__MAKE_TARGET__
#SBATCH -A __PROJECT__
#SBATCH -p __PARTITION__
#SBATCH --mail-type=ALL
#SBATCH --mail-user=__EMAIL__
#__EXTRA_SBATCH_OPT__

echo "-------------------------------------------------------------------------"
echo "`date`: Starting job __PREFIX__-__MAKE_TARGET__"

module load intel openmpi blast
export LC_ALL=C
make __MAKE_TARGET__
rc=$?

echo "`date`: Done __PREFIX__-__MAKE_TARGET__, rc: $rc"
exit $rc
