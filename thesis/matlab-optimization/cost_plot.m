
% .m file for plot the best cost variation among the generations

A=textread('cost_list.txt','%.3f');     % cost list of the all individuals
linspace=1:1:20101 ;                    % (number of generation*population size)--->200*100
scatter(linspace,A,15,'filled')         % plot