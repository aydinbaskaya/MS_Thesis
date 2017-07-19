function [cost_f1,J_final_f,J_init_f,J_pmax_f,P_demand_f,P_net_f,n_stack_f]=design_multi(x)

gear_ratio=1;       % Gearbox ratio of direct drive
eff_gear=1;
multiwind=1;
% speed_data=excel_read();   %read excel file for speed data (9x5)
speed_data=[1 6 600 0.0900000000000000 4.54103200838914e-05;1 6 600 0.0900000000000000 4.54103200838914e-05;2.90000000000000 55 16500 0.150000000000000 0.00208130633717835;4.80000000000000 152 76200 0.120000000000000 0.00768948086753894;6.70000000000000 299 209000 0.0900000000000000 0.0158179281625555;8.60000000000000 494 444000 0.0900000000000000 0.0336036368620796;10.5000000000000 738 811000 0.0900000000000000 0.0613796159800598;12 846 1063000 0.0900000000000000 0.0804519504152942;12 916 5000000 0.190000000000000 0.798885260735126];
price=10;
if multiwind==1
cost_f2=0;
Jmax=7;
end

for i=1:9
    
   
%----------------------------------------------------------------------
%%Penalty costs are defined here
penalty_eff=0;              %Efficiency penalty
penalty_deflection=0;       %Beam model deflection penalty
penalty_length=0;           %Axial length penalty
penalty_odiam=0;            %Outer diameter penalty
penalty_temperature=0;      %Temperature limit penalty
penalty_power_1=0;          %Power per machine penalty component-1  
penalty_power_2=0;          %Power per machine penalty component-2
penalty_power_total=0;      %total penalty for power violation
penalty_voltage=0;          %terminal voltage violation penalty
%% Definitions in optimization part(user defined variables/constraints)

%Constraints of optimization (variables):
%All the length values are given in (m) to optimization



r_mean=x(1);        % mean radius 
g=x(2);             % air-gap clearence 
J_opt=x(3);         % curent density in A/mm^2
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
n_stack=x(16); % number of parallel machines stacked axially

rpm=speed_data(i,1)*gear_ratio;     %take rpm data             
J_final=Jmax/2;
P_demand=speed_data(i,3)*eff_gear/n_stack;  %take P demand

[J_init,J_pmax,P_o,P_loss,cost_f2]=calculate(x,J_final,rpm,P_demand);

if J_init<Jmax
    if J_init<J_pmax
        J_final=J_init;
        for k=1:2
            [J_init,J_pmax,P_o,P_loss,cost_f2]=calculate(x,J_final,rpm,P_demand);
            J_final=1.03*J_final*P_demand/(P_o+P_loss);
        end
    else
        J_final=0.9*J_pmax;
    end  
else
  J_final=7;
end

[J_init,J_pmax,P_o,P_loss,cost_f2]=calculate(x,J_final,rpm,P_demand);

income=P_o*price*n_stack*0.9;
cost_f2=cost_f2+cost_f2*speed_data(i,5)-income*speed_data(i,4);

cost_f1=cost_f2;

%%
   
J_final_f=J_final;
J_init_f=J_init;
J_pmax_f=J_pmax;
P_demand_f=P_demand;
P_net_f=(P_o+P_loss);
n_stack_f=n_stack;
end