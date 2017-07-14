function [cost_f,J_final_f,J_init_f,J_pmax_f,P_demand_f,P_net_f,n_stack_f]=design(x)
%----------------------------------------------------------------------
%%Penalty costs are defined here
penalty_eff=0;              %Efficiency penalty
penalty_deflection=0;       %Beam model deflection penalty
penalty_length=0;           %Axial length penalty
penalty_odiam=0;            %Outer diameter penalty
penalty_temperature=0;      %Temperature limit penalty
penalty_power=0;            %Power per machine penalty   

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

%Constants of optimization :

multispeed=0 ;
P_des=5000000;      % Desired rated output power
rpm=12 ;            % rotational speed
gear_ratio=1;       % Gearbox ratio of direct drive
eff_gear=1;         % Efficiency of gearbox
groove=0 ;          % space between c-cores 
groove_c=0;         % gap between modules 
m=3;                % number of phases
t_amb=20;           % ambient temperature in oC
J_final_type=7;           % 7 A/mm^2 @100 oC is assumed for Forced air cooling 
alpha_Cu=3.9E-03 ;  % temperature coefficent at 20 Celcius degree
rho_cu=1.7E-08;     % copper resistivity coefficient
h_band=0.01 ;       % h_band: height of steel band(J_finalubilee clip)
w_band=0.04;        % w_band: axial width of the steel band(J_finalubilee clip)
mu_0=1.257E-06 ;    % permeability of air
Br=1.3 ;            % magnet remanent flux density--Grade N42 rare earth magnet remanent flux density
mu_r=1.05 ;         % magnet relative permeability
mu_st=750 ;         % relative permeability of electrical steel
coil2web_cl=0.015 ;     % winding to steel web clearence 
k_leak=0.965 ;      % leakage factor 
phi=0;              % assume unity power factor
strand=1 ;          % number of parallel strands in coil (taken as 1) 
t_epoxy=1 ;         % epoxy thickness on winding surface (in mm)
d_steel=7850 ;      % volumetric mass density of steel in kg/m^3
d_copper=8230 ;     % volumetric mass density of copper in kg/m^3
d_magnet=8400 ;     % volumetric mass density of permanent magnet in kg/m^3
d_epoxy=900;        % volumetric mass density of epoxy resin in kg/m^3
no_rotor_bar=8 ;    % number of rotor bars, taken as 8 
no_stator_bar=6 ;   % number of bar in torque arm of stator(opt) in both sides
shaft_ro=0.3 ;      % shaft outer radius from 
shaft_ri=0.1 ;      % shaft inner radius
uc_steel=3 ;        % unit cost of steel in �/kg
uc_copper=8 ;       % unit cost of copper in �/kg
uc_magnet=110 ;     % unit cost of magnet in �/kg
uc_epoxy=10 ;       % unit cost of epoxy in �/kg
%----------------------------End of initialization------------------------



%% Variable Control part

Np=round(Np/4)*4;   % fix number of poles at multiple of 4
fix=(Np*3)/(4*m);
while ne((fix/n_branch),round(fix/n_branch))        
    n_branch=n_branch-1;
end

if (n_branch>fix)||(n_branch<1)
    n_branch=1;
end

if pitch_ratio>(0.5-l_magnet/(4*r_mean))        %coil pitch ratio control
    pitch_ratio=(0.5-l_magnet/(4*r_mean))-0.01;
end
%------------End of variable control-------------------------
%%

%Adjustment for rpm,P_des,J

if multispeed==0
rpm=rpm*gear_ratio;
P_demand=(P_des*eff_gear)/n_stack;
J_final=J_opt;
end 

%--------------------------------------------------------------------------------------------------------------------------
%% Flux Density Parameters calculation (Airgap, Spacer and steel flux densities)

%% ----------Definition of the parameters/variables----------

