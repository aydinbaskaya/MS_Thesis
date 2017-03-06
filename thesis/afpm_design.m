%%%%%Axial Flux PM Generator Design Equations%%%%%
%----------------------------------------------------------------------


%-------------------------------------------------------------------------------------------------------
%% [V_ph_rms] Voltage per phase(rms) calculation

%% ----------Definition of the parameters/variables----------
% E_ph_rms: induced emf per phase(rms), lamda: load angle, phi: power factor angle, I_ph_rms: phase current(rms), R_ph_th: phase resistance(included thermal effects), X_ph: phase reactance value
% E_ph_peak: induced emf per phase(peak)
% e:induced emf of one turn,  Nt:number of turns in a coil, N_series: number of coils connnected in series
% v: air-gap linear speed, flux_lnk_peak : peak flux linkage , tau_p : pole pitch
% r_mean:mean radius, w_m : mechanical speed
% rpm rotational speed(rpm)
% k_leak:leakage factor , magnet_h1:varying magnet pitch 1st harmonic,r_o: outside radius , r_i: inner radius, Np:number of poles, theta_o: outer arc length , theta_i:inner arc length, theta_dif: arc length differences  
% B_ag: Airgap flux density, width_ratio: Magnet/steel width ratio
% l_magnet: axial lenght of the magnet
% tau_c :coil pitch
% width_winding: width of the winding
% pitch_ratio: winding thickness/coil pitch ratio
% coil_phase:number of coils per phase, n_branch: number of parallel branches 
% Nc: number of coils, m: number of phases

%% Calculation part
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
