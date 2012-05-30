#!/bin/bash
gnuplot <<EOF
set term postscript color enhanced eps linewidth 1.0 'Helvetica 14';

set xlabel 'Values Purchased';
set xrange [0:100];
set ylabel 'Log Loss';
set yrange [0.0:1.5];

set data style linespoints;
set style line 1 lt 0 lw 2;
set style line 2 lt 14 lw 2 pt 14;
set style line 3 lt 1 lw 2;
set style line 4 lt 3 lw 2;
set style line 5 lt 3 lw 2;
set style line 6 lt 3 lw 2;
set style line 7 lt 3 lw 2;
set style line 8 lt 3 lw 2;

set title 'ALARM (normal=solid,naive=dashed)';
set output 'plot=logloss;md=ALARM;t=Press;r=uniform;b=100;k=10.ps';
plot 'm=ALARM;d=ALARM;t=Press;p=bl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 4 title 'Baseline' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=br;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 5 title 'Biased Robin' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=sfl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 6 title 'SFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=gsfl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 7 title 'GSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=rsfl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 8 title 'RSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=grsfl;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 9 title 'GRSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=cheating;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 1 title 'Cheating' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=empg;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 2 title 'EMPG' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=rr;r=uniform;s=normal;b=100;k=10.csv' every 1 using 1:6 lt 1 lc 3 title 'Round Robin' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=bl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 4 title 'Baseline' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=br;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 5 title 'Biased Robin' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=sfl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 6 title 'SFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=gsfl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 7 title 'GSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=rsfl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 8 title 'RSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=grsfl;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 9 title 'GRSFL' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=cheating;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 1 title 'Cheating' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=empg;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 2 title 'EMPG' with lines, \
     'm=ALARM;d=ALARM;t=Press;p=rr;r=uniform;s=naive;b=100;k=10.csv' every 1 using 1:6 lt 2 lc 3 title 'Round Robin' with lines;