% B_ag: flux density in air-gap 
% B_ag_nl: flux density in air-gap not included leakage flux
% NI: mmf
% Br: magnet remanent flux density of selected magnet (constant)
% phi_ag_nl: airgap flux not included leakage flux 
% S_st: steel reluctance 
% S_st_A: steel reluctance part A , S_st_C: steel reluctance part C  
% l_cl:magnet to steel web clearence , tau_pw: web pole pitch
% coil2web_cl: winding to steel web clearence (user defined variable)
% r_w: web radius
% S_sp: spacer reluctance
% inter_area: intermodule area , mu_st: steel relative permeability (constant)
% S_PM_o: top PM reluctance , S_ag: airgap reluctance 
% mu_r: magnet relative permeability (constant)
% B_sp: flux density in spacer(intermodule) 
% B_sp_nl: flux density in spacer(intermodule) not included leakage flux
% phi_sp_nl: spacer flux not included leakage
% A_sp_o: intermodule area
% B_st: flux density in steel(intramodule) 
% B_st_nl: flux density in steel(intramodule) not included leakage flux
% A_st: intramodule(web) area 
% phi_st_nl: steel flux not included leakage 

%% Calculation part

%----for air-gap region-------%

tau_p= r_mean*2*pi/Np ;
tau_c=tau_p*(4/3);
width_winding=pitch_ratio*tau_c; 
r_i= r_mean- l_magnet/2 ;
r_o= r_mean+ l_magnet/2 ; 
NI=Br*h_m/(mu_0*mu_r) ; 
magnet_width= width_ratio*tau_p;

S_ag=(h_w+2*g)/(l_magnet*magnet_width*mu_0) ; 
S_PM_o= h_m/(l_magnet*magnet_width*mu_0*mu_r)+0.5*t_o/(l_magnet*magnet_width*mu_0*mu_r) ; 
  
inter_area=t_o*l_magnet ;
S_sp=(tau_p/(inter_area*mu_0*mu_st))+(groove_c/(inter_area*mu_0)) ; 

l_cl= width_winding+coil2web_cl ; 
r_w=r_i-l_cl-lc ; 
tau_pw= 2*pi*r_w/Np ;  
S_st_A=(l_magnet+2*l_cl+lc)/(t_o*(tau_p+tau_pw)*mu_0*mu_st) ;  
S_st_C=(2*(h_m+g)+h_w+t_o)/(lc*tau_pw*mu_0*mu_st) ; 
S_st=2*S_st_A+S_st_C ;


phi_ag_nl=(S_sp+2*S_st)*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ; 
B_ag_nl= phi_ag_nl/magnet_width/l_magnet; 
B_ag=B_ag_nl;                   %flux density is calculated without leakage

%------end of airgap region flux density calculation----------------%


%-----for spacer region---------%

A_sp_o=t_i*l_magnet ; 

phi_sp_nl= S_st*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ;
B_sp_nl= phi_sp_nl/A_sp_o ; 
B_sp =B_sp_nl ;                 %flux density is calculated without leakage

%------ end of spacer region flux density calculation---------%


%-----for steel region---------%

A_st=tau_pw*lc ; 

phi_st_nl=S_sp*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ; 
B_st_nl=phi_st_nl/A_st ; 
B_st =B_st_nl ;                 %flux density is calculated without leakage

%------ end of steel region flux density calculation---------%
%----------------------------------------------------------------------------------------------------

%% [I_ph_rms] Current per phase(rms) calculation

%% ----------Definition of the parameters/variables----------

%I_coil : current in one coil
% J_final:curent density, a_cond=cross section area of the conductor 
% a_window: effective area of winding window
%h_w : height of the winding,  kf: fill factor(1 for concentrated windings)
%tau_p : pole pitch
%tau_c :coil pitch
% width_winding: width of the winding

%% Calculation part

width_winding=pitch_ratio*tau_c;
a_window=h_w*width_winding*kf; 
a_cond=a_window/Nt;  
I_coil=J_final*a_cond*1000000; 

I_ph_rms= I_coil*n_branch;  %%Resulting equation

%------------------------------------------------------------------------------------------------------------------------------


%% [V_ph_rms] Voltage per phase(rms) calculation

%% ----------Definition of the parameters/variables----------

