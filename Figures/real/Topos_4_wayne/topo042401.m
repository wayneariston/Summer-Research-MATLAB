[header, data]=loadsxm('FGT_nq_2204240001.sxm', 1);

avg=mean(data, 2); %avg is a vector of the average value of each row
sd=std(data, 0, 2);
normdata=zeros(size(data));

normdata = reshape(normalize(data(:)),256,[]);

%z normalization by line
 for i = 1:size(data)
     normdata(i,:)=(data(i,:)-avg(i))/sd(i);
 end

%normdata(:,:)=(data(:,:)-avg);

%plotting topo
figure(1)
imagesc(normdata) %this is just plotting data in pixels to plot in nm do: 
%imagesc([0 1.29*header.scan_range(1)], [0 1.29*header.scan_range(2)],normdata)
title('Topography (1.2 nA, 25 meV)')
axis square
xlabel('X (nm)')
ylabel('Y (nm)')
colorbar
colormap(gray)

%fourier tranform
topoft=mvfft(normdata);

%z-norm of fourier transform
avg=mean(topoft, 'all');
sd=std(topoft, 0, 'all');
topoft=(topoft-avg)/sd;

%plotting FT
figure(2)
imagesc([-pi/1 pi/1],[-pi/1 pi/1],topoft) %units of inverse pixels
caxis([0, 5]) %including 5 stard deviations in color scale
title('FT of topo')
axis square
colormap winter
colorbar
xlabel('kx (1/nm)')
ylabel('ky (1/nm)')
h = colorbar;
ylabel(h, '\sigma', 'FontSize',16,'Rotation', 360)