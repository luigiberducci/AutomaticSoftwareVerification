ALGO = "RS";
C = [0 0.125 0.25 0.5];
C = [0];
SPEC = 2;
numTest=5;
for ic = 1:length(C)
    figure(ic);
    
    for testID = 1:numTest
        subplot(3, numTest, testID);
        src.plotRobustnessResult(ALGO, SPEC, 0, C(ic), testID);
        xlim([0 100]);
        if SPEC==1
            ylim([0 100]);
        else
            ylim([0 1.2]);
        end
    end
end

ALGO = "HC";
C = [0 0.125 0.25 0.5];
C = [0];
SPEC = 2;
for ic = 1:length(C)
    figure(ic);
    
    for testID = 1:numTest
        subplot(3, numTest, numTest + testID);
        src.plotRobustnessResult(ALGO, SPEC, 0, C(ic), testID);
        xlim([0 100]);
        if SPEC==1
            ylim([0 100]);
        else
            ylim([0 1.2]);
        end
    end
end

ALGO = "SA";
C = [0 0.125 0.25 0.5];
C = [0];
SPEC = 2;
for ic = 1:length(C)
    figure(ic);
    for testID = 1:numTest
        subplot(3, numTest, 2*numTest + testID);
        src.plotRobustnessResult(ALGO, SPEC, 0, C(ic), testID);
        xlim([0 100]);
        if SPEC==1
            ylim([0 100]);
        else
            ylim([0 1.2]);
        end
    end
end