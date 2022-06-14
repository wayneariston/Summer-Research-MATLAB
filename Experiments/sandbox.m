A = randi(100,1000,1000);
B = randi(100,1000,1000);

sa = size(A);
sb = size(B);

tic
F = padarray(A,[sb(1)-1 sb(2)-1]);
G = padarray(B,[sb(1)-1 sb(2)-1]);
D = fftshift(ifft2(fft2(F).*fft2(G)));
D = D(sb(1):sa(1)+sb(1)-1,sb(2):sa(2)+sb(2)-1);
toc

tic
Z = conv_fft2(A,B,'same');
toc

tic
C = conv2(A,B,'same');
toc

E = D-C;

max(E,[],"all")