% E_ph_rms: induced emf per phase(rms), lambda: load angle, phi: power factor angle, I_ph_rms: phase current(rms), R_ph_th: phase resistance(including thermal effects), X_ph: phase reactance value
% E_ph_peak: induced emf per phase(peak)
% e:induced emf of one turn,  Nt:number of turns in a coil, N_series: number of coils connnected in series
% v: air-gap linear speed, flux_lnk_peak : peak flux linkage 
% r_mean:mean radius, w_m : mechanical speed
% rpm : rotational speed(rpm)
% k_leak:leakage factor , magnet_h1:varying magnet pitch 1st harmonic,r_o: outside radius , r_i: inner radius, Np:number of poles, theta_o: outer arc length , theta_i:inner arc length, theta_dif: arc length differences  
% B_ag: Airgap flux density, width_ratio: Magnet/steel width ratio
% l_magnet: axial lenght of the magnet
% pitch_ratio: winding thickness/coil pitch ratio
% coil_phase:number of coils per phase, n_branch: number of parallel branches 
% Nc: number of coils, m: number of phases
% R_amb: resistance value at ambient temperature, alpha_Cu: temperature coefficent at 20 Celcius degree , dT: temperature difference
% R_coil: coil resistance
% rho_cu: copper resistivity coefficient, l_t: mean turn length 
% l_coil_end: coil end length, l_coil_middle: coil middle part length, l_coil_structure: coil structure part length  
% f: frequency
% k_ind: inductance coefficient(take 1 for leakage path assumption), flux_lnk: flux linkage
% B_a: flux density for inductance calculation
% mu_0: permeability of vacuum(constant=4*pi*10^-7) , l_ss: steel to steel distance
% l_mm: magnet to magnet gap

%% Calculation part

%winding temperature calculated here

bypass_1=(100-t_amb)/(J_final_type^2)*(J_final^2)+t_amb ;      %forced air cooling  last temperature 
t_winding=bypass_1 ;

if t_winding>179   
    temp_winding=179 ; 
else if t_winding <-179
    temp_winding=-179;
    else
    temp_winding=t_winding;
    end
end

dT= t_winding-t_amb ;    % temperature rise

Nc=(3/4)*Np ;
coil_phase=Nc/m; 
N_series=coil_phase/n_branch; 
theta_dif=width_winding/r_mean;  
theta_o= tau_c/r_mean/2;   
theta_i= theta_o-theta_dif; 

theta_dif=(theta_dif*180)/pi;  
theta_o= (theta_o*180)/pi;   
theta_i= (theta_i*180)/pi; 


l_mm=h_w+2*g ; 
l_ss=l_mm+2*(h_m-groove) ;  

a_window=h_w*width_winding*kf; 
a_cond=a_window/Nt;  

B_a=mu_0*Nt/l_ss ; 
flux_lnk=(2*B_a*Nt*((0.5*(r_o^2-r_i^2)*tand(theta_o))-(width_winding*l_magnet)))+(2*B_a*Nt*width_winding*l_magnet/3) ;  
k_ind=1; % constant
L_coil= k_ind*flux_lnk ; 
f=rpm/60*Np/2 ; 
w_e=2*pi*f ; 
X_ph=w_e*L_coil*(N_series/n_branch); 
l_coil_structure=(r_mean+0.5*(l_magnet+width_winding))*2*pi/Nc;
l_coil_middle=l_magnet+width_winding; 
l_coil_end=(r_mean-0.5*(l_magnet+width_winding))*2*pi/Nc; 
l_t=l_coil_end+2*l_coil_middle+l_coil_structure-2*width_winding; 
R_coil=rho_cu*l_t*Nt/a_cond; 
R_amb=R_coil*N_series/n_branch  ;
R_ph_th=R_amb*(1+alpha_Cu*dT); 
Z_ph=sqrt(R_ph_th^2+X_ph^2);
magnet_h1=(4/pi)*B_ag*sin(width_ratio*pi/2); 
flux_lnk_peak=k_leak*magnet_h1*(r_o^2-r_i^2)*(cosd(Np*theta_i/2)-cosd(Np*theta_o/2))/((theta_dif*pi/180)*((Np/2)^2)) ;  
w_m=(rpm*2*pi)/60 ; 
v=r_mean*w_m ; 
e=(v*flux_lnk_peak*pi)/tau_p ; 
E_ph_peak=e*Nt*N_series ;  
E_ph_rms=E_ph_peak/sqrt(2); 

if (I_ph_rms*(-R_ph_th*sind(phi)+X_ph*cosd(phi))/E_ph_rms)>1
    lambda=asind(1);
