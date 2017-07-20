function best_ratings(x)

power_speed=excel_read2();
table=power_speed;        %power-speed excel data is imported here
filename='best_design_ratings.xlsx';
label={'rpm','J-Current density','Vph','Iph','P Desired','Total P','Efficiency','Temperature','Net P out','cost'};
xlRange1='A1:J1';
xlswrite(filename,label,xlRange1);
for i=1:9
    
    [rpm,J,Vph,Iph,Pdes,P_tot,Eff,temp,P_net,cost]=calculate_best(x,i,table) ;
    
    value=[rpm,J,Vph,Iph,Pdes,P_tot,Eff,temp,P_net,cost];
    
    if  i==1
        xlRange2='A2:J2';
    elseif i==2
        xlRange2='A3:J3';
    elseif i==3
        xlRange2='A4:J4';
    elseif i==4
        xlRange2='A5:J5';
    elseif i==5
        xlRange2='A6:J6';
    elseif i==6
        xlRange2='A7:J7';
    elseif i==7   
        xlRange2='A8:J8';
    elseif i==8  
        xlRange2='A9:J9';
    elseif i==9
        xlRange2='A10:J10';
    end   
    
    xlswrite(filename,value,xlRange2);
end


end