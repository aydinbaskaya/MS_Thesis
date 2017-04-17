function result = total_mass(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%
%----------------------------------------------------------------------

%included in optimization
r_mean=x(1);
g=x(2);
J=x(3);
t_o=x(4);
t_i=x(5);
lc=x(6);
width_ratio=x(7);
Nt=x(8);
Np=x(9);
n_branch=x(10);
h_w=x(11);
pitch_ratio=x(12);
kf=x(13);
h_m=x(14);
l_magnet=x(15);
number_parallel_mach=x(16);

%not included in optimization
rpm=12 ;
groove=0 ;
m=3; 
B_opt=1.3;

%% Definitions in optimization part(user defined variables/constraints)

% r_mean : mean radius (m)
% g: air-gap clearence (m)
% rpm : rotational speed(rpm)

% J : curent density (A/mm^2)

% t_o : outer limb thickness (m)
% t_i : inner limb thickness (m)
% lc : steel web (m)
% groove : space between c-cores(take 0 for this design) (m)
% groove_c : gap between modules (m)

% Nt : number of turns in a coil
% Np : number of poles
% n_branch : number of parallel branches
% m : number of phases

% h_w : height of the winding (m)
% pitch_ratio: winding thickness/coil pitch ratio 
% kf: fill factor(1 for concentrated windings)

% h_m : height of the magnet (m)
% l_magnet : axial lenght of the magnet (m)
% width_ratio: Magnet/steel width ratio 
% B_opt : Desired remanent flux density for the magnet (T)
% t_amb : ambient temperature (oC)
% air_flow : air flow (m^3/sec)
% number_parallel_mach : number of parallel machines stacked axiall(h_w)y

%-------------------------------------------------------------------------------------------------------


%% CONSTANTS 

% Natural air Cooling for J=5.5 A/mm^2
% Forced air cooling for J=7 A/mm^2
% Forced water cooling for J=9 A/mm^2

% thermal constants(from optimization)

alpha_Cu=3.9-E03 ;
rho_cu=1.7-E08;
a_bar=40; %heat transfer coefficient(?) in W/m^2.K
a_stat=25; %heat transfer coefficient(?) in W/m^2.K
a_conc=60; %heat transfer coefficient(?) in W/m^2.K
lambda_steel=54; %lambda_steel: thermal conductivity of steel in W/m.K
lambda_alum=250; % lambda_alum: thermal conductivity of aluminium in W/m.K
lambda_cu_coil=400; % lambda_cu_coil: thermal conductivity of copper along coil in W/m.K
lambda_cu_ver=1.8; % lambda_cu_ver: thermal conductivity of copper in vertical in W/m.K
lambda_epoxy=1.3; % lambda_epoxy:thermal conductivity of epoxy in W/m.K 
lambda_pm=9; % lambda_pm: lambda_pm:thermal conductivity of PM in W/m.K
k=0.262; % k: thermal conductiviy of air in W/m.K
alpha_ep2air=40 ; % alpha_ep2air: epoxy to air heat transfer coefficient in W/m^2.K
alpha_st2air=40 ; % alpha_st2air: steel to air heat transfer coefficient in W/m^2.K
alpha_alum2air=40 ;% alpha_alum2air: aluminium to air heat transfer coefficient in W/m^2.K
h_epoxy=0.0005 ; % h_epoxy: height of the epoxy layer
h_band=0.01 ; % h_band: height of steel band(jubilee clip)
w_band=0.04; % w_band: axial width of the steel band
t_disc=?? ... continue   
mu_0=1.257E-06 ; % constant

%--------------------------------------------------------------------------------------------------------------------------


%% [I_ph_rms] Current per phase(rms) calculation

%% ----------Definition of the parameters/variables----------

%I_coil : current in one coil
% J:curent density, a_cond=cross section area of the conductor 
% a_window: effective area of winding window
%h_w : height of the winding,  kf: fill factor(1 for concentrated windings)

%% Calculation part

tau_p= r_mean*2*pi/Np ; 
tau_c=tau_p*(4/3);
width_winding=pitch_ratio*tau_c;
a_window=h_w*width_winding*kf; 
a_cond=a_window/Nt;  
I_coil=J*a_cond*1000000; 

I_ph_rms= I_coil*n_branch;  %%Resulting equation

%------------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Flux Density Parameters calculation (Airgap, Spacer and steel flux densities)

%% ----------Definition of the parameters/variables----------

% B_ag: flux density in air-gap , B_ag_l: flux density in air-gap included leakage flux
% B_ag_nl: flux density in air-gap not included leakage flux
% leakage_insert : adjustment for enable leakage flux effect i.e leakage_insert=1---> leakage flux enabled in calculation otherwise not enabled
% NI: mmf
% Br: magnet remanent flux density (constant)
% phi_ag_nl: airgap flux not included leakage flux
% phi_ag_l: airgap flux included leakage(first row of flux_l matrix) , magnet_width : magnet width 
% R: reluctance matrix
% inverse_R: inverse of reluctance matrix[2x2] , tot_mmf_matrix: total mmf matrix[2x1] , flux_l: flux matrix included leakage effect 
% S_st: steel reluctance 
% S_st_A: steel reluctance part A , S_st_C: steel reluctance part C  
% l_cl:magnet to steel web clearence , tau_pw: web pole pitch
% l_ws_web: winding to steel web clearence (user defined variable)
% r_w: web radius
% S_sp: spacer reluctance
% inter_area: intermodule area , mu_st: steel relative permeability (constant)
% S_PM_o: top PM reluctance , S_ag: airgap reluctance ,S_I: flux leakage included reluctance 
% SI_1: reluctance matrix part one, SI_2: reluctance matrix part two
% mu_r: magnet relative permeability (constant)
% B_sp: flux density in spacer(intermodule) , B_sp_l: flux density in spacer included leakage flux
% B_sp_nl: flux density in spacer(intermodule) not included leakage flux
% phi_sp_nl: spacer flux not included leakage
% phi_sp_l: spacer flux included leakage (second row of flux_l matrix )
% A_sp_o: intermodule area
% B_st: flux density in steel(intramodule) , B_st_l: flux density in steel included leakage flux
% B_st_nl: flux density in steel(intramodule) not included leakage flux
% phi_st_l : steel flux included leakage , A_st: intramodule(web) area 
% phi_st_nl: steel flux not included leakage 

%% Calculation part

%----for air-gap region-------%

r_i= r_mean- l_magnet/2 ;
r_o= r_mean+ l_magnet/2 ; 
NI=Br*h_m/(mu_0*mu_r) ; 
magnet_width= width_ratio*tau_p;
SI_2= pi/(2*l_magnet*mu_0) ; 
SI_1=(tau_p-magnet_width)/(mu_0*l_magnet*(0.5*h_w+g+h_m-groove)) ;  
S_I=SI_1+SI_2 ;  
S_ag=(h_w+2*g)/(l_magnet*magnet_width*mu_0) ; 
S_PM_o= h_m/(l_magnet*magnet_width*mu_0*mu_r)+0.5*t_o/(l_magnet*magnet_width*mu_0*mu_r) ; 

R(1,1)=2*S_PM_o*(1+2*S_ag/S_I)+S_ag ;  

inter_area=t_o*l_magnet ;
S_sp=(tau_p/(inter_area*mu_0*mu_st))+(groove_c/(inter_area*mu_0)) ; 

R(1,2)= S_sp ;  

l_cl= width_winding+l_ws_web ; 
r_w=r_i-l_cl-lc ; 
diameter_web=r_w;
tau_pw= 2*pi*r_w/Np ;  
S_st_A=(l_magnet+2*l_cl+lc)/(t_o*(tau_p+tau_pw)*mu_0*mu_st) ;  
S_st_C=(2*(h_m+g)+h_w+t_o)/(lc*tau_pw*mu_0*mu_st) ; 
S_st=2*S_st_A+S_st_C ; 
R(2,1) = R(1,1)+(1+2*S_ag/S_I)*S_st ; 
R(2,2)=-2*S_st ; 

inverse_R = inv(R);  
flux_l= inverse_R*tot_mmf_matrix ; 

phi_ag_l= flux_l(1,:) ; 
B_ag_l= phi_ag_l/l_magnet/magnet_width ; 

phi_ag_nl=(S_sp+2*S_st)*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ; 
B_ag_nl= phi_ag_nl/magnet_width/l_magnet; 

if (leakage_insert==1)  
    B_ag=B_ag_l ;  
else
    B_ag=B_ag_nl; 
end

%------end of airgap region flux density calculation----------------%

%-----for spacer region---------%

A_sp_o=t_i*l_magnet ; 

phi_sp_nl= S_st*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ;
B_sp_nl= phi_sp_nl/A_sp_o ; 

phi_sp_l=flux_l(2,:) ; % 
B_sp_l=phi_sp_l/A_sp_o ; 

if (leakage_insert==1)  
    B_sp =B_sp_l ;  
else
    B_sp =B_sp_nl ; 
end

%------ end of spacer region flux density calculation---------%

%-----for steel region---------%

A_st=tau_pw*lc ; 

phi_st_nl=S_sp*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ; 
B_st_nl=phi_st_nl/A_st ; 


phi_st_l=phi_ag_l*(1+2*S_ag/S_I)-2*phi_sp_l ; 
B_st_l=phi_st_l/A_st ;  

if (leakage_insert==1)  
    B_st =B_st_l ;  
else
    B_st =B_st_nl ; 
end

%------ end of steel region flux density calculation---------%
%----------------------------------------------------------------------------------------------------


%----------------------------------------------------------------------------------------------------
%% [V_ph_rms] Voltage per phase(rms) calculation

%% ----------Definition of the parameters/variables----------

% E_ph_rms: induced emf per phase(rms), lamda: load angle, phi: power factor angle, I_ph_rms: phase current(rms), R_ph_th: phase resistance(including thermal effects), X_ph: phase reactance value
% E_ph_peak: induced emf per phase(peak)
% e:induced emf of one turn,  Nt:number of turns in a coil, N_series: number of coils connnected in series
% v: air-gap linear speed, flux_lnk_peak : peak flux linkage , tau_p : pole pitch
% r_mean:mean radius, w_m : mechanical speed
% rpm : rotational speed(rpm)
% k_leak:leakage factor , magnet_h1:varying magnet pitch 1st harmonic,r_o: outside radius , r_i: inner radius, Np:number of poles, theta_o: outer arc length , theta_i:inner arc length, theta_dif: arc length differences  
% B_ag: Airgap flux density, width_ratio: Magnet/steel width ratio
% l_magnet: axial lenght of the magnet
% tau_c :coil pitch
% width_winding: width of the winding
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

Nc=(3/4)*Np ;
coil_phase=Nc/m; 
N_series=coil_phase/n_branch; 
width_winding=pitch_ratio*tau_c; 
theta_dif=width_winding/r_mean;  
theta_o= tau_c/r_mean/2;   
theta_i= theta_o-theta_dif; 

l_mm=h_w+2*g ; 
l_ss=l_mm+2*(h_m-groove) ;  

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
magnet_h1=1.27324*B_ag*sind(width_ratio*pi/2); 
flux_lnk_peak=k_leak*magnet_h1*(r_o^2-r_i^2)*(cosd(Np*theta_i/2)-cosd(Np*theta_o/2))/(theta_dif*((Np/2)^2)) ;  
w_m=(rpm*2*pi)/60 ; 
v=r_mean*w_m ; 
e=(v*flux_lnk_peak*pi)/tau_p ; 
E_ph_peak=e*Nt*N_series ;  
E_ph_rms=E_ph_peak/sqrt(2); 

V_ph_rms = E_ph_rms*cosd(lambda)-I_ph_rms(R_ph_th*cosd(phi)+X_ph*sind(phi)) ;  %%Resulting equation

%--------------------------------------------------------------------------------------------------------------------------





%--------------------------------------------------------------------------------------------------------------------------
%% [P_o] Power output calculation

%% ----------Definition of the parameters/variables----------

% V_ph_rms : Voltage per phase(rms)
% I_ph_rms : Current per phase(rms)
% m : number of phases 

%% Calculation part

P_o= m*V_ph_rms*I_ph_rms; %%Resulting equation

%---------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% [Eff] Efficiency calculation

%% ----------Definition of the parameters/variables----------

% coil_area_i : area of single coil with insulation
% t_coil_i: thickness of the coil with insulation , ins_area: insulation area per coil
% strand:number of parallel strands in coil (taken as 1)
% t_epoxy : epoxy thickness(taken as 1) , turn_strand : number of turns per strand
% h_coil_i: height of the copper with insulation, t_insulation: insulation thickness
% h_copper: heigth of the copper 
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
ag_loss=2*l_magnet*Nt*(((l_magnet/2000)^3)*(B_ag_l^2)*(w_e^2))*(h_copper/1000)/(3*rho_cu*(1+alpha_Cu*dT)) ;  
eddy_coil= ag_loss+leakage_loss;  
P_eddy=eddy_coil*Nc+eddy_magnet; 
P_copper_th=m*(I_ph_rms*I_ph_rms)*R_ph_th ; 
P_loss=P_copper_th+P_eddy ; 

Eff=P_o/(P_o+P_loss) ; %%Resulting equation

%---------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Coil Electrical Parameters calculation

%% ----------Definition of the parameters/variables----------

% t_amb: ambient temperature
% temp_winding : resulting winding temperature
% t_winding: winding temperature (forced air cooling)
% L_phase : phase inductance

%% Calculation part

L_phase=L_coil*N_series/n_branch*1000 ; 

%winding temperature calculated here

bypass_1=(100-t_amb)/5.5^2*(J^2)+t_amb ;
bypass_2=(100-t_amb)/49*(J^2)+t_amb ;  
bypass_3=(100-t_amb)/81*(J^2)+t_amb ;

if(J==5.5)
    t_winding=bypass_1 ;
elseif(J==7)
    t_winding=bypass_2 ;
elseif(J==9)
    t_winding=bypass_3 ;
end

if t_winding>179   
    temp_winding=179 ; 
else if t_winding <-179
    temp_winding=-179;
    else
    temp_winding=t_winding;
    end
end

%----------------------------------------------------------------------------------------------------





%--------------------------------------------------------------------------------------------------------------------------
%% Component mass calculation 

%% ----------Definition of the parameters/variables----------

% total_mass: total mass of the machine, mass_epoxy: epoxy resin mass
% m_epoxy_single: epoxy mass in single coil unit
% tau_former:pitch of the coil former mean value, d_epoxy: volumetric mass density of epoxy resin(taken as constant)
%mass_structure: total structural mass, m_shaft: shaft mass, m_stator: stator structure mass, m_rotor: rotor torque structure mass, m_steelband: steel band mass   
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
% number_parallel_mach:number of axially stacked parallel machines(determined in optimization-constant)
% h_web: height of web

%% Active mass calculation part

%In this part; steel mass, copper mass and magnet mass are calculated

number_web=number_parallel_mach ; 
h_web=l_mm+2*(h_m-groove); 
m_web_layer=pi*d_steel*t_i*((r_w+lc)^2-r_w^2)*h_web ; 
number_inner_limb=number_parallel_mach-1 ; 
m_innerlimb_layer=pi*d_steel*t_i*(r_o^2-r_w^2) ;
number_outer_limb=2 ;
m_outerlimb_layer=pi*d_steel*t_o*(r_o^2-r_w^2) ; 
mass_steel = m_outerlimb_layer*number_outer_limb+m_innerlimb_layer*number_inner_limb+m_web_layer*number_web ; 

m_copper_unit=h_w*width_winding*l_t*kf*d_copper ; 
m_copper_layer=m_copper_unit*Nc ; 
mass_copper=m_copper_layer*number_parallel_mach; 

number_magnet_layer=2*number_parallel_mach ; 
m_magnet_layer=pi*d_magnet*h_m*(r_o^2-r_i^2)*l_magnet ;
mass_magnet=m_magnet_layer*number_magnet_layer ; 

%% Structural mass calculation part
length_total=2*t_o+number_parallel_mach*l_ss+(number_parallel_mach-1)*t_i ; 

length_rotor_bar=r_w ;  
rotor_alternative_a=length_rotor_bar*0.032 ; 
rotor_alternative_t=rotor_alternative_a*0.5 ;
rotor_rect_b=rotor_alternative_a;
rotor_rect_bi=rotor_alternative_a-2*rotor_alternative_t ; 
rotor_rect_d=3*rotor_alternative_a ; 
rotor_rect_di=rotor_rect_d-2*rotor_alternative_t ;
m_rotor_torque=no_rotor_bar*(rotor_rect_b*rotor_rect_d-rotor_rect_di*rotor_rect_bi)*length_rotor_bar*d_steel ; 
m_rotor=2*m_rotor_torque;   

stator_outer=2*(r_o+2*r_w) ; 
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

l_shaft=1.25*length_total; 
m_shaft=pi*(shaft_ro^2-shaft_ri^2)*l_shaft*d_steel ; 

m_steelband=number_parallel_mach*(2*pi*(r_o+0.5*r_w)*h_band*w_band*d_steel) ; 

mass_structure=m_shaft+m_stator+m_rotor+m_steelband ;

tau_former=tau_c-2*width_winding ; 
m_epoxy_single=(l_t*width_winding*(1-kf)+tau_former*l_magnet)*h_w*d_epoxy ; 
mass_epoxy=m_epoxy_single*Nc; 

total_mass=mass_structure+mass_epoxy+mass_magnet+mass_copper+mass_steel; %%Resulting total mass equation

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
cost_structure=mass_structure*uc_steel+mass_epoxy*uc_epoxy ; 

%--------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Thermal Model and Calculations

%% ----------Definition of the parameters/variables----------

% bypass thermal model 



% airgap inputs(from optimization)~at 20o C

af_coil=0.05; % af_coil: airflow over coil in m^3/sec
kin_vis=1.51E-5 ; % kin_vis: kinematic viscosity of air in m^2/s
d_air=1.205 ; % d_air: density of air in kg/m^3
dyn_vis=1.82E-5;  % dyn_vis: dynamic viscosity of air in kg/ms
prandtl_air=0.713 ; % prandtl_air: Prandtl number of air
lambda_air=0.0257; % thermal conductivity of air in W/m.K
heatc_air=1005; % heatc_air: heat capacitance of air in J/kgK

%% Calculation part

%thermal resistance parameters

epoxy_s=0.5*h_epoxy*(lambda_epoxy*l_coil_structure*(4*width_winding+h_w));
rad_cop_s=0.5*h_w*(lambda_cu_ver*l_coil_structure*(4*width_winding+h_w));
R_rad_s=rad_cop_s+epoxy_s; % R_rad_s: thermal resistance of the structure part, rad_cop_s: copper part of thermal resistance at structure, epoxy_s: epoxy part of thermal resistance at structure 

epoxy_m=0.5*h_epoxy*(lambda_epoxy*l_coil_middle*width_winding);
copper_m=0.5*h_w*(lambda_cu_ver*l_coil_middle*width_winding);
R_rad_m=0.25*(copper_m+epoxy_m); % R_rad_m: thermal resistance of the middle coil part, copper_m: copper part of thermal resistance at middle coil,epoxy_m: epoxy part of thermal resistance at middle coil 

epoxy_e=0.5*h_epoxy*(lambda_epoxy*l_coil_end*(2*width_winding+h_w)) ;
rad_cop_e=0.5*h_w*(lambda_cu_ver*l_coil_end*(2*width_winding+h_w)) ; 
R_rad_e=rad_cop_e+epoxy_e ; % R_rad_e: thermal resistance of the radial end coil part , rad_cop_e: copper part of thermal resistance at end coil,epoxy_e: epoxy part of thermal resistance at end coil  

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

%--------------------------------------------------------------------------------------------------------------------------

result=total_mass; 
