#!/bin/bash

# experiment parameters
NAME="003"
OUTPUT_DIR="results"
OUTPUT_DIR_REL="./results"
DATE=`date +%Y-%m-%d-%H-%M-%S`

# batch parameters
#POLICIES=( "bl" "rr" )
#POLICIES=( "bl" "rr" "br" "empg" )
POLICIES=( "MBdsep")
NETWORKS=( "ALARM" )
STRUCTURES=( "normal" )
#PRIORS=( "uniform" "noisy,1.0" )
PRIORS=( "uniform" )
TARGETS=( "Press" )
DATAS=( "ALARM" )
BUDGET=100
K=10

# program invokation parameters
command="condor_submit"

# program batch invokation 
for POLICY in ${POLICIES[@]}; do
for NETWORK in ${NETWORKS[@]}; do
for STRUCTURE in ${STRUCTURES[@]}; do
for PRIOR in ${PRIORS[@]}; do
for TARGET in ${TARGETS[@]}; do
for DATA in ${DATAS[@]}; do
for F in `seq 0 $[ $K - 1 ]`; do

	# make sure output directories exists
	if [ ! -d $OUTPUT_DIR_REL ]; then
		# directory doesn't exist so create it
		mkdir $OUTPUT_DIR_REL
	fi

	# ../<parameters>
	if [ ! -d "$OUTPUT_DIR_REL/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K" ]; then
		# directory doesn't exist so create it
		mkdir "$OUTPUT_DIR_REL/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K"
	fi

	# ../<parameters>
	if [ ! -d "$OUTPUT_DIR_REL/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE" ]; then
		# directory doesn't exist so create it
		mkdir "$OUTPUT_DIR_REL/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE"
	fi

	OUTPUT="$OUTPUT_DIR/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE"
	OUTPUT_REL="$OUTPUT_DIR_REL/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE"

	# prairiefire script parameters
	PF_SCRIPT_FILE="$OUTPUT/submit.pf.$F"

	echo "# BLBN Experiment Framework" > $PF_SCRIPT_FILE
	echo "# Job Submission Script (with executable, stdin, stderr and log)" > $PF_SCRIPT_FILE
	echo "Universe = vanilla" >> $PF_SCRIPT_FILE
	echo "Executable = /home/scott/mgubbels/blbn/blbn_learner" >> $PF_SCRIPT_FILE
	echo "" >> $PF_SCRIPT_FILE

	
	# describe test in log file
	echo "BATCH:"
	echo "  OUTPUT:    $OUTPUT_DIR_REL"
	echo "INSTANCE:"
	echo "  POLICY:    $POLICY"
	echo "  NETWORK:   $NETWORK"
	echo "  STRUCTURE: $STRUCTURE"
	echo "  PRIOR:     $PRIOR"
	echo "  TARGET:    $TARGET"
	echo "  DATA:      $DATA"
	echo "  BUDGET:    $BUDGET"
	echo "  K:         $K"
	echo "  F:         $F"
	echo "  OUTPUT:    $OUTPUT"/
	echo ""

	# program invokation parameters
	args="./blbn_learner -e $NAME -m ./data/$NETWORK/$NETWORK.dne.$STRUCTURE -d ./data/$DATA/$DATA.cas.$F -v ./data/$DATA/$DATA.cas.${F}v -f $F -k $K -b $BUDGET -t $TARGET -p $POLICY -s $STRUCTURE -r $PRIOR -o $OUTPUT_REL"
	echo "  OUTPUT:    $args"

	echo "Output = /home/scott/mgubbels/blbn/$OUTPUT/debug.stdout.txt.$F" >> $PF_SCRIPT_FILE
	echo "Error  = /home/scott/mgubbels/blbn/$OUTPUT/debug.stderr.txt.$F" >> $PF_SCRIPT_FILE
	echo "Log    = /home/scott/mgubbels/blbn/$OUTPUT/debug.log.txt.$F"    >> $PF_SCRIPT_FILE

	echo "Arguments = $args" >> $PF_SCRIPT_FILE
	echo "Queue 1" >> $PF_SCRIPT_FILE
	echo "" >> $PF_SCRIPT_FILE

	# program invokation
	echo "${command} ${PF_SCRIPT_FILE}"
	#$command $PF_SCRIPT_FILE
	date
	$args
	date
done
done
done
done
done
done
done

exit 0

