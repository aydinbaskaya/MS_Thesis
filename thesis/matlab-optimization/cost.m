function result = cost(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%

upper_bound_J=8;    % upper limit for current density

[cost,J_final,J_init,J_pmax,P_net]=design(x);

% %-----------------------------------------------------------------
% %% Reference turbine statics are taken 
% NET.addAssembly('microsoft.office.interop.excel');
% app = Microsoft.Office.Interop.Excel.ApplicationClass;
% book =  app.Workbooks.Open('C:\Users\Aydin\Desktop\yeni kod\ref_table.xls');
% sheet = Microsoft.Office.Interop.Excel.Worksheet(book.Worksheets.Item(1)); 
% range = sheet.UsedRange;
% arr = range.Value;
% data = cell(arr,'ConvertTypes',{'all'});
% %cellfun(@disp,data(:,1))
% ref_table=ones(10,5);           %reference turbine values table
% for i=2:11
%     for j=1:5
%         ref_table(i-1,j)=data{i,j} ;
%     end
% end
%   
% %ref_table(:,1)-->rpm values
% %ref_table(:,2)-->Average torque in kNm
% %ref_table(:,3)-->Average power
% %ref_table(:,4)-->Time Probability
% %ref_table(:,5)-->Energy ratio
% 
% %-----------------------------------------------------------------

if J_init<upper_bound_J
    if J_init<J_pmax
        J_final=J_pmax;
            x(3)=J_final;
            [cost,J_final,J_init,J_pmax,P_net]=design(x);   
        for k=1:5
            [cost,J_final,J_init,J_pmax,P_net]=design(x);
            J_final=J_final*(P_demand/(P_o+P_loss));
            x(3)=J_final;
        end
    else
        J_final=0.9*J_pmax;
    end
else
    J_final=upper_bound_J;
end
% 
% go funct




%%









%----------------------------------------------------------------------------------------------------









%--------------------------------------------------------------------------------------------------------------------------
%cost=total_cost+penalty_eff+penalty_deflection;                          %%Resulting cost equation
result=cost; 
