
% .m file for single run condition in order to see the detailed results(@12 rpm rated speed)

rpm=12;

x =[

    4.713644e+00
10
2.475493e+00
3.805812e-02
2.535914e-02
2.240689e-02
7.596965e-01
42
216
6
4.300189e-02
3.889134e-01
6.907907e-01
1.880507e-02
2.827064e-01
6];

x=x';

P_demand=5000000/6;

speed_data=[1.000	187.5	195000	0.319	0.040;...             %%power-speed data is taken here
            1.000	4038.5	420000	0.107	0.029;...
            2.900	2606.1	786000	0.112	0.058;...
            4.800	2596.2	1296000	0.101	0.086;...
            6.700	2788.5	1943000	0.090	0.115;...
            8.600	3017.7	2699000	0.083	0.148;...
            10.500	3193.2	3487000	0.063	0.144;...
            12.000	3344.6	4174000	0.047	0.129;...
            12.000	4006.4	5000000	0.075	0.247];        

i=9;
k=1;
pitch_var=4/3;
[J_init,J_pmax,cost,rpm,J_final,V_ph_rms,I_ph_rms,Pdes,P_tot,Eff,temp,P_net,optim_var,result_list]=calculate_var(x,rpm,P_demand,speed_data,i,pitch_var);   % go to calculation function