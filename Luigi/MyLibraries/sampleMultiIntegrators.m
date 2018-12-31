%% Observations:
% 1) Eig(A) = 0.1 +/- 3i. Real part > 0 => Analytically UNSTABLE
%                         Big immaginary part => Oscillation
% 2) FE method: The system is numerically unstable. Not precise but
% correctly recognized.
% 3) BE method: The immaginary part lead the eigenvalues out of stability
% domain then the system is numerically stable BUT not analytically !!!
% 4) PC method: As before, the big immaginary component lead the
% eigenvalues out of the stability domain (half-moon) and then the system
% results numerically stable.
% 5) Heun's method: Very nice, numerically unstable as desired and a better
% approximation with respect the simple FE.

% Reset the workspace
clear;

% Printing control
PLOT_RESULT   = true;       % Enable/Disable the trajectory plot
PLOT_ACCURACY = false;      % Enable/Disable the accuracy plot (w.r.t. truth value)
PLOT_TRUTH    = true;       % Enable/Disable Truth-value trajectory
PLOT_FE       = false;      % Enable/Disable Forward Euler trajectory
PLOT_BE       = true;       % Enable/Disable Backward Euler trajectory
PLOT_HE       = false;      % Enable/Disable Heun's method trajectory (in RK2)
PLOT_EMR      = false;      % Enable/Disable Explicit Midpoint Rule trajectory (in RK2)
PLOT_PC       = false;      % Enable/Disable Simple Predictor-Corrector trajectory
PLOT_RK2      = false;      % Enable/Disable RungeKutta 2 trajectory
PLOT_RK4      = false;      % Enable/Disable RungeKutta 4 trajectory
PLOT_BDF3     = true;       % Enable/Disable BDF3 trajectory
PLOT_BDF6     = true;       % Enable/Disable BDF6 trajectory

% Simulation parameters
T0 = 0;
Tf = 100;
h  = 0.01;
time = [T0: h: Tf];


% State-space model 
%A = [ 0.00 1.00;
%     -9.01 0.20];
A = [-20   1;
       0 -20];
B = [0; 1];
C = [1 1];
D = 2;
x0 = [1; -2];

u = zeros(size(time));

% Create reference model
system = ss(A, B, C, D);
[y, t, x] = lsim(system, u, time, x0);

% Simulators
FE = sim.ForwardEuler(h, A, x0);
BE = sim.BackwardEuler(h, A, x0);
PC = sim.PredictorCorrector(h, A, x0);
HE = sim.HeunsMethod(h, A, x0);
EMR  = sim.ExplicitMidpointRule(h, A, x0);
RK2  = sim.RK2(h, A, x0);
RK4  = sim.RK4(h, A, x0);
BDF3 = sim.BDF(h, A, x0, 3);
BDF6 = sim.BDF(h, A, x0, 6);

% Run simulation step by step (initial state already known)
for i = 1:length(time)-1
    if i==1
        he_x_k = x0;
    end
    % Forward Euler
    FE = FE.step();
    % Backward Euler
    BE = BE.step();    
    % Predictor-Corrector
    PC = PC.step();
    % Heun's method
    HE = HE.step();   
    % Explicit Midpoint Rule
    EMR = EMR.step();
    % RK 2
    RK2 = RK2.step();
    % RK 4
    RK4 = RK4.step();
    % BDF 3
    BDF3 = BDF3.step();
    % BDF 6
    BDF6 = BDF6.step();
end

% Computing accuracy
fe_accuracy = x - FE.trajectory; % FE
be_accuracy = x - BE.trajectory; % BE
pc_accuracy = x - PC.trajectory; % Predictor-Corrector
he_accuracy = x - HE.trajectory; % Heun's method
emr_accuracy = x - EMR.trajectory; % Explicit Midpoint Rule
rk2_accuracy = x - RK2.trajectory; % Runge-Kutta 2
rk4_accuracy = x - RK4.trajectory; % Runge-Kutta 4
bdf3_accuracy = x - BDF3.trajectory; % Backward Difference Formula 3
bdf6_accuracy = x - BDF6.trajectory; % Backward Difference Formula 6

% Plot results
if PLOT_RESULT==true
    if PLOT_TRUTH
        figure(1);
        plot(x);
        title("Truth value");
    end
    
    if PLOT_FE
        figure(2);
        plot(FE.trajectory);
        title("Forward Euler");
    end
    
    if PLOT_BE
        figure(3);
        plot(BE.trajectory);
        title("Backward Euler");
    end
    
    if PLOT_PC
        figure(4);
        plot(PC.trajectory);
        title("Predictor-Corrector");
    end
    
    if PLOT_HE
        figure(5);
        plot(HE.trajectory);
        title("Heun's Method");
    end
    
    if PLOT_RK2
        figure(6);
        plot(RK2.trajectory);
        title("RK2");
    end
    
    if PLOT_RK4
        figure(7);
        plot(RK4.trajectory);
        title("RK4");
    end
    
    if PLOT_EMR
        figure(8);
        plot(EMR.trajectory);
        title("Explicit Midpoint Rule");
    end
    
    if PLOT_BDF3
        figure(9);
        plot(BDF3.trajectory);
        title("Backward Differentiation Formula 3");
    end
    
    if PLOT_BDF6
        figure(10);
        plot(BDF6.trajectory);
        title("Backward Differentiation Formula 6");
    end
end

% Plot results
if PLOT_ACCURACY==true
    if PLOT_FE
        figure(1);
        plot(fe_accuracy);
        title("FE Accuracy");
    end
    
    if PLOT_BE
        figure(2);
        plot(be_accuracy);
        title("BE Accuracy");
    end
    
    if PLOT_PC
        figure(3);
        plot(pc_accuracy);
        title("Pred-Corr Accuracy");    
    end
    
    if PLOT_HE
        figure(4);
        plot(he_accuracy);
        title("Heun's Accuracy");
    end
    
    if PLOT_EMR
        figure(5);
        plot(emr_accuracy);
        title("Explicit Midpoint Rule Accuracy");
    end
    
    if PLOT_RK2
        figure(6);
        plot(rk2_accuracy);
        title("RK2 Accuracy");
    end
    
    if PLOT_RK4
        figure(7);
        plot(rk4_accuracy);
        title("RK4 Accuracy");
    end
    
    if PLOT_BDF3
        figure(8);
        plot(bdf3_accuracy);
        title("BDF3 Accuracy");
    end
    
    if PLOT_BDF6
        figure(9);
        plot(bdf6_accuracy);
        title("BDF6 Accuracy");
    end
end