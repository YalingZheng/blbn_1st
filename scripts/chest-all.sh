#!/bin/sh

./ChestClinic-random-compare.sh
ps2pdf chestclinic-random-compare.ps

./ChestClinic-bl-compare.sh
ps2pdf chestclinic-bl-compare.ps

./ChestClinic-rr-compare.sh
ps2pdf chestclinic-rr-compare.ps

./ChestClinic-algocompare-all.sh
ps2pdf chestclinic-algocompare-all.ps

./ChestClinic-algocompare-naive-all.sh
ps2pdf chestclinic-algocompare-naive-all.ps

./ChestClinic-algocompare-MB-all.sh
ps2pdf chestclinic-algocompare-MB-all.ps

./ChestClinic-br-compare.sh
ps2pdf chestclinic-br-compare.ps

./ChestClinic-sfl-compare.sh
ps2pdf chestclinic-sfl-compare.ps

./ChestClinic-rsfl-compare.sh
ps2pdf chestclinic-rsfl-compare.ps

./ChestClinic-gsfl-compare.sh
ps2pdf chestclinic-gsfl-compare.ps

./ChestClinic-grsfl-compare.sh
ps2pdf chestclinic-grsfl-compare.ps

./ChestClinic-empg-compare.sh
ps2pdf chestclinic-empg-compare.ps

./ChestClinic-dsep-compare.sh
ps2pdf chestclinic-dsep-compare.ps

./ChestClinic-dsepw1-compare.sh
ps2pdf chestclinic-dsepw1-compare.ps

./ChestClinic-dsepw2-compare.sh
ps2pdf chestclinic-dsepw2-compare.ps