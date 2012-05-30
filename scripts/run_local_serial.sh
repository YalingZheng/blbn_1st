#!/bin/bash

# experiment parameters
NAME="ExpIter0000001"
OUTPUT_DIR="./results"
DATE=`date +%Y-%m-%d-%H-%M-%S`

# batch parameters
#POLICIES=( "bl" "rr" "br" )
#POLICIES=( "empg" )
POLICIES=( "sfl" )
#POLICIES=( "grsfl" )
#POLICIES=( "sfl" "gsfl" "rsfl" "grsfl" "empg" )
NETWORKS=( "ChestClinic" )
STRUCTURES=( "normal" )
#STRUCTURES=( "normal" "naive" )
#PRIORS=( "uniform" "noisy,1.0" )
PRIORS=( "uniform" )
TARGETS=( "Bronchitis" )
DATAS=( "ChestClinic" )
BUDGET=100
K=10

# program invokation parameters
command="./blbn_learner"

# program batch invokation 
for POLICY in ${POLICIES[@]}; do
for NETWORK in ${NETWORKS[@]}; do
for STRUCTURE in ${STRUCTURES[@]}; do
for PRIOR in ${PRIORS[@]}; do
for TARGET in ${TARGETS[@]}; do
for DATA in ${DATAS[@]}; do
for F in `seq 0 $[ $K - 1 ]`; do

	# make sure output directories exists
	if [ ! -d $OUTPUT_DIR ]; then
		# directory doesn't exist so create it
		mkdir $OUTPUT_DIR
	fi

	# ../<experiment_name>
	if [ ! -d "$OUTPUT_DIR/$NAME" ]; then
		# directory doesn't exist so create it
		mkdir "$OUTPUT_DIR/$NAME"
	fi

	# ../<parameters>
	if [ ! -d "$OUTPUT_DIR/$NAME/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K" ]; then
		# directory doesn't exist so create it
		mkdir "$OUTPUT_DIR/$NAME/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K"
	fi

	# ../<parameters>
	if [ ! -d "$OUTPUT_DIR/$NAME/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE" ]; then
		# directory doesn't exist so create it
		mkdir "$OUTPUT_DIR/$NAME/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE"
	fi

	OUTPUT="$OUTPUT_DIR/$NAME/m=$NETWORK;d=$DATA;t=$TARGET;p=$POLICY;r=$PRIOR;s=$STRUCTURE;b=$BUDGET;k=$K/$DATE"
	#OUTPUT="$OUTPUT_DIR"
	
	# describe test in log file
	echo "BATCH:"
	echo "  NAME:      $NAME"
	echo "  OUTPUT:    $OUTPUT_DIR"
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
	echo "  OUTPUT:    $OUTPUT"
	echo ""

	# program invokation parameters
	#args="-e \"$NAME\" -m \"./data/$NETWORK/$NETWORK.dne.$STRUCTURE\" -d \"./data/$DATA/$DATA.cas.$F\" -v \"./data/$DATA/$DATA.cas.${F}v\" -f $F -k $K -b $BUDGET -t \"$TARGET\" -p \"$POLICY\" -s \"$STRUCTURE\" -r \"$PRIOR\" -o \"$OUTPUT\""
	args="-e $NAME -m ./data/$NETWORK/$NETWORK.dne.$STRUCTURE -d ./data/$DATA/$DATA.cas.$F -v ./data/$DATA/$DATA.cas.${F}v -f $F -k $K -b $BUDGET -t $TARGET -p $POLICY -s $STRUCTURE -r $PRIOR -o $OUTPUT"
	echo "  OUTPUT:    $args"

	# program invokation
	$command $args

done
done
done
done
done
done
done

exit 0

