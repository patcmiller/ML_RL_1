
my_grid= grid5;

sz= size(my_grid,1)-2;
[P,R]= grid_toMDP(my_grid, .9);

discount = 0.9;

tic; [V1, Policy1, iter1, cpu_time1_]= mdp_policy_iteration(P, R, discount);
cpu_time1= toc;
tic; [Policy2, iter2, cpu_time2_]= mdp_value_iteration(P, R, discount);
cpu_time2= toc;
tic; [Policy3, iter3, cpu_time3_]= mdp_relative_value_iteration(P, R, discount, 10000);
cpu_time3= toc;
tic; [V4, Policy4, cpu_time4_]= mdp_finite_horizon(P, R, discount, 10000);
cpu_time4= toc;
tic; [Q5, V5, Policy5, iter5]= mdp_Q_learning(P, R, discount, 100000);
cpu_time5= toc;

display ( [ num2str(iter1) '  &  ' num2str(cpu_time1) ] );
display ( [ num2str(iter2) '  &  ' num2str(cpu_time2) ] );
display ( [ num2str(10000) '  &  ' num2str(cpu_time3) ] );
display ( [ num2str(10000) '  &  ' num2str(cpu_time4) ] );
display ( [ num2str(100000) '  &  ' num2str(cpu_time5) ] );

isequal(Policy1, Policy2)

% get walls...
wall_grid= abs(my_grid(2:sz+1,2:sz+1))*-1;
wall_grid(1,1)= 2;
wall_grid(sz,sz)= 0;
 
cols = hot(4);
cols(1,:) = [0,0,0];
cols(2,:) = [0.5,0.5,0.5];
cols(3,:) = [0.5,0.5,0.5];
cols(4,:) = [1,1,1];

% names= ['Policy Iteration', 'Value Iteration', 'Relative Value Iteration', 'Finite Horizon', 'QLearning']; 
% policy= [Policy1, Policy2, Policy3, Policy4, Policy5];

% POLICY ITERATION
figure;
imagesc(reshape(V1,sz,sz)' + wall_grid);
hold on
dir_x= zeros(sz,sz);
dir_y= zeros(sz,sz);
len= 0.1;

for i=1:sz
    for j=1:sz
        dir= Policy1((i-1)*sz+j);

        if (my_grid(i+1,j+1) == -1 || my_grid(i+1,j+1) == 1)
            continue;
        end

        if (dir == 1)
            dir_x(i,j)= -len;
        elseif (dir == 2)
            dir_x(i,j)= len;
        elseif (dir == 3)
            dir_y(i,j)= -len;
        else
            dir_y(i,j)= len;
        end
    end
end

title (['Grid ', num2str(sz), ' - Policy Iteration']);
colormap(cols);
grid on;
[x,y]= meshgrid(1:sz,1:sz);
quiver(x,y,dir_x,dir_y );
saveas(gcf,strcat('Grid ',num2str(sz),' - Policy Iteration.png'));
hold off;

% VALUE ITERATION
figure;
imagesc(reshape(V1,sz,sz)' + wall_grid);
hold on
dir_x= zeros(sz,sz);
dir_y= zeros(sz,sz);
len= 0.1;

for i=1:sz
    for j=1:sz
        dir= Policy2((i-1)*sz+j);

        if (my_grid(i+1,j+1) == -1 || my_grid(i+1,j+1) == 1)
            continue;
        end

        if (dir == 1)
            dir_x(i,j)= -len;
        elseif (dir == 2)
            dir_x(i,j)= len;
        elseif (dir == 3)
            dir_y(i,j)= -len;
        else
            dir_y(i,j)= len;
        end
    end
end

title (['Grid ', num2str(sz), ' - Value Iteration']);
colormap(cols);
grid on;
[x,y]= meshgrid(1:sz,1:sz);
quiver(x,y,dir_x,dir_y );
saveas(gcf,strcat('Grid ',num2str(sz),' - Value Iteration.png'));
hold off;

% RELATIVE VALUE ITERATION
figure;
imagesc(reshape(V1,sz,sz)' + wall_grid);
hold on
dir_x= zeros(sz,sz);
dir_y= zeros(sz,sz);
len= 0.1;

for i=1:sz
    for j=1:sz
        dir= Policy3((i-1)*sz+j);

        if (my_grid(i+1,j+1) == -1 || my_grid(i+1,j+1) == 1)
            continue;
        end

        if (dir == 1)
            dir_x(i,j)= -len;
        elseif (dir == 2)
            dir_x(i,j)= len;
        elseif (dir == 3)
            dir_y(i,j)= -len;
        else
            dir_y(i,j)= len;
        end
    end
end

title (['Grid ', num2str(sz), ' - Relative Value Iteration']);
colormap(cols);
grid on;
[x,y]= meshgrid(1:sz,1:sz);
quiver(x,y,dir_x,dir_y );
saveas(gcf,strcat('Grid ',num2str(sz),' - Rel. Value Iteration.png'));
hold off;

% FINITE HORIZON
figure;
imagesc(reshape(V1,sz,sz)' + wall_grid);
hold on
dir_x= zeros(sz,sz);
dir_y= zeros(sz,sz);
len= 0.1;

for i=1:sz
    for j=1:sz
        dir= Policy4((i-1)*sz+j);

        if (my_grid(i+1,j+1) == -1 || my_grid(i+1,j+1) == 1)
            continue;
        end

        if (dir == 1)
            dir_x(i,j)= -len;
        elseif (dir == 2)
            dir_x(i,j)= len;
        elseif (dir == 3)
            dir_y(i,j)= -len;
        else
            dir_y(i,j)= len;
        end
    end
end

title (['Grid ', num2str(sz), ' - Finite Horizon']);
colormap(cols);
grid on;
[x,y]= meshgrid(1:sz,1:sz);
quiver(x,y,dir_x,dir_y );
saveas(gcf,strcat('Grid ',num2str(sz),' - Finite Horizon.png'));
hold off;

% Q-LEARNING
figure;
imagesc(reshape(V1,sz,sz)' + wall_grid);
hold on
dir_x= zeros(sz,sz);
dir_y= zeros(sz,sz);
len= 0.1;

for i=1:sz
    for j=1:sz
        dir= Policy5((i-1)*sz+j);

        if (my_grid(i+1,j+1) == -1 || my_grid(i+1,j+1) == 1)
            continue;
        end

        if (dir == 1)
            dir_x(i,j)= -len;
        elseif (dir == 2)
            dir_x(i,j)= len;
        elseif (dir == 3)
            dir_y(i,j)= -len;
        else
            dir_y(i,j)= len;
        end
    end
end

title (['Grid ', num2str(sz), ' - Q-Learning']);
colormap(cols);
grid on;
[x,y]= meshgrid(1:sz,1:sz);
quiver(x,y,dir_x,dir_y );
saveas(gcf,strcat('Grid ',num2str(sz),' - Q-Learning.png'));
hold off;
