function minRob = computeRobustness(speed, gear)
%% COMPUTEROBUSTNESS Compute the min value for robustness according to SPEC.
% SPEC==1: Robustness computed as difference w.r.t. reference speed.
% SPEC==2: Robustness computed w.r.t. gear and speed.
    global SPEC;
    
    switch SPEC
        case 1
            %%TODO
            refSpeed = 120;  %120km/h
            rob = refSpeed - speed;
        case 2
            %If gear==3 then speed>=0.
            %It is falsified when gear==3 and speed<20.
            refGear = 3;    %Third gear
            refSpeed = 20;  %20km/h
            maxSpeed = 100; %100km/h
            %Difference between current gear and ref gear
            sub1 = abs(gear - refGear);
            %Difference between current speed and ref speed (normalized)
            sub2 = (speed - refSpeed)/maxSpeed;
            %Robustness is an OR,then compute the max between the two terms
            rob = max(sub1, sub2);
        otherwise
            rob = Inf;
    end
    %Return the minimum robustness in the simulated period
    minRob = min(rob);
end

