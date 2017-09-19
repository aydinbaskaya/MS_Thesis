rpm=12;

x=[4.571154e+00
7
2.707520e+00
3.001002e-02
2.000441e-02
2.150048e-02
7.373051e-01
50
216
6
4.067750e-02
3.827594e-01
7.999960e-01
1.712807e-02
2.616336e-01
6];

x=x';

P_demand=5000000/6;

speed_data=[1 6 600 0.0900000000000000 4.54103200838914e-05;...             %%power-speed data is taken here
            1 6 600 0.0900000000000000 4.54103200838914e-05;...
            2.90000000000000 55 16500 0.150000000000000 0.00208130633717835;...
            4.80000000000000 152 76200 0.120000000000000 0.00768948086753894;...
            6.70000000000000 299 209000 0.0900000000000000 0.0158179281625555;...
            8.60000000000000 494 444000 0.0900000000000000 0.0336036368620796;...
            10.5000000000000 738 811000 0.0900000000000000 0.0613796159800598;...
            12 846 1063000 0.0900000000000000 0.0804519504152942;...
            12 916 5000000 0.190000000000000 0.798885260735126];                

i=9;
k=1;
sonuc=zeros(1,70);
for pitch_var=0.1:0.1:7 
[J_init,J_pmax,cost,rpm,J_final,V_ph_rms,I_ph_rms,Pdes,P_tot,Eff,temp,P_net,optim_var,result_list]=calculate_var(x,rpm,P_demand,speed_data,i,pitch_var);
sonuc(1,k)=result_list(51);
k=k+1;
end
pitch_var=0.1:0.1:7 ;
plot(pitch_var,abs(sonuc/438.35*100),'b--o','LineWidth',1);
grid on
grid minor
xlabel('Tc/Tp','FontSize',16)
ylabel('Induced voltage magnitude percentage of Tc/Tp=4/3','FontSize',16)
title('Induced Voltage variation with Tc/Tp','FontSize',16)


