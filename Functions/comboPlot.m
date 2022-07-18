function [eight, full, pl] = comboPlot(P0, nm, a, options)
    arguments
        P0; nm; a;
        options.units = "px";
        options.cf = 1;
        options.cunits = [];
        options.ccf = [];
    end
    if isempty(options.cunits)
        options.cunits = options.units;
        options.ccf = options.cf;
    end
    
    figure;
    eight = subplot(1,2,1);
    latticePlot(P0," (8 atoms)",a,8,units=options.units,cf=options.cf);
    full = subplot(1,2,2);
    latticePlot(P0," (full)",units=options.units,cf=options.cf);

    % for the common colorbar
    pl = axes('visible', 'off');
    climits = [min(P0,[],"all") max(P0,[],"all")]/options.ccf;
    clim(climits);
    c = colorbar(pl, 'Location','southoutside');
    c.Label.String = "elevation ["+options.cunits+"]";
    c.Label.Interpreter = "Latex";
    t = sgtitle("Intensity plot of " + nm);
    t.FontSize = 20;
end