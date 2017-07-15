function result = cost(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%
k=0;
upper_bound_J=7;    % upper limit for current density
P_des=5000000;
eff_gear=1;

[cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);

P_demand=(P_des*eff_gear)/n_stack;
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
            [cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);   
        for k=1:5
            [cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);
            J_final=J_final*(P_demand/(P_net));
            x(3)=J_final;
        end
    else
        J_final=0.9*J_pmax;
    end
else
    J_final=upper_bound_J;
end

x(3)=J_final;
[cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);           % go funct


%--------------------------------------------------------------------------------------------------------------------------
k=k+1;
result=cost; 

