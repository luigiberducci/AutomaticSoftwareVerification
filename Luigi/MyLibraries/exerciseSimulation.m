%% Clear workspace
clear all;
clc;

A = [-1   0;
      0  -2];
x0 = [1; -1];

algo = "QSS";

h_or_q = 0.1;

t0 = 0;
tf = 50;

simManager = sim.SimulatorFactory(algo, A, h_or_q, x0);

[sim_time, sim_x] = simManager.getSimulatedResult(t0, tf);
[anl_time, anl_x] = simManager.getAnalyticalResult(t0, tf);

%% QSS Error computation
% Error bounds (computed theoretically)
b = [0.1; 0.1];
bound_line_pos1 =  ones(size(anl_time,2), 1) * b(1);
bound_line_pos2 =  ones(size(anl_time,2), 1) * b(2);
bound_line_neg1 = -ones(size(anl_time,2), 1) * b(1);
bound_line_neg2 = -ones(size(anl_time,2), 1) * b(2);

error = qssError(sim_x, sim_time, anl_x, anl_time);
figure(2);
plot(anl_time, error);
hold on;
plot(anl_time, bound_line_pos1);
plot(anl_time, bound_line_pos2);
plot(anl_time, bound_line_neg1);
plot(anl_time, bound_line_neg2);
legend("Error Var 1",       "Error Var 2", ...
       "Upperbound Var 1",  "Upperbound Var 2", ...
       "Lowerbound Var 1",  "Lowerbound Var 2");


function [e] = qssError(xs, ts, xa, ta)
    e = zeros(size(ta, 2), 2);
    j = 1;
    i = 1;
    interpolated = zeros(size(ta,2),2);
    while i < size(ta, 2)
        if ta(i) < ts(j)
            h = ts(j) - ta(i);
            old_xs1 = xs(j-1,1);
            cur_xs1 = xs(j, 1);
            old_xs2 = xs(j-1,2);
            cur_xs2 = xs(j, 2);
            par1 = polyfit([ts(j-1), ts(j)], ...
                             [old_xs1, cur_xs1], 1);
            par2 = polyfit([ts(j-1), ts(j)], ...
                             [old_xs2, cur_xs2], 1);
            interpolated1 = old_xs1 + h*par1(1);
            interpolated2 = old_xs2 + h*par2(1);
            e(i, 1) = abs(abs(interpolated1) - abs(xa(i, 1)));
            e(i, 2) = abs(abs(interpolated2) - abs(xa(i, 2)));
            interpolated(i,:) = [interpolated1, interpolated2];
            i = i+1;
        else
            j = j+1;
        end
    end
    figure(10);
    plot(ta, interpolated);
end



