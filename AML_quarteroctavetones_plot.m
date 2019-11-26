function [tuningcurve, fftrials] = AML_quarteroctavetones_plot(data)
% modified from KAMI_quarteroctavetones_plot, 11/7/19

deltaF_all=zeros(size(data));
numCells=size(data,2);
numFrames=size(data,1);

for i=1:numCells
    rawtrace=data(:,i);
    deltaF_all(:,i)  = deltaF_simple(rawtrace);
end
numframe = size(deltaF_all,1); 
numcells = size(deltaF_all,2); 
numpres  = (numframe-10)/340;
% numpres  = floor(numframe-10)/340;%AML edit 11/6/19
numtones = 17; 
numpertone  = 20; 
tones       = dlmread('H:\matlab_code\KAMI\QUARTEROCTAVE.txt');
unsorttones = dlmread('H:\matlab_code\KAMI\QUARTEROCTAVE.txt');
[tones,ind] = sort(tones(1:numtones));
d_df = [];
d_df(numframe-9:numframe,:) = deltaF_all(1:10,:); %makes first 10 frames last 10 frames
d_df(1:(numframe-10),:)     = deltaF_all(11:end,:);

d = [];
d(numframe-9:numframe,:) = data(1:10,:); %makes first 10 frames last 10 frames
d(1:(numframe-10),:)     = data(11:end,:);
 
for cell = 1:numcells
    reformatted = reshape(d_df(1:end-10,cell),(numtones*numpertone),numpres);
    figure(51); 
    subplot(2, 1, 1); 
    plot(reformatted, 'Color', [0.5 0.5 0.5]); 
    hold on; 
    plot(mean(reformatted,2), 'k', 'LineWidth', 2); 
    title(['cell: ', num2str(cell)]);
    clear MINY MAXY
    MINY = min(min(reformatted)); 
    MAXY = max(max(reformatted)); 
    if MINY==MAXY
        MINY = MINY-5; 
        MAXY = MAXY+5;
    end 
    ylim([MINY-(0.1*MINY) MAXY-(0.1*MAXY)]); 
    TONEPRES = 10:20:(numtones*numpertone);
    for j = 1:numtones 
        plot([TONEPRES(j) TONEPRES(j)],[MINY-(0.1*MINY) MAXY-(0.1*MAXY)], 'k--'); 
    end
    set(gca, 'XTick', TONEPRES, 'XTickLabel', round(unsorttones./1000, 3, 'significant')); 
    hold off; 
    
    for eachtone=1:numel(tones)
        clear ff
        framepres = ((ind(eachtone)-1)*20)+10:(numtones*numpertone):(numframe-10);
        celldata = []; 
        for plusone = 1:numel(framepres)
            celldata = [celldata d(framepres(plusone)-9:framepres(plusone)+10,cell)];
        end
        [ff,h,p] = KAMI_deltaF_tones(celldata, 10);
      % during stimulus
        tuningcurve.med(eachtone, cell) = median(median(ff(4:6,:))); 
        tuningcurve.mean(eachtone,cell) = mean(mean(ff(4:6,:)));
        tuningcurve.max(eachtone, cell) = mean(trapz(ff(4:6,:)));
        tuningcurve.std(eachtone, cell) = std(mean(ff(4:6,:)));
        tuningcurve.h(eachtone,cell)    = h;
        tuningcurve.p(eachtone,cell)    = p;
        % pre stimulus  
        tuningcurve.premed(eachtone, cell) = median(median(ff(1:3,:))); 
        tuningcurve.premean(eachtone,cell) = mean(mean(ff(1:3,:)));
        tuningcurve.premax(eachtone, cell) = mean(trapz(ff(1:3,:)));
        tuningcurve.prestd(eachtone, cell) = std(mean(ff(1:3,:)));
      % post stimulus  
        tuningcurve.postmed(eachtone, cell) = median(median(ff(end-2:end,:))); 
        tuningcurve.postmean(eachtone,cell) = mean(mean(ff(end-2:end,:)));
        tuningcurve.postmax(eachtone, cell) = mean(trapz(ff(end-2:end,:)));
        tuningcurve.poststd(eachtone, cell) = std(mean(ff(end-2:end,:)));

        fftrials(eachtone,cell).df = ff; 
        fftrials(eachtone,cell).tone = tones(eachtone); 
    end
    figure(51); 
    subplot(2,1,2); 
    plot(tuningcurve.med(:,cell), 'k'); hold on; 
    plot(tuningcurve.mean(:,cell), 'k', 'LineWidth', 2); 
    set(gca,'XTick', 1:1:numtones, 'XTickLabel', round(tones./1000, 3, 'significant')); 
    hold off; 
    while waitforbuttonpress ~= 0 
        
    end
end

tuningcurve.tone  = tones;
tuningcurve.fpres = framepres;

end
