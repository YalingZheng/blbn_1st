#!/bin/bash
gnuplot <<EOF

set term postscript color enhanced eps;

set xlabel 'Values Purchased';
set xrange [0:100];
set ylabel 'Classification Error';
set yrange [0.0:0.3];


set style line 1 lt 1 lw 4 pt 1 lc 1;
set style line 2 lt 2 lw 4 pt 2 lc 2;
set style line 3 lt 3 lw 4 pt 3 lc 3;
set style line 4 lt 4 lw 4 pt 4 lc 4;

set title 'ChestClinic (EMPG)';
set output 'chestclinic-empg2.ps';
plot 'm=ChestClinic;d=ChestClinic;t=TbOrCa;p=bl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:3 lt 1 lc 1 pt 1 lw 4 title 'Baseline(naive)' with linespoints, \
'm=ChestClinic;d=ChestClinic;t=TbOrCa;p=bl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:3 lt 2 lc 2 pt 2 lw 4title 'Baseline(Bayesian)' with linespoints, \
'm=ChestClinic;d=ChestClinic;t=TbOrCa;p=empg;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:3 lt 3 lc 3 pt 3 lw 4title 'EMPG(naive)' with linespoints, \
'm=ChestClinic;d=ChestClinic;t=TbOrCa;p=empg;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:3 lt 4 lc 4 pt 4 lw 4title 'EMPG(Bayesian)' with linespoints;
EOF
