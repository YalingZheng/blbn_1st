#!/bin/sh

./animals-random-compare.sh
ps2pdf animals-random-compare.ps

./animals-bl-compare.sh
ps2pdf animals-bl-compare.ps

./animals-rr-compare.sh
ps2pdf animals-rr-compare.ps

./animals-algocompare-all.sh
ps2pdf animals-algocompare-all.ps

./animals-algocompare-naive-all.sh
ps2pdf animals-algocompare-naive-all.ps

./animals-algocompare-MB-all.sh
ps2pdf animals-algocompare-MB-all.ps
./animals-br-compare.sh
ps2pdf animals-br-compare.ps

./animals-sfl-compare.sh
ps2pdf animals-sfl-compare.ps

./animals-rsfl-compare.sh
ps2pdf animals-rsfl-compare.ps

./animals-gsfl-compare.sh
ps2pdf animals-gsfl-compare.ps

./animals-grsfl-compare.sh
ps2pdf animals-grsfl-compare.ps

./animals-empg-compare.sh
ps2pdf animals-empg-compare.ps

./animals-dsep-compare.sh
ps2pdf animals-dsep-compare.ps

./animals-dsepw1-compare.sh
ps2pdf animals-dsepw1-compare.ps

./animals-dsepw2-compare.sh
ps2pdf animals-dsepw2-compare.ps
