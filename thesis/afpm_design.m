%%%%%Axial Flux PM Generator Design Equations%%%%%
% 
% Voltage per phase(rms) calculation
flux_lnk_peak=k_leak*magneth_1*(r_o^2-r_i^2)*(cosd(Np*theta_o/2)-cosd(Np*theta_i/2))/(theta_dif*((Np/2)^2)) ;  % k_leak:leakage factor , magneth_1:varying magnet pitch 1st harmonic, r_o: outside radius , r_i: inner radius, Np:number of poles, theta_o: outer arc length , theta_i:inner arc length, theta_dif: arc length differences of outer and inner side   
w_m=(rpm*2*pi)/60 ; %rpm rotational speed(rpm)
v=r_mean*w_m ; % r_mean:mean radius, w_m : mechanical speed
e=(v*flux_lnk_peak*pi)/tau_p ; % v: air-gap linear speed, flux_lnk_peak : peak flux linkage , tau_p : pole pitch
E_ph_peak=e*Nt*N_series ; % e:induced emf of one turn,  Nt:number of turns in a coil, N_series: number of coils connnected in series 
E_ph_rms=E_ph_peak/sqrt(2); % E_ph_rms: induced emf per phase(rms),E_ph_peak: induced emf per phase(peak)
V_ph_rms = E_ph_rms*cosd(lambda)-I_ph_rms(R_ph_th*cosd(phi)+X_ph*sind(phi)) ;  %lamda: load angle, phi: power factor angle

