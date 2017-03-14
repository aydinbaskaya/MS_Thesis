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
flux_lnk=(2*B_a*Nt*((0.5*(r_o^2-r_i^2)*tand(theta_o))-(width_winding*l_magnet)))+(2*B_a*Nt*width_winding*l_magnet/3)  
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
R_amb=R_coil*N_series/n_branch  
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

%ag_loss: airgap eddy loss content, leakage_loss: leakage eddy loss content
% eddy_coil: sum of eddy losses both for air-gap flux and leakage flux , eddy_magnet: eddy loss due to magnet
% P_copper_th: copper loss including thermal effects , P_eddy: eddy losses(coil+magnet)
% P_loss: total loss(copper+eddy)

%% Calculation part

eddy_magnet= ... continue
leakage_loss=0 % constant
ag_loss= ...  continue
eddy_coil=ag_loss+leakage_loss;  
P_eddy=eddy_coil*Nc+eddy_magnet; 
P_copper_th=m*(I_ph_rms*I_ph_rms)*R_ph_th ; 
P_loss=P_copper_th+P_eddy ; 
Eff=P_o/(P_o+P_loss) ; %%Resulting equation

%---------------------------------------------------------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------
%% Coil Electrical Parameters calculation

%% ----------Definition of the parameters/variables----------


%% Calculation part

L_phase=L_coil*N_series/n_branch*1000 ; % L_phase : phase inductance