else
    lambda=asind((I_ph_rms*(-R_ph_th*sind(phi)+X_ph*cosd(phi))/E_ph_rms));
end
    
V_ph_rms = E_ph_rms*cosd(lambda)-I_ph_rms*(R_ph_th*cosd(phi)+X_ph*sind(phi)) ;  %%Resulting equation

%--------------------------------------------------------------------------------------------------------------------------

%--------------------------------------------------------------------------------------------------------------------------
%% [P_o] Power output calculation

%% ----------Definition of the parameters/variables----------

% V_ph_rms : Voltage per phase(rms)
% I_ph_rms : Current per phase(rms)
% m : number of phases 

%% Calculation part

P_o= m*V_ph_rms*I_ph_rms;           %Output power

%---------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Coil Electrical Parameters calculation

%% ----------Definition of the parameters/variables----------

% t_amb: ambient temperature
% temp_winding : resulting winding temperature
% t_winding: winding temperature (forced air cooling)
% L_phase : phase inductance

%% Calculation part

L_phase=L_coil*N_series/n_branch*1000 ;             %in mH

%----------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% [Eff] Efficiency calculation

%% ----------Definition of the parameters/variables----------

% coil_area_i : area of single coil with insulation
% t_coil_i: thickness of the coil with insulation , ins_area: insulation area per coil
% strand:number of parallel strands in coil (taken as 1)
% t_epoxy : epoxy thickness(taken as 1) , turn_strand : number of turns per strand
% h_coil_i: height of the copper with insulation, t_insulation: insulation thickness
% h_copper: heigth of the copper, t_copper: thickness of the copper 
% ag_loss: airgap flux eddy loss on coil, leakage_loss: leakage flux eddy loss on coil (taken as 0)                  
% eddy_coil: sum of eddy losses both for air-gap flux and leakage flux , eddy_magnet: eddy loss due to magnet
% P_copper_th: copper loss including thermal effects , P_eddy: eddy losses(coil+magnet)
% P_loss: total loss(copper+eddy)

%% Calculation part

turn_strand=Nt/strand ; 
h_coil_i=(h_w*1000-2*t_epoxy)/turn_strand ;
eddy_magnet= 57.65*l_magnet*magnet_width*Np*2 ; % eddy_magnet: magnet surface eddy current loss
leakage_loss=0  ;% constant
coil_area_i=(width_winding*1000-2*t_epoxy)*(h_w*1000-2*t_epoxy)/Nt ; 
ins_area=coil_area_i-a_cond*10^6 ;  
t_coil_i=(width_winding*1000-2*t_epoxy)/turn_strand ; 

if ((h_coil_i+t_coil_i)^2-(4*ins_area))>0    
    t_insulation=((h_coil_i+t_coil_i)-sqrt((h_coil_i+t_coil_i)^2-(4*ins_area)))/4;
else
    t_insulation=0;
end

h_copper=h_coil_i-2*t_insulation ;
t_copper=t_coil_i-2*t_insulation;
ag_loss=2*l_magnet*Nt*(((t_copper/2000)^3)*(B_ag^2)*(w_e^2))*(h_copper/1000)/(3*rho_cu*(1+alpha_Cu*dT)) ;  
eddy_coil= ag_loss+leakage_loss;  
P_eddy=eddy_coil*Nc+eddy_magnet; 
P_copper_th=m*(I_ph_rms*I_ph_rms)*R_ph_th ; 
P_loss=P_copper_th+P_eddy ; 

Eff=P_o/(P_o+P_loss) ; %%Resulting equation

if (Eff<0.9)
   penalty_eff=((abs(0.9-Eff)^2)*100000) ;
end

%---------------------------------------------------------------------------------------------------------------------------

%--------------------------------------------------------------------------------------------------------------------------
%% Component mass calculation 

%% ----------Definition of the parameters/variables----------

% total_mass: total mass of the machine, mass_epoxy: epoxy resin mass
% m_epoxy_single: epoxy mass in single coil unit
% tau_former:pitch of the coil former mean value, d_epoxy: volumetric mass density of epoxy resin(taken as constant)
% mass_structure: total structural mass, m_shaft: shaft mass, m_stator: stator structure mass, m_rotor: rotor torque structure mass, m_steelband: steel band mass   
% h_band:height of the band steel structure(opt),w_band: width of the band steel structure(opt) 
% shaft_ro: shaft outer radius(opt), shaft_ri: shaft inner radius(opt), l_shaft: axial length of the shaft
% length_total: total axial length of the machine
% m_stator_cyl: stator cylinder structure mass, m_stator_torque: stator torque structure mass
% stator_alternative_a: alternative solution for stator rectangle paramater a, stator_alternative_t: alternative solution for stator rectangle paramater a 
% no_stator_bar: number of bar in torque arm of stator(opt),stator_rect_b: stator torque arm dimensions,stator_rect_bi:stator torque arm dimensions,stator_rect_d:stator torque arm dimensions,stator_rect_di:stator torque arm dimensions, length_stator_bar: length of stator bar, 
% stator_outer: stator outer diameter
% m_rotor_torque: rotor torque structure mass
% stator_alternative_a: alternative solution for stator rectangle paramater a, stator_alternative_t: alternative solution for stator rectangle paramater a 
% m_magnet_layer: mass of magnet in a layer, number_magnet_layer:layer number of magnet 
% magnets exist both sides of c-core
% m_copper_layer: mass of copper in a layer
% m_copper_unit: mass of copper in one coil
% d_copper: volumetric mass density of copper(taken as constant)
% mass_steel: steel mass, m_outerlimb_layer: mass of outer limb in single layer, number_outer_limb: number of outer limb layer, m_innerlimb_layer: mass of inner limb in a single layer,number_inner_limb: number of inner limb layer, m_web_layer: mass of web in a single layer,number_web : number of web layer   
% d_steel:volumetric mass density of steel(taken as constant)
% layer number of outer limb is constant(taken as 2 because of geometry) independent from inner limb number
% n_stack:number of axially stacked parallel machines(determined in optimization-constant)
% h_web: height of web
% no_rotor_bar: number of rotor bars, taken as 8 for both end torque arm structure


%% Active mass calculation part

%In this part; steel mass, copper mass and magnet mass are calculated

number_web=n_stack ; 
h_web=l_mm+2*(h_m-groove); 
m_web_layer=pi*d_steel*t_i*((r_w+lc)^2-r_w^2)*h_web ; 
number_inner_limb=n_stack-1 ; 
m_innerlimb_layer=pi*d_steel*t_i*(r_o^2-r_w^2) ;
number_outer_limb=2 ;               %
m_outerlimb_layer=pi*d_steel*t_o*(r_o^2-r_w^2) ; 
mass_steel = m_outerlimb_layer*number_outer_limb+m_innerlimb_layer*number_inner_limb+m_web_layer*number_web ; 

m_copper_unit=h_w*width_winding*l_t*kf*d_copper ; 
m_copper_layer=m_copper_unit*Nc ; 
mass_copper=m_copper_layer*n_stack; 

number_magnet_layer=2*n_stack ; 
m_magnet_layer=pi*d_magnet*h_m*(r_o^2-r_i^2)*l_magnet ;
mass_magnet=m_magnet_layer*number_magnet_layer ; 

%% Structural mass calculation part
length_total=1.25*(2*t_o+n_stack*l_ss+(n_stack-1)*t_i) ; 

length_rotor_bar=r_w ;  
rotor_alternative_a=length_rotor_bar*0.032 ; 
rotor_alternative_t=rotor_alternative_a*0.5 ;
rotor_rect_b=rotor_alternative_a;
rotor_rect_bi=rotor_alternative_a-2*rotor_alternative_t ; 
rotor_rect_d=3*rotor_alternative_a ; 
rotor_rect_di=rotor_rect_d-2*rotor_alternative_t ;
m_rotor_torque=no_rotor_bar*(rotor_rect_b*rotor_rect_d-rotor_rect_di*rotor_rect_bi)*length_rotor_bar*d_steel ; 
m_rotor=2*m_rotor_torque;   

