A=textread('fitness_list.txt','%.3f');
% linspace=1:1:914453 ;
% scatter(linspace,A,50)

group=zeros(200,100);


for i=1:1:200             %generation
    for j=1:1:100         %pop. size
        group(i,j)=A((i*100+1)+j);
    end

end

group=sort(group,2,'descend');

linspace=1:1:200 ;
scatter(linspace,group(:,100),15,'filled')