function u = chooseAction(regionInf, regionSup, quantum)
    for i = 1:length(regionInf)
        u(i) = randsample(regionInf(i) : quantum(i) : regionSup(i), 1);
    end
end

