function result = cost_multi(x)
%%%%%Main COST Function for the AFPM Design Optimization%%%%%

[cost,x_final,ratings,result_list]=design_multi(x);         % updated variable list, ratings of the design and resulting parameter list are imported to here

%------------------------------------------------------------------------------------------------
%-------------------------Variable list export part----------------------------------------------

table1=cell(16,2);                 % variable table   
label={'r_mean','airgap','current density','outer limb thickness','inner limb thickness','steel web thickness','magnet/steel width ratio'...
        ,'Number of turn','Number of poles','number of branches','height of the winding','pitch ratio','fill factor','height of the magnet',...
        'lenghth of the magnet','number of stack'};

for i=1:16
    table1{i,1}=label{i};           % namelist of variables 
end

for i=1:16
    table1{i,2}=x_final(i);         % values of variables   
end

fileID = fopen('optim_variables.dat','w');   
formatSpec = '%s\t %d\n';

for row = 1:16
    fprintf(fileID,formatSpec,table1{row,:});       % variable list (@rated speed) is exported to "optim_variables.dat" file in the workspace
end
fclose(fileID);

%----------------------------End of variable list part--------------------------------------------


%-------------------------------------------------------------------------------------------------
%-----------------------------Ratings table export part-------------------------------------------

fileID2 = fopen('optim_ratings.dat','w');   
formatSpec2 = '%s\t ';
formatSpec3 = '%s\n' ;
label2={'rpm','J-Current density','V_ph (rms)','I_ph (rms)','P_desired','P_total','Efficiency','Temperature','P_net'};      % namelist of ratings
    
for column = 1:8
    fprintf(fileID2,formatSpec2,label2{column});     % namelist of ratings is exported to "optim_ratings.dat" file in the workspace
end
fprintf(fileID2,formatSpec3,label2{9});

formatSpec4 = '%d\t';
formatSpec5= '%d\n ' ;
for i = 1:9
    for j = 1:8
        fprintf(fileID2,formatSpec4,ratings{i+1,j});    % values of ratings are exported to "optim_ratings.dat" file in the workspace
    end
    fprintf(fileID2,formatSpec5,ratings{i+1,9});
end
fclose(fileID2);

%------------End of Ratings table export part-----------------------------------------------------


%-------------------------------------------------------------------------------------------------
%-------------------------Results table export part-----------------------------------------------

fileID3 = fopen('optim_results.dat','w');   
formatSpec6 = '%s\t\t ';
formatSpec7 = '%d\n' ;
label3={'r_mean','airgap','rpm','J-Current density','Outer limb thickness','Inner limb thickness','steel web thickness','Number of turns','Number of poles','Number of branch',...
        'height of the winding','Winding thickness/coil pitch ratio','Fill factor','Height of the magnet','length of the magnet','Magnet/Steel width ratio','Remanence Flux density',...
        'Voltage per phase rms','Current per phase rms','Output power','Effiency','Phase inductance','Resistance @ambient','Resistance w/thermal','Conductor area','windint temperature',...
        'Beam deflection','Spacer Flux density','Airgap flux density','Steel flux density','Ambient temperature','Steel mass(active)','Copper mass','Magnet mass','Structural mass',...
        'total mass','Steel cost','Copper cost','Magnet cost','Structural cost','Total cost','Stator outer diameter','web diameter','total axial length','Number of parallel machines',...
        'Pole pitch','Coil pitch','Magnet width','Number of coils','frequency','Induced emf per phase rms','Induced emf per phase peak','Copper loss','Eddy loss','Phase reactance',...
        'load angle','power factor angle','magnet fundamental peak flux density','magnet-to-magnet gap','steel-to-steel gap','coil-steel web clearance','web radius','outer radius',...
        'inner radius','temperature rise','total cost','Efficiency Penalty','Deflection Penalty','Axial length penalty','Outer diameter penalty','Temperature penalty','Power Penalty-1',...
        'Power Penalty-2','Total Power Penalty','Voltage penalty','Total output power','Net output power','Desired Output power','Fitness'};      % namelist of results
    
for row = 1:79
    fprintf(fileID3,formatSpec6,label3{row});           % namelist of results is exported to "optim_results.dat" file in the workspace
    fprintf(fileID3,formatSpec7,result_list(row));      % values of results are exported to "optim_results.dat" file in the workspace
end
fclose(fileID3);
%-------------------------------End of Results table export part-----------------------------------
result=cost; 

