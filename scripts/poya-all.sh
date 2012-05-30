#!/bin/sh

./poya_algocompare_all.sh
ps2pdf poya-algocompare-all.ps

./poya_algocompare_MB_all.sh
ps2pdf poya-algocompare-MB-all.ps

./poya_algocompare_naive_all.sh
ps2pdf poya-algocompare-naive-all.ps

./poya-random-compare.sh
ps2pdf poya-random-compare.ps

./poya-rr-compare.sh
ps2pdf poya-rr-compare.ps

./poya-br-compare.sh
ps2pdf poya-br-compare.ps

./poya-empg-compare.sh
ps2pdf poya-empg-compare.ps

./poya-dsep-compare.sh
ps2pdf poya-dsep-compare.ps

./poya-dsepw1-compare.sh
ps2pdf poya-dsepw1-compare.ps

./poya-dsepw2-compare.sh
ps2pdf poya-dsepw2-compare.ps

./poya-bl-compare.sh
ps2pdf poya-bl-compare.ps

./poya-sfl-compare.sh
ps2pdf  poya-sfl-compare.ps
