function [cost_f1,x_final,ratings,result_list]=design_multi(x)

gear_ratio=1;       % Gearbox ratio of direct drive
eff_gear=1;
multiwind=1;
elec_price=7.3*10^-3;     % Electricity price($) per Wh 
speed_data=[1.000	187.5	195000	0.319	0.040;...             %%power-speed data is taken here
            1.000	4038.5	420000	0.107	0.029;...
            2.900	2606.1	786000	0.112	0.058;...
            4.800	2596.2	1296000	0.101	0.086;...
            6.700	2788.5	1943000	0.090	0.115;...
            8.600	3017.7	2699000	0.083	0.148;...
            10.500	3193.2	3487000	0.063	0.144;...
            12.000	3344.6	4174000	0.047	0.129;...
            12.000	4006.4	5000000	0.075	0.247];                

ratings=cell(10,9);        %ratings table for result design
ratings(1,1)={'rpm'};
ratings(1,2)={'J-Current density'};
ratings(1,3)={'V_ph (rms)'};
ratings(1,4)={'I_ph (rms)'};
ratings(1,5)={'P_desired'};
ratings(1,6)={'P_total'};
ratings(1,7)={'Efficiency'};
ratings(1,8)={'Temperature'};
ratings(1,9)={'P_net'};

%speed_data(:,1)-->rpm values
%speed_data(:,2)-->Average torque in kNm
%speed_data(:,3)-->Average power in W
%speed_data(:,4)-->Time Probability
%speed_data(:,5)-->Energy ratio

%speed_data(1,:)-->4 m/s
%speed_data(2,:)-->5 m/s
%speed_data(3,:)-->6 m/s
%speed_data(4,:)-->7 m/s
%speed_data(5,:)-->8 m/s
%speed_data(6,:)-->9 m/s
%speed_data(7,:)-->10 m/s
%speed_data(8,:)-->11 m/s
%speed_data(9,:)-->12 m/s   --->12 rpm RATED speed


%% Definitions in optimization part(user defined variables/constraints)

%Constraints of optimization (variables):
%All the length values are given in (m) to optimization

r_mean=x(1);        % mean radius 
g=x(2);             % air-gap clearence 

t_o=x(4);           % outer limb thickness
t_i=x(5);           % inner limb thickness
lc=x(6);            % steel web thickness
width_ratio=x(7);   % Magnet/steel width ratio
Nt=x(8);            % number of turns in a coil(integer)
Np=x(9);            % number of poles(integer)
n_branch=x(10);     % number of parallel branches(integer)
h_w=x(11);          % height of the winding
pitch_ratio=x(12);  % winding thickness/coil pitch ratio
kf=x(13);           % fill factor
h_m=x(14);          % height of the magnet
l_magnet=x(15);     % axial lenght of the magnet
n_stack=x(16);      % number of parallel machines stacked axially


% price=10;
if multiwind==1
    cost_f2=0;
    Jmax=7;
end

for i=1:9           % for all speed values 
    


rpm=speed_data(i,1)*gear_ratio;     %take rpm data             
x(3)=Jmax/2;
P_demand=speed_data(i,3)*eff_gear/n_stack;  %take P demand

[J_init,J_pmax,cost_f3,rpm,J,Vph,Iph,Pdes,P_tot,Eff,temp,P_net,optim_var2,result_list]=calculate(x,rpm,P_demand,speed_data,i);

if J_init<Jmax
    if J_init<J_pmax
        x(3)=J_init;
        for k=1:5
            [J_init,J_pmax,cost_f3,rpm,J,Vph,Iph,Pdes,P_tot,Eff,temp,P_net,optim_var2,result_list]=calculate(x,rpm,P_demand,speed_data,i);
            x(3)=x(3)*P_demand/(P_tot/n_stack);
        end
    else
        x(3)=0.9*J_pmax;
    end  
else
  x(3)=Jmax;
end

[J_init,J_pmax,cost_f3,rpm,J,Vph,Iph,Pdes,P_tot,Eff,temp,P_net,optim_var2,result_list]=calculate(x,rpm,P_demand,speed_data,i);   

income=P_net*elec_price*gear_ratio*0.9;     % 0.9 is taken as capacity factor
cost_f2=cost_f2+cost_f3*speed_data(i,5)-income*speed_data(i,4);

ratings(i+1,1)={rpm};
ratings(i+1,2)={J};
ratings(i+1,3)={Vph};
ratings(i+1,4)={Iph};
ratings(i+1,5)={Pdes};
ratings(i+1,6)={P_tot};
ratings(i+1,7)={Eff};
ratings(i+1,8)={temp};
ratings(i+1,9)={P_net};

end

% J_final_f=x(3);
% J_init_f=J_init;
% J_pmax_f=J_pmax;
% P_demand_f=P_demand;
% P_net_f=(P_o+P_loss);
% n_stack_f=n_stack;
cost_f1=cost_f2;
x_final=optim_var2;             % updated variable list is exported to main function
result_list(79)=cost_f2;        % cost value of the individual is assigned for multispeed operation
end