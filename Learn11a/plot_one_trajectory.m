% Plot one run of the dynamics
clear all
close all

buildsystem;
time = [0:0.1:3];

[sys, zzhist] = runsystem_sub(sys);

plot(zzhist(5), zzhist(sys.index.act))