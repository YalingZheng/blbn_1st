# I will need to fix a point
# first, I will have that accuracy for random shopper at 80 to 100 percent. 
# then, I can have budgets for the given algorithmms (parameter, which is a list)
# and choose the smallest budget min(smallest budget , 100)
# and then for this budget, for this fixed budget
# compare the accuracy that each algorithm reached
# there are 10 iterations by 10 folds accuracy arrays. t
# and check significance. How do I check1
# significance? 
# to have an array for each two pairs of algorithms, and 
# for each dataset. 
# Now, I get it. Thanks!

#!/usr/bin/env python

import os;
import math;
import string;
import sys;
from scipy import stats;
import numpy as np;
#import cogent.maths.stats.test as stats;
import glob


_policies1 = ["empg", "empg", "MBempg"];
_policies2 = ["dsep", "dsep", "MBdsep"];

_structures1 = ["naive", "normal", "normal"];
_structures2 = ["naive", "normal", "normal"];

networks=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga", "ALARM"];
datasets=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga", "ALARM"];
targets = ["Animal", "ST", "TbOrCa", "G4", "Press"];

budgets=["100","100","40","30","100"];


wilcoxontable = [0, 0, 0, 0, 0, 0, 2, 3, 5, 8];

def mywilcoxon(G1, G2):
    diffs = [];
    for index in range(len(G1)):
        curdiff = G1[index] - G2[index];
        if (curdiff!=0):
            diffs.append(curdiff);
    # now, we check diff
    ranks = [];
    for index in range(len(diffs)):
        numbiggers = 0;
        numsmallers = 0;
        for index2 in range(len(diffs)):
            if (index2!=index):
                # we compare
                if (abs(diffs[index2]) > abs(diffs[index])):
                    numbiggers = numbiggers + 1;
                else:
                    if (abs(diffs[index2] < abs(diffs[index]))):
                        numsmallers = numsmallers + 1;
        currank = (1+numbiggers + len(diffs) - numsmallers)/2.0;
        ranks.append(currank);
    returnsign = 0;
    returnnumber = 0;
    sumsignnegative = 0;
    sumsignpositive = 0;
    for index in range(len(diffs)):
        if (diffs[index] > 0):
            sumsignpositive = sumsignpositive + ranks[index];
        else:
            sumsignnegative = sumsignnegative + abs(ranks[index]);
    minnumber = min(sumsignpositive, sumsignnegative);
    if (minnumber <= wilcoxontable[len(diffs)-1]):
        if (sumsignpositive > sumsignnegative):
            returnsign = 1;
        else:
            if (sumsignpositive < sumsignnegative):
                returnsign = -1;
    return returnsign;


def readall(policies1, policies2, networks, datasets, targets, budgets):
    indexdataset = -1;
    for dataset in datasets:
        print dataset;
        indexdataset = indexdataset + 1;
        network = networks[indexdataset];
        target = targets[indexdataset];
        budget = budgets[indexdataset];
        for index1 in range(len(policies1)):
            policy1 = policies1[index1];
            structure1 = _structures1[index1];
            policy2 = policies2[index1];
            structure2 = _structures2[index1];
            # now, we want to compare policy 1 and policy 2
            G1 = readthebudget(policy1, network, dataset, target, structure1, budget);
            G2 = readthebudget(policy2, network, dataset, target, structure2, budget);
            if ((len(G1) > 0) and (len(G1) == len(G2))):
                signresult = mywilcoxon(G1, G2);
                print G1;
                print G2;
                print signresult;


def readthebudget(policy, network, dataset, target, structure, budget):
    allaccuracies=[];
    print dataset+"."+policy+"-"+structure;
    for iter in range(10):
        curfilename = "m="+network+";d="+dataset+";t="+target+";p="+policy+";r=uniform;s="+structure+";b=100;k=10/*/graph.csv."+str(iter);
        #print "fetch the files"
        realname = "";
        for name in glob.glob(curfilename):
            #print name
            realname = name;
        #print "fetch finished!";
        curaccur = 0;
        curfilename = realname;
        if (os.path.isfile(curfilename)):
            #print "exist!";
            fileHandle = open(curfilename, "r");
            lineList = fileHandle.readlines();
            if (policy=="bl"):
                line = int(budget) - 1;
            else:
                line = int(budget);
            #print "line="+str(line);
            if (len(lineList) >= line+1):
                linecontent = lineList[line];
                lineitems = linecontent.split("	");
                curaccur = 1.0-float(lineitems[3]);
            #print curfilename;
            #print curaccur;
            allaccuracies.append(curaccur);
    return allaccuracies;


readall(_policies1, _policies2, networks, datasets, targets, budgets);

    
