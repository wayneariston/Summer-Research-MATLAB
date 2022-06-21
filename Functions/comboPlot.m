function [eight, full] = comboPlot(P0, nm, a)
    figure;
    eight = subplot(1,2,1);
    latticePlot(P0," (8 atoms)",a,8);
    full = subplot(1,2,2);
    latticePlot(P0," (full)");
    t = sgtitle("Intensity plot of " + nm);
    t.FontSize = 20;
end