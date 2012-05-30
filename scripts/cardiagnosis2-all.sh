#!/bin/sh

./CarDiagnosis2-bl-compare.sh
ps2pdf cardiagnosis2-bl-compare.ps

./CarDiagnosis2-random-compare.sh
ps2pdf cardiagnosis2-random-compare.ps

./CarDiagnosis2-rr-compare.sh
ps2pdf cardiagnosis2-rr-compare.ps

./CarDiagnosis2-algocompare-all.sh
ps2pdf cardiagnosis2-algocompare-all.ps

./CarDiagnosis2-naivealgocompare-all.sh
ps2pdf cardiagnosis2-naivealgocompare-all.ps

./CarDiagnosis2-MBalgocompare-all.sh
ps2pdf cardiagnosis2-MBalgocompare-all.ps

./CarDiagnosis2-br-compare.sh
ps2pdf cardiagnosis2-br-compare.ps

./CarDiagnosis2-sfl-compare.sh
ps2pdf cardiagnosis2-sfl-compare.ps

#./CarDiagnosis-rsfl-compare.sh
#ps2pdf CarDiagnosis-rsfl-compare.ps

# ./CarDiagnosis-gsfl-compare.sh
# ps2pdf CarDiagnosis-gsfl-compare.ps

./CarDiagnosis2-grsfl-compare.sh
ps2pdf cardiagnosis2-grsfl-compare.ps

./CarDiagnosis2-empg-compare.sh
ps2pdf cardiagnosis2-empg-compare.ps

./CarDiagnosis2-dsep-compare.sh
ps2pdf cardiagnosis2-dsep-compare.ps

./CarDiagnosis2-dsepw1-compare.sh
ps2pdf cardiagnosis2-dsepw1-compare.ps

./CarDiagnosis2-dsepw2-compare.sh
ps2pdf cardiagnosis2-dsepw2-compare.ps