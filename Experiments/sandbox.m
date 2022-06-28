clear
A = zeros(7);
A(1) = 1;
imagesc(A);
axis equal tight
set(gca,'YDir','normal');
A = fftshift(A);
[h,l] = size(A);
figure;
imagesc(ceil(-l/2),ceil(-h/2),A);
axis equal tight
set(gca,'YDir','normal');