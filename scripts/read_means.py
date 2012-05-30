# I will need to fix a point
# first, I will have that accuracy for random shopper at 80 to 100 percent. 
# then, I can have budgets for the given algorithms (parameter, which is a list)
# and choose the smallest budget min(smallest budget , 100)
# and then for this budget, for this fixed budget
# compare the accuracy that each algorithm reached
# there are 10 iterations by 10 folds accuracy arrays. 
# and check significance. How do I check1
# significance? 
# to have an array for each two pairs of algorithms, and 
# for each dataset. 
# Now, I get it. Thanks!

#!/usr/bin/env python

import os;1
import math;
import string;
import sys;
import numpy as np;
import cogent.maths.stats.test as stats;

policies=["bl", "random", "rr", "br", "empg", "dsep", "dsepw1", "dsepw2", "sfl"];
networks=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga;d=Poya_m=Poya_Ganga", "ALARM"];
datasets=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga", "ALARM"];
targets = ["Animal", "ST", "TbOrCa", "G4", "Press"];
structures=["naive", "normal"];
budgets=["100","100","40","30","100"];

def readthebudget(policy, network, dataset, target, structure, budget):
    curfilename = "m="+network+";d="+dataset+";t="+target+";p="+policy+";r=uniform;s="+structure+";b=100;k=10.csv";
    #print curfilename;
    curaccur = 0;
    if (os.path.isfile(curfilename)):
        #print "exist!";
        fileHandle = open(curfilename, "r");
        lineList = fileHandle.readlines();
        if (policy=="bl"):
            line = int(budget) - 1;
        else:
            line = int(budget);
        #print "line="+str(line);
        linecontent = lineList[line];
        lineitems = linecontent.split("	");
        curaccur = 1.0-float(lineitems[2]);
        #print curfilename;
        #print curaccur;
    return curaccur;

def readall(policies, networks, datasets, targets, structures, budgets):
    index = -1;

    for structure in structures:
        for policy in policies:
            curnet = "";
            if structure=="naive":
                curnet = "NB";
            else:
                curnet = "BN";
            str1=policy+"("+curnet+")  ";
            index = -1;
            for dataset in datasets:
                index = index + 1;
                network = networks[index];
                target = targets[index];
                budget = budgets[index];
                currentaccuracy = readthebudget(policy, network, dataset, target, structure, budget);
                str1 = str1 + " & " + str(currentaccuracy);
            print str1 + " \\\\ \hline";
   

print "\begin{table}";
print "\centering";
print "\begin{tabular}{cccccc}";
str1 = " & ";
for dataset in datasets:
    str1 = str1 + dataset + " ";
print str1;

readall(policies, networks, datasets, targets, structures, budgets);

policies=["MBbl", "MBrandom", "MBrr", "MBbr", "MBempg", "MBdsep", "MBdsepw1", "MBdsepw2", "MBsfl"];
networks=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga;d=Poya_m=Poya_Ganga", "ALARM"];
datasets=["Animals", "CarDiagnosis2", "ChestClinic", "Poya_Ganga", "ALARM"];
targets = ["Animal", "ST", "TbOrCa", "G4", "Press"];
structures=["normal"];
budgets=["100","100","40","30","100"];

readall(policies, networks, datasets, targets, structures, budgets);

print "\end{tabular}"
print "\label{table:xxx}";
print "\end{table}";
    
