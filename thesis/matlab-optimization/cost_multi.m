function result = cost_multi(x)
%%%%%Axial Flux PM Generator Design Equations%%%%%

[cost,J_final,J_init,J_pmax,P_demand,P_net,n_stack]=design_multi(x);


% 
% %-----------------------------------------------------------------

% if J_init<upper_bound_J
%     if J_init<J_pmax
%         J_final=J_pmax;
%             x(3)=J_final;
%             [cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);   
%         for k=1:5
%             [cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);
%             J_final=J_final*(P_demand/(P_net));
%             x(3)=J_final;
%         end
%     else
%         J_final=0.9*J_pmax;
%     end
% else
%     J_final=upper_bound_J;
% end
% 
% x(3)=J_final;
% [cost,J_final,J_init,J_pmax,P_net,n_stack]=design(x);           % go funct


%--------------------------------------------------------------------------------------------------------------------------
% t=t+1;
result=cost; 

