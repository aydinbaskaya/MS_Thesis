%%%%%Axial Flux PM Generator Design Equations%%%%%
%----------------------------------------------------------------------


%% Variables defined in optimization part(user defined variables/constraints)

% r_mean : mean radius
% g: air-gap clearence 
% rpm : rotational speed(rpm)

% J : curent density

% t_o : outer limb thickness
% t_i : inner limb thickness
% lc : steel web 
% groove : space between c-cores
% groove_c : gap between modules

% Nt : number of turns in a coil
% Np : number of poles
% n_branch : number of parallel branches
% m : number of phases

% h_w : height of the winding
% pitch_ratio: winding thickness/coil pitch ratio 
% kf: fill factor(1 for concentrated windings)

% h_m : height of the magnet
% l_magnet : axial lenght of the magnet
% width_ratio: Magnet/steel width ratio 
% B_opt : Desired remanent flux density for the magnet
% t_amb : ambient temperature

%-------------------------------------------------------------------------------------------------------


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
% rho: copper resistivity coefficient, l_t: mean turn length 
% l_coil_end: coil end length, l_coil_middle: coil middle part length, l_coil_structure: coil structure part length  
% f: frequency
% k_ind: inductance coefficient(take 1 for no leakage path assumption), flux_lnk: flux linkage
% B_a: flux density for inductance calculation
% mu_0: permeability of vacuum=constant , l_ss: steel to steel distance
% l_mm: magnet to magnet gap,h_m: height of the magnet , groove: space between c-cores(take 0 for this design)
% h_w: height of the winding, g: air-gap clearence

%% Calculation part

l_mm=h_w+2*g ; 
l_ss=l_mm+(h_m-groove) ;  
mu_0=1.257E-06 ; 
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
R_coil=rho*l_t*Nt/a_cond; 
R_amb=R_coil*N_series/n_branch  ;
R_ph_th=R_amb*(1+alpha_Cu*dT); 
coil_phase=Nc/m; 
N_series=coil_phase/n_branch; 
width_winding=pitch_ratio*tau_c; 
theta_dif=width_winding/r_mean;  
tau_p= r_mean*2*pi/Np ; 
tau_c=tau_p*(4/3);
theta_o= tau_c/r_mean/2;   
theta_i= theta_o-theta_dif; 
r_i= r_mean- l_magnet/2 ;
r_o= r_mean+ l_magnet/2 ;  
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
%% [I_ph_rms] Current per phase(rms) calculation

%% ----------Definition of the parameters/variables----------

%I_coil : current in one coil
% J:curent density, a_cond=cross section area of the conductor 
% a_window: effective area of winding window
%h_w : height of the winding,  kf: fill factor(1 for concentrated windings)

%% Calculation part

width_winding=pitch_ratio*tau_c;
a_window=h_w*width_winding*kf; 
a_cond=a_window/Nt;  
I_coil=J*a_cond*1000000; 

I_ph_rms= I_coil*n_branch;  %%Resulting equation

%------------------------------------------------------------------------------------------------------------------------------


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

turn_strand=Nt/strand ; 
h_coil_i=(h_w*1000-2*t_epoxy)/turn_strand ;   
h_copper=h_coil_i-2*t_insulation ;  
ag_loss=2*l_magnet*Nt*(((l_magnet/2000)^3)*(B_ag_l^2)*(w_e^2))*(h_copper/1000)/(3*rho*(1+alpha_Cu*dT)) ;  
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

if t_winding>179   
    temp_winding=179 ; 
else if t_winding <-179
    temp_winding=-179;
    else
    temp_winding=t_winding;
    end
end

t_winding=(100-t_amb)/49*(J^2)+t_amb ;  

%----------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Flux Density Parameters calculation (Airgap, Spacer and steel flux densities)

%% ----------Definition of the parameters/variables----------

% B_ag: flux density in air-gap , B_ag_l: flux density in air-gap included leakage flux
% B_ag_nl: flux density in air-gap not included leakage flux
% leakage_insert : adjustment for enable leakage flux effect i.e leakage_insert=1---> leakage flux enabled in calculation otherwise not enabled
% NI: mmf
% Br: magnet remanent flux density (constant)
% phi_ag_nl: airgap flux not included leakage flux
% phi_ag_l: airgap flux included leakage , magnet_width : magnet width (first row of flux_l matrix)
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

r_w=r_i-l_cl-lc ; 
tau_pw= 2*pi*r_w/Np ;  
l_cl= width_winding+l_ws_web ; 
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

phi_sp_nl= S_sp*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ;
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

phi_st_nl=S_st*NI/(S_st*(2*S_PM_o+S_ag+0.5*S_sp)+0.5*(S_sp*(2*S_PM_o+S_ag))) ; 
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



