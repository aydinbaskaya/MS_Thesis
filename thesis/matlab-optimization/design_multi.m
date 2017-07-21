function [cost_f1,J_final_f,J_init_f,J_pmax_f,P_demand_f,P_net_f,n_stack_f]=design_multi(x)

gear_ratio=1;       % Gearbox ratio of direct drive
eff_gear=1;
multiwind=1;
speed_data=[1 6 600 0.0900000000000000 4.54103200838914e-05;...             %%power-speed data is taken here
            1 6 600 0.0900000000000000 4.54103200838914e-05;...
            2.90000000000000 55 16500 0.150000000000000 0.00208130633717835;...
            4.80000000000000 152 76200 0.120000000000000 0.00768948086753894;...
            6.70000000000000 299 209000 0.0900000000000000 0.0158179281625555;...
            8.60000000000000 494 444000 0.0900000000000000 0.0336036368620796;...
            10.5000000000000 738 811000 0.0900000000000000 0.0613796159800598;...
            12 846 1063000 0.0900000000000000 0.0804519504152942;...
            12 916 5000000 0.190000000000000 0.798885260735126];                

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
% J_opt=x(3);         % curent density in A/mm^2
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

[J_init,J_pmax,P_o,P_loss,cost_f3]=calculate(x,rpm,P_demand);

if J_init<Jmax
    if J_init<J_pmax
        x(3)=J_init;
        for k=1:2
            [J_init,J_pmax,P_o,P_loss,cost_f3]=calculate(x,rpm,P_demand);
            x(3)=1.03*x(3)*P_demand/(P_o+P_loss);
        end
    else
        x(3)=0.9*J_pmax;
    end  
else
  x(3)=Jmax;
end

[J_init,J_pmax,P_o,P_loss,cost_f3]=calculate(x,rpm,P_demand);   %fonk donen degerler deg�scek
% buraya yazd�rma yap�lcak
income=0;

cost_f2=cost_f2+cost_f3*speed_data(i,5)-income*speed_data(i,4);

end

J_final_f=x(3);
J_init_f=J_init;
J_pmax_f=J_pmax;
P_demand_f=P_demand;
P_net_f=(P_o+P_loss);
n_stack_f=n_stack;
cost_f1=cost_f2;

end