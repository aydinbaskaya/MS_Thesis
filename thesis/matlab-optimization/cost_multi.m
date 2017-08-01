function result = cost_multi(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%

[cost,x_final]=design_multi(x);

% filename='best_design_ratings2.xlsx';
% label={'r_mean','airgap','current density','outer limb thickness','inner limb thickness','steel web thickness','magnet/steel width ratio'...
%         ,'Number of turn','Number of poles','number of branches','height of the winding','pitch ratio','fill factor','height of the magnet',...
%         'lenghth of the magnet','number of stack'};
% 
% xlRange1='A1:P1';
% xlswrite(filename,label,xlRange1);
% 
value=[x_final(1),x_final(2),x_final(3),x_final(4),x_final(5),x_final(6),x_final(7),x_final(8),x_final(9),x_final(10),x_final(11),x_final(12),...
    x_final(13),x_final(14),x_final(15),x_final(16)];

fileID = fopen('final.txt','w');   
fprintf(fileID,'r_mean',value);
% xlRange2='A2:P2';
% xlswrite(filename,value,xlRange2);
fclose(fileID);
result=cost; 