stator_outer=2*(r_o+2*width_winding) ;         %stator outer diameter
length_stator_bar=0.5*stator_outer ;  
stator_alternative_a=length_stator_bar*0.025 ; 
stator_alternative_t=stator_alternative_a*0.4 ;
stator_rect_b=stator_alternative_a;
stator_rect_bi=stator_alternative_a-2*stator_alternative_t ; 
stator_rect_d=3*stator_alternative_a ; 
stator_rect_di=stator_rect_d-2*stator_alternative_t ; 
m_stator_torque=no_stator_bar*(stator_rect_b*stator_rect_d-stator_rect_di*stator_rect_bi)*length_stator_bar*d_steel ; 
m_stator_cyl=pi*d_steel*length_total*((r_o+width_winding)^2-r_o^2);
m_stator=m_stator_cyl+m_stator_torque*2 ; 

l_shaft=length_total; 
m_shaft=pi*(shaft_ro^2-shaft_ri^2)*l_shaft*d_steel ; 

m_steelband=n_stack*(2*pi*(r_o+0.5*width_winding)*h_band*w_band*d_steel) ; 

tau_former=tau_c-2*width_winding ; 
m_epoxy_single=(l_t*width_winding*(1-kf)+tau_former*l_magnet)*h_w*d_epoxy ; 
mass_epoxy=m_epoxy_single*Nc;

mass_structure=m_shaft+m_stator+m_rotor+m_steelband+mass_epoxy ;

%-------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Material Cost calculation 

%% ----------Definition of the parameters/variables----------

%cost_structure: total structural cost including epoxy, uc_epoxy: unit cost of epoxy(constant)
%cost_magnet: total magnet cost, uc_magnet: unit cost of magnet(constant)
%cost_copper: total copper cost, uc_copper: unit cost of copper(constant)
% cost_steel: total steel cost , uc_steel: unit cost of steel(constant)

%% Calculation part

cost_steel=mass_steel*uc_steel ; 
cost_copper=mass_copper*uc_copper ; 
cost_magnet=mass_magnet*uc_magnet; 
cost_structure=(mass_structure-mass_epoxy)*uc_steel+mass_epoxy*uc_epoxy ; 

total_cost=cost_steel+cost_copper+cost_magnet+cost_structure;           %total cost of the generator according to material costs
%--------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Thermal Model and Calculations

% ----------Definition of the parameters/variables----------

% bypass thermal model 


 

%--------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------


%% Structural Model and Calculations

%% ----------Definition of the parameters/variables----------

% beam_y_percent: percent value of deflection in beam model with respect to airgap clearence
% beam_y: total deflection in beam model
% beam_y2: deflection according to submodel-2
% beam_y1: deflection according to submodel-1, youngm: Young's Modulus(constant)
% beam_a2: magnet axial length along the beam (submodel-2)
% beam_a1: zero length assumption along the beam (submodel-1)
% L_beam=beam length
% I_beam: second moment of inertia
% udl: uniformly distributed load 
% q : normal stress

%% Calculation part

% beam model

q=(B_ag^2)/(2*mu_0) ; 
udl=q*tau_p ; 
I_beam=tau_p*(t_o^3)/12 ; 
L_beam=l_magnet+l_cl ; 
beam_a1= 0 ;
beam_a2=l_magnet ; 
youngm=2E11 ; 
beam_y1=-udl*((L_beam-beam_a1)^3)*(3*L_beam+beam_a1)/(24*I_beam*youngm) ; 
beam_y2=udl*((L_beam-beam_a2)^3)*(3*L_beam+beam_a2)/(24*I_beam*youngm) ; 
beam_y=beam_y1+beam_y2 ; 
beam_y_percent=abs(beam_y)/g ; 

if (beam_y_percent>10)
   penalty_deflection=((abs(10-beam_y_percent)^2)*100000) ;
end

%% Current density part

J_init=P_demand/(3*E_ph_rms*a_cond*1000000*n_branch);

if E_ph_rms/2*Z_ph*a_cond*1000000*n_branch>0
    J_pmax=2*Z_ph*a_cond*1000000*n_branch;
else
    J_pmax=0;
end

%%
cost_f=total_cost+penalty_eff+penalty_deflection;   
J_final_f=J_final;
J_init_f=J_init;
J_pmax_f=J_pmax;
P_demand_f=P_demand;
P_net_f=(P_o+P_loss);
n_stack_f=n_stack;
end