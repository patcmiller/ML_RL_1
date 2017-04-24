my_grid = grid15;
sz = size(my_grid,1)-2;

pii= [];
vii= [];
pit= [];
vit= [];
rvit= [];
fht= [];
qlt= [];

for prob= [0.7, 0.8, 0.9, .99]
    [P,R] = grid_toMDP(my_grid, prob);
    
    pi_iter= [];
    vi_iter= [];

    pi_times= [];
    vi_times= [];
    rvi_times= [];
    fh_times= [];
    ql_times= [];

    for discount = [0.7, 0.8, 0.9, 0.95, 0.99]
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

        pi_iter= [pi_iter, iter1];
        vi_iter= [vi_iter, iter2];

        pi_times= [pi_times, cpu_time1];
        vi_times= [vi_times, cpu_time2];
        rvi_times= [rvi_times, cpu_time3];
        fh_times= [fh_times, cpu_time4];
        ql_times= [ql_times, cpu_time5];
    end
    
    pii= [pii; pi_iter];
    vii= [vii; vi_iter];
    pit= [pit; pi_times];
    vit= [vit; vi_times];
    rvit= [rvit; rvi_times];
    fht= [fht; fh_times];
    qlt= [qlt; ql_times];
    
end

figure;
bar(pii);
title (['Grid ', num2str(sz), ' - Policy Iteration - Iterations by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Policy Iteration - Iterations.png'));

figure;
bar(vii);
title (['Grid ', num2str(sz), ' - Value Iteration - Iterations by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Value Iteration - Iterations.png'));

figure;
bar(pit);
title (['Grid ', num2str(sz), ' - Policy Iteration - Time by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Policy Iteration - Time.png'));

figure;
bar(vit);
title (['Grid ', num2str(sz), ' - Value Iteration - Time by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Value Iteration - Time.png'));

figure;
bar(rvit);
title (['Grid ', num2str(sz), ' - Rel. Value Iteration - Time by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Rel. Value Iteration - Time.png'));

figure;
bar(fht);
title (['Grid ', num2str(sz), ' - Finite Horizon - Time by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Finite Horizon - Time.png'));

figure;
bar(qlt);
title (['Grid ', num2str(sz), ' - Q-Learning - Time by discount and uncertainty']);
saveas(gcf,strcat('Grid ',num2str(sz),' - Q-Learning - Time.png'));