
% .m file for plot the best fitness variation among the generations

A=textread('fitness_list.txt','%.3f');      %fitness export file read
group=zeros(200,100);

for i=1:1:200             %number of generation
    for j=1:1:100         %population size
        group(i,j)=A((i*100+1)+j);      %initial generation which was added by MATLAB, is ignored
    end

end

group=sort(group,2,'descend');       %sort the fitness values in descending order       

linspace=1:1:200 ;
scatter(linspace,group(:,100),15,'filled')      %plot