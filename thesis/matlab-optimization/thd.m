
% .m file for Simulink harmonic data fetch file. Time and phase voltage
% data are taken from excel file 

clc
clear all
close all

time = xlsread('Induced Voltages_W1.xlsx','A2:A102')*1e-3;      %time data is fetched
iv1 = xlsread('Induced Voltages_W1.xlsx','B2:B102');            %winding1 voltage is fetched
iv2 = xlsread('Induced Voltages_W1.xlsx','C2:C102');            %winding2 voltage is fetched
iv3 = xlsread('Induced Voltages_W1.xlsx','D2:D102');            %winding3 voltage is fetched
m1 = [time iv1];
m2 = [time iv2];
m3 = [time iv3];