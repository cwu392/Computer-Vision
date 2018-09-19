function output=conv_fft(image,filter)

P=numel(image);
Q=numel(filter);
K=2^nextpow2(P+Q-1);
output=ifft(fft(image,K).*fft(filter,K));
output=output(1:(P+Q-1));