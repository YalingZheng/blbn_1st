/**
 *  blbn_learner.c
 *
 *  Example use of Netica-C API for learning the CPTs of a Bayes net
 *  from a file of cases.
 *
 *
 * @author Michael Gubbels
 * @author Yaling Zheng
 * @date 2010-08/24
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>
#include "blbn/blbn.h"

/**
 * Main routine
 */
int main (int argc, char *argv[]) {

	int i = -1;
	int result = 0;
	blbn_state_t *state = NULL;

	char experiment_name[512]     = { 0 }; // experiment name (-e <experiment_name>)
	char data_filepath[512]       = { 0 }; // data file path (-d <data_filepath>)
	char test_data_filepath[512]  = { 0 }; // test data file path (-v <test_data_filepath>)
	char model_filepath[512]      = { 0 }; // model/network file path (-m <model_filepath>)
	char target_node_name[512]    = { 0 }; // target node name (-t <target_node_name>)
	int budget                    = 0;     // budget (-b <budget>)
	char policy[32]               = { 0 }; // selection policy (-p <policy_name>)
	char prior[32]                = { 0 }; // prior distribution (-r <prior_distribution_name>)
	char output_folder[256]       = { 0 }; // output folder (-o <output_folder>)
	char structure[8]             = { 0 }; // structure (-s <structure_name>)
	int fold_count                = -1;    // k-folds (-k <fold_count>)
	int fold_index                = -1;    // fold index (-f <fold_index>)
	double equivalent_sample_size = 1.0;

	//------------------------------------------------------------------------------
	// Parse command-line arguments and extract valid parameters
	//------------------------------------------------------------------------------

	// Iterate through arguments and extract valid arguments
	for (i = 0; i < argc; i++) {
		//printf ("Parsing argument: %s\n", argv[i]);

		if (strncmp (argv[i], "-", 1) == 0) {
			if (strcmp (argv[i], "-e") == 0) {
				if (i < argc) {
					strcpy (&experiment_name[0], argv[i + 1]);

					printf ("Experiment name (-e): %s\n", &experiment_name[0]);
				}
			} else if (strcmp (argv[i], "-d") == 0) {
				if (i < argc) {
					strcpy (&data_filepath[0], argv[i + 1]);

					printf ("Training data filepath (-d): %s\n", &data_filepath[0]);
				}
			} else if (strcmp (argv[i], "-v") == 0) {
				if (i < argc) {
					strcpy (&test_data_filepath[0], argv[i + 1]);

					printf ("Validation data filepath (-v): %s\n", &data_filepath[0]);
				}
			} else if (strcmp (argv[i], "-m") == 0) {
				if (i < argc) {
					strcpy (&model_filepath[0], argv[i + 1]);

					printf ("Model filepath (-m): %s\n", &model_filepath[0]);
				}
			} else if (strcmp (argv[i], "-b") == 0) {
				if (i < argc) {
					budget = atoi (argv[i + 1]);

					printf ("Budget: %d\n", budget);
				}
			} else if (strcmp (argv[i], "-f") == 0) {
				if (i < argc) {
					fold_index = atoi (argv[i + 1]);

					printf ("Fold index (-f): %d\n", fold_index);
				}
			} else if (strcmp (argv[i], "-k") == 0) {
				if (i < argc) {
					fold_count = atoi (argv[i + 1]);

					printf ("Fold count (-k): %d\n", fold_count);
				}
			} else if (strcmp (argv[i], "-z") == 0) {
				if (i < argc) {
					equivalent_sample_size = atof (argv[i + 1]);

					printf ("Equivalent sample size (-z): %f\n", equivalent_sample_size);
				}
			} else if (strcmp (argv[i], "-t") == 0) {
				if (i < argc) {
					strcpy (&target_node_name[0], argv[i + 1]);

					printf ("Target node (-t): %s\n", &target_node_name[0]);
				}
			} else if (strcmp (argv[i], "-p") == 0) {
				if (i < argc) {
					strcpy (&policy[0], argv[i + 1]);

					printf ("Policy (-p): %s\n", &policy[0]);
				}
			} else if (strcmp (argv[i], "-r") == 0) {
				if (i < argc) {
					strcpy (&prior[0], argv[i + 1]);

					printf ("Prior (-r): %s\n", &prior[0]);
				}
			} else if (strcmp (argv[i], "-o") == 0) {
				if (i < argc) {
					strcpy (&output_folder[0], argv[i + 1]);

					printf ("Output folder (-o): %s\n", &output_folder[0]);
				}
			} else if (strcmp (argv[i], "-s") == 0) {
				if (i < argc) {
					strcpy (&structure[0], argv[i + 1]);

					printf ("Structure (-s): %s\n", &structure[0]);
				}
			}
		}
	}

	//------------------------------------------------------------------------------
	// Validate parameters
	//------------------------------------------------------------------------------

	// Check if training data file exists
	if (!file_exists (data_filepath)) {
		printf ("Error: Data file path is invalid. Exiting.\n");
		exit (1);
	}

	// Check if validation data file exists
	if (!file_exists (test_data_filepath)) {
		printf ("Error: Test data file path is invalid. Exiting.\n");
		exit (1);
	}

	// Check if model file exists
	if (!file_exists (model_filepath)) {
		printf ("Error: Model (network) file path is invalid. Exiting.\n");
		exit (1);
	}

	// Validate structure (-s) parameter
	if (strlen (structure) == 0) {
		printf ("Error: No network structure defined.\n");
		exit (1);
	} else if (strcmp (structure, "naive") != 0 && strcmp (structure, "normal") != 0) {
		printf ("Error: Invalid network structure specified.  Valid structures are \"normal\" and \"naive\".");
		exit (1);
	}

	// Validate fold count and fold index
	if (fold_index >= fold_count) {
		printf ("Error: Fold index (-f) is not less than fold count (-k). Exiting.\n");
		exit (1);
	}

	if (fold_count < 0) {
		printf ("Error: Fold count (-k) was not specified. Exiting.\n");
		exit (1);
	}

	if (fold_index < 0) {
		printf ("Error: Fold index (-f) was not specified. Exiting.\n");
		exit (1);
	}

	// Validate budget
	if (budget < 0) {
		printf ("Error: An invalid budget (-b) was specified. Exiting.\n");
		exit (1);
	}

	// Validate equivalent sample size
	if (equivalent_sample_size < 1.0) {
		printf ("Error: An invalid equivalent sample size (-z) was specified. Exiting.\n");
		exit (1);
	}

	// Validate target node
	if (strlen (target_node_name) <= 0) {
		printf ("Error: No target node name was specified.  Existing.\n");
	} else {
		// Check if target node is valid node in the specified network
	}

	if (blbn_init () != 0) {
		exit (1);
	}

	//------------------------------------------------------------------------------
	// Initialize and start learning procedures
	//------------------------------------------------------------------------------

//	// TODO: Write code for d-connected nodes
//	// TODO: Write code for d-separated (may also be referred to as d-disconnected) nodes
//
//	// Compute d-separated nodes
//	nodelist_bn* d_separated = GetNetNodes_bn(/* net */); // Initialize node list with all nodes in the network
//
//	//Find all the descendants of a node, excluding the node itself.
//	//nodelist_bn* d_separated = NewNodeList2_bn (0, GetNodeNet_bn (node));
//	GetRelatedNodes_bn (d_separated, "d_connected,subtract,exclude_self", node); // Subtract node of interest and all nodes in the relation (d-connected) to the specified node of interest
//	// NOTE: At this point, the node list d_separated contains the nodes d-separated from the specified node of interest
//	// ...

	printf("\npolicy = %s\n", policy);
	state = blbn_init_state (experiment_name, data_filepath, test_data_filepath, model_filepath, target_node_name, budget,
			output_folder, policy, fold_count, fold_index); // Initialize meta-data used for learning

	//printf("yes, here");
/*	// <BEGINNING OF D-SEP TEST CASE SUITE>

	int *d_seps = NULL;
	int d_sep_count;

	// Test Case 2
	printf ("\nTest Case 1:\n");

	// Enter/instantiate nodes with findings and get d-separations
	printf ("Entering findings: { ");
	blbn_retract_findings (state);
	blbn_assert_node_finding (state, blbn_get_node_index (state, "TbOrCa"), 0); printf ("TbOrCa "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "TbOrCa")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "VisitAsia"), 0); printf ("VisitAsia "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "VisitAsia")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Tuberculosis"), 0); printf ("Tuberculosis "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Tuberculosis")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Smoking"), 0); printf ("Smoking "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Smoking")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Cancer"), 0); printf ("Cancer "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Cancer")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Dyspnea"), 0); printf ("Dyspnea "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Dyspnea")));

	printf ("}\n");
	d_sep_count = blbn_get_d_separated_nodes (state, blbn_get_node_index (state, "TbOrCa"), &d_seps); // Get nodes d-sep from target node

	printf ("D-separation count: %d\n", d_sep_count);
	printf ("D-separations: { ");
	for (i = 0; i < d_sep_count; ++i) {
		printf ("%d ", d_seps[i]);
		printf ("%s ", blbn_get_node_name (state, d_seps[i]));
		printf ("[%d] ", blbn_has_finding_set (state, d_seps[i]));
	}
	printf ("}\n");

	// Test Case 2
	printf ("\nTest Case 2:\n");

	// Enter/instantiate nodes with findings and get d-separations
	printf ("Entering findings: { ");
	blbn_retract_findings (state);
	blbn_assert_node_finding (state, blbn_get_node_index (state, "TbOrCa"), 0); printf ("TbOrCa "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "TbOrCa")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "VisitAsia"), 0); printf ("VisitAsia "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "VisitAsia")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Tuberculosis"), 0); printf ("Tuberculosis "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Tuberculosis")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Smoking"), 0); printf ("Smoking "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Smoking")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Cancer"), 0); printf ("Cancer "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Cancer")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Dyspnea"), 0); printf ("Dyspnea "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Dyspnea")));

	printf ("}\n");
	d_sep_count = blbn_get_d_separated_nodes (state, blbn_get_node_index (state, "TbOrCa"), &d_seps); // Get nodes d-sep from target node

	printf ("D-separation count: %d\n", d_sep_count);
	printf ("D-separations: { ");
	for (i = 0; i < d_sep_count; ++i) {
		printf ("%d ", d_seps[i]);
		printf ("%s ", blbn_get_node_name (state, d_seps[i]));
		printf ("[%d] ", blbn_has_finding_set (state, d_seps[i]));
	}
	printf ("}\n");

	// Test Case 3
	printf ("\nTest Case 3:\n");

	// Enter/instantiate nodes with findings and get d-separations
	printf ("Entering findings: { ");
	blbn_retract_findings (state);
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "TbOrCa"), 0); printf ("TbOrCa "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "TbOrCa")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "VisitAsia"), 0); printf ("VisitAsia "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "VisitAsia")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Tuberculosis"), 0); printf ("Tuberculosis "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Tuberculosis")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "Smoking"), 0); printf ("Smoking "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Smoking")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Cancer"), 0); printf ("Cancer "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Cancer")));
	//blbn_assert_node_finding (state, blbn_get_node_index (state, "Dyspnea"), 0); printf ("Dyspnea "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "Dyspnea")));
	blbn_assert_node_finding (state, blbn_get_node_index (state, "XRay"), 0); printf ("XRay "); printf ("[%d] ", blbn_has_finding_set (state, blbn_get_node_index (state, "XRay")));

	printf ("}\n");
	d_sep_count = blbn_get_d_separated_nodes (state, blbn_get_node_index (state, "TbOrCa"), &d_seps); // Get nodes d-sep from target node

	printf ("D-separation count ...........: %d\n", d_sep_count);
	printf ("D-separations: { ");
	for (i = 0; i < d_sep_count; ++i) {
		printf ("%d ", d_seps[i]);
		printf ("%s ", blbn_get_node_name (state, d_seps[i]));
		printf ("[%d] ", blbn_has_finding_set (state, d_seps[i]));
	}
	printf ("}\n");*/

	//exit (1);

	// <END OF D-SEP TEST CASE>

	//printf ("\nHahahahah............... here!");


	//int* markov_blanket1 =



	// Now, we know the markov_blanket1's content

	if (state != NULL) {

		// Set network prior probability distributions over the nodes
		if (strcmp (prior, "uniform") == 0) {
			blbn_set_uniform_prior (state, equivalent_sample_size);
		}

		// Perform learning using selected policy
		if (strcmp (policy, "bl") == 0) {
			blbn_learn_baseline (state);
		}
		else if (strcmp (policy, "MBbl")==0){
			blbn_learn_MBbaseline (state);
		}
		else if ((strcmp(policy, "random")==0) || (strcmp(policy, "MBrandom")==0)) {
			blbn_learn(state, BLBN_POLICY_RANDOM);
		}
		else if ((strcmp(policy, "MBrr") == 0) || (strcmp (policy, "rr") == 0)) {
			blbn_learn (state, BLBN_POLICY_ROUND_ROBIN);
		} else if ((strcmp(policy, "MBbr") == 0) || (strcmp (policy, "br") == 0)) {
			blbn_learn (state, BLBN_POLICY_BIASED_ROBIN);
		} else if ((strcmp(policy, "MBsfl")==0) || (strcmp (policy, "sfl") == 0)) {
			blbn_learn (state, BLBN_POLICY_SFL);
		} else if ((strcmp (policy, "MBgsfl")==0) || (strcmp (policy, "gsfl") == 0)) {
			blbn_learn (state, BLBN_POLICY_GSFL);
		} else if ((strcmp (policy, "MBrsfl")==0) || (strcmp(policy, "rsfl") == 0)) {
			blbn_learn (state, BLBN_POLICY_RSFL);
		} else if ((strcmp(policy, "MBgrsfl")==0) || (strcmp (policy, "grsfl") == 0)) {
			blbn_learn (state, BLBN_POLICY_GRSFL);
		} else if ((strcmp(policy, "MBempg")==0) || (strcmp (policy, "empg") == 0)) {
			blbn_learn (state, BLBN_POLICY_EMPG);
		} else if ((strcmp(policy, "MBdsep")==0) || (strcmp (policy, "dsep") == 0)) {
			//printf("Yes, it is dsep! .................");
			blbn_learn(state, BLBN_POLICY_EMPGDSEP);
		} else if ((strcmp(policy, "MBdsepw1")==0) || (strcmp (policy, "dsepw1") == 0)){
			//printf("Yes, it is dsep as weighting factor 1!");
			blbn_learn(state, BLBN_POLICY_EMPGDSEPW1);
		} else if ((strcmp(policy, "MBdsepw2") == 0) || (strcmp (policy, "dsepw2") == 0)){
			//printf("Yes, it is dsep as weighting factor 2!");
			blbn_learn(state, BLBN_POLICY_EMPGDSEPW2);
		} else if ((strcmp(policy, "MBcheating") == 0) || (strcmp (policy, "cheating") == 0)) {
			blbn_learn (state, BLBN_POLICY_CHEATING);
		}

		blbn_free_state (state);
	}

	//------------------------------------------------------------------------------

	/*
	// Cleanup (free allocated structures, etc.)
	DeleteStream_ns (casefile); // added this... I think I should b/c of what I read in documentation
	DeleteNodeList_bn (learned_nodes);
	DeleteNet_bn (orig_net);
	DeleteNet_bn (learned_net);
	res = CloseNetica_bn (env, mesg);
	*/
	// printf ("%s\n", mesg);


	return (result < 0 ? -1 : 0);


}

int file_exists (char *filename) {
	struct stat buffer;
	return (stat(filename, &buffer) == 0);
}




