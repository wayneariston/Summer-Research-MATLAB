function [] = comboPlot(P0, nm, a)
    figure;
    subplot(1,2,1);
    latticePlot(P0,nm + " (8 atoms)",a,8);
    subplot(1,2,2);
    latticePlot(P0,nm + " (full)");
    figure;
end