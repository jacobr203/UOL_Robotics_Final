function DrawWall(test)
load('Ideal_Map.mat');


idealMap2 = saveme;
idealMap2 = max(idealMap2, 0);



imagesc(idealMap2);  
set(gca,'YDir','normal')

end

