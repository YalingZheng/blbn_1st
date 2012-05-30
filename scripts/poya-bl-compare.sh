 #!/bin/bash

gnuplot <<EOF

set term postscript color enhanced eps;
set encoding iso_8859_1

set xlabel 'Values Purchased';
set xrange [0:40];
set ylabel 'Classification Error';
set yrange [0.44:0.6];


set style line 1 lt 1 lw 4 pt 1 lc 1;
set style line 2 lt 2 lw 4 pt 2 lc 2;
set style line 3 lt 3 lw 4 pt 3 lc 3;
set style line 4 lt 4 lw 4 pt 4 lc 4;
set style line 5 lt 5 lw 4 pt 5 lc 5;
set style line 6 lt 6 lw 4 pt 6 lc 6;
set style line 7 lt 7 lw 4 pt 7 lc 7;
set style line 8 lt 8 lw 4 pt 8 lc 8;
set style line 9 lt 9 lw 4 pt 9 lc 9;
set style line 10 lt 10 lw 4 pt 10 lc 10;
set style line 11 lt 11 lw 4 pt 11 lc 11;
set style line 12 lt 12 lw 4 pt 12 lc 12;
set style line 13 lt 13 lw 4 pt 13 lc 13;
set style line 14 lt 14 lw 4 pt 14 lc 14;
set style line 15 lt 15 lw 4 pt 15 lc 15;
set style line 16 lt 16 lw 4 pt 16 lc 16;
set style line 17 lt 17 lw 4 pt 17 lc 17;
set style line 18 lt 18 lw 4 pt 18 lc 18;
set style line 19 lt 19 lw 4 pt 19 lc 19;
set style line 20 lt 20 lw 4 pt 20 lc 20;
set style line 21 lt 21 lw 4 pt 21 lc 21;
set style line 22 lt 22 lw 4 pt 22 lc 22;     
set style line 23 lt 23 lw 4 pt 23 lc 23;
set style line 24 lt 24 lw 4 pt 24 lc 24;
set style line 25 lt 25 lw 4 pt 25 lc 25;
set style line 26 lt 26 lw 4 pt 26 lc 26;
set style line 27 lt 27 lw 4 pt 27 lc 27;
set style line 28 lt 28 lw 4 pt 28 lc 28;
set style line 29 lt 29 lw 4 pt 29 lc 29;
set style line 30 lt 30 lw 4 pt 30 lc 30;
set style line 31 lt 31 lw 4 pt 31 lc 31;
set style line 32 lt 32 lw 4 pt 32 lc 32;


set title 'Poya\_Ganga (Baseline)';
set output 'poya-bl-compare.ps';
plot 'm=Poya_Ganga;d=Poya_m=Poya_Ganga;d=Poya_Ganga;t=G4;p=MBbl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:3 lt 1 lc 1 pt 1 lw 4 title 'MBbaseline(Bayesian)' with linespoints, \
'm=Poya_Ganga;d=Poya_m=Poya_Ganga;d=Poya_Ganga;t=G4;p=bl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:3 lt 2 lc 2 pt 2 lw 4 title 'Baseline(Bayesian)' with linespoints, \
'm=Poya_Ganga;d=Poya_m=Poya_Ganga;d=Poya_Ganga;t=G4;p=bl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:3 lt 3 lc 3 pt 3 lw 4 title 'Baseline(na{\357}ve)' with linespoints;
EOF
