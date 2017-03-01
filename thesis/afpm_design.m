%%%%%Axial Flux PM Generator Design Equations%%%%%
% 
% Voltage per phase calculation

E_ph_peak=e*Nt*N_series ; %e:induced emf of one turn,  Nt:number of turns in a coil, N_series: number of coils connnected in series 
E_ph_rms=E_ph_peak/sqrt(2);
V_ph_rms = E_ph_rms-(I_ph_rms*R_ph_th*cosd(lambda)+X_ph*sind(lambda)) ;

