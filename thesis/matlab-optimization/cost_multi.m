function result = cost_multi(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%

[cost,x_final,ratings]=design_multi(x);         % updated variable list and ratings of the design are imported to here
table1=cell(16,2);
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



result=cost; 

