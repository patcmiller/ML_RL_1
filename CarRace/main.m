%--------------------------------------------------------------------------
% Run the race car example.
%--------------------------------------------------------------------------
% MDP Toolbox, INRA, BIA Toulouse, France
%--------------------------------------------------------------------------

global VMAX Map_Data Finish_Data Pos_Vector_Indexes Speed_Vector_Indexes st_len

cpu_time = cputime;

% Initialising the important constants:
% VMAX is the maximum allowed speed, in norm. It must be an integer.
VMAX=2;

% p is an action probability of non-transmission
p=0.1;

% penalty is the penalty associated to an accident.
penalty=1000;

% Reading the data from the file
% m and n are the dimensions of the data matrix
n=4;
Map_Data=read_data(['data/',num2str(n),'x',num2str(n),'/',num2str(n),'_',num2str(n),'_track.txt'],n,n);
%Map_Data=read_data('data/10x10/10_10_track.txt',10,10);

% Computing the indexes for position and speed
[Pos_Vector_Indexes,Speed_Vector_Indexes]=index_computation;

[Start_Indexes_Y, Start_Indexes_X]=find(Map_Data==2);

% Computing the start-line data (boundaries, center, coefficients; see
% generate_starting_state.m for details

y1=Start_Indexes_Y(1);
x1=Start_Indexes_X(1);
y2=Start_Indexes_Y(size(Start_Indexes_Y,1));
x2=Start_Indexes_X(size(Start_Indexes_Y,1));
yc=Start_Indexes_Y(floor(size(Start_Indexes_Y,1)/2));
xc=Start_Indexes_X(floor(size(Start_Indexes_Y,1)/2));
a=(y1-y2)/(x1-x2);
b=y1-a*x1;
Finish_Data=[y1 x1;y2 x2;yc xc;VMAX*VMAX 0;a b];

% initialising variables
S= generate_starting_state;

courant=0;
st_len=size(Pos_Vector_Indexes,1)*size(Speed_Vector_Indexes,1);
P2=cell(9,1);
C2=cell(9,1);

% computing the transition and cost matrices

for s=-1:1
    for t=-1:1       
        [Y, X, V, Cost]=transition_matrix(s,t,p);
        Prob=sparse(Y,X,V,st_len+2,st_len+2);
        % Cost is entered as -Cost because the solving algorithms are
        % reward-maxing instead of cost-minimizing.
        CC=sparse(Y,X,-Cost,st_len+2,st_len+2);
        % Due to the sparse format, some costs will be 2 when they should be 1.
        % This corrects it.
        CC(CC==-2)=-1;
        courant=courant+1;
        P2{courant}=Prob;
        C2{courant}=CC;         
    end
end

cpu_time = cputime - cpu_time;

% Solving the MDP
discount= 0.99;
tic; [V1, Policy1, iter1, cpu_time1_]= mdp_policy_iteration(P2, C2, discount);
cpu_time1= toc;
tic; [Policy2, iter2, cpu_time2_]= mdp_value_iteration(P2, C2, discount);
cpu_time2= toc;
tic; [Policy3, ~, cpu_time3_]= mdp_relative_value_iteration(P2, C2, discount, 10000);
cpu_time3= toc;
tic; [V4, Policy4, cpu_time4_]= mdp_finite_horizon(P2, C2, discount, 10000);
cpu_time4= toc;

display ( [ num2str(iter1) '  &  ' num2str(cpu_time1) ] );
display ( [ num2str(iter2) '  &  ' num2str(cpu_time2) ] );
display ( [ num2str(10000) '  &  ' num2str(cpu_time3) ] );
display ( [ num2str(10000) '  &  ' num2str(cpu_time4) ] );

% Displaying a random trajectory:
figure;
[T,~]= trajectory(S, Policy1, st_len, 0);
display_race(T(1:(size(T,1)-1)),st_len);
title (['Grid ', num2str(n), ' - Race Car']);
saveas(gcf,strcat('Grid ',num2str(n),' - Race Car.png'));

figure;
[T,~]= trajectory(S, Policy2, st_len, 0);
display_race(T(1:(size(T,1)-1)),st_len);

figure;
[T,~]= trajectory(S, Policy3, st_len, 0);
display_race(T(1:(size(T,1)-1)),st_len);

figure;
[T,~]= trajectory(S, Policy4, st_len, 0);
display_race(T(1:(size(T,1)-1)),st_len);

figure;
bar([cpu_time1, cpu_time2, cpu_time3, cpu_time4])
title (['Grid ', num2str(n), ' - Race Car Times']);
saveas(gcf,strcat('Grid ',num2str(n),' - Race Car Times.png'));
