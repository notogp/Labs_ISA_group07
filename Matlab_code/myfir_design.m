function [bi, bq]=myfir_design(N,nb)
% function myfir_design(N,nb)
% N is order of the filter
% nb is the number of bits
% bi taps represented as integers

close all;
f_cut_off = 2000; % 1kHz
f_sampling = 10000; % 10kHz

f_nyq = f_sampling/2; %% Nyquist frequency
f0 = f_cut_off/f_nyq; %% normalized cut-off frequency

%%The fir1 function is used to create the filter
%If f0 is a scalar, then fir1 designs a lowpass or highpass filter with cutoff frequency f0.
%The cutoff frequency is the frequency at which the normalized gain of the filter is –6 dB.
%Filter coefficients b, returned as a row vector of length n + 1 
b=fir1(N, f0) %% get filter coefficients B(z) = b(1)+ b(2)z + … + b(n+1)z^(–n)

% hl: Frequency response, returned as a vector. If you specify n,
% then h has length n. If you do not specify n, or specify n 
% as the empty vector, then h has length 512.
% If the input to freqz is single precision, the function
% computes the frequency response using single-precision 
% arithmetic. The output h is single precision.

%w1: angular frequencies, returned as a vector. w has values ranging from 0
%to ?. If you specify 'whole' in your input, the values in w range from 0 
%to 2?. If you specify n, w has length n. If you do not specify n, or 
%specify n as the empty vector, w has length 512.

[h1, w1]=freqz(b); %% get the transfer function of the designed filter
lunghezza_freq_resp=length(h1)
lunghezza_ang_freq=length(w1)


%% Now we need to quantize the filter
%Y = floor(X) rounds each element of X to the nearest integer less than or equal to that element.
bi=floor(b*2^(nb-1)) %% convert coefficients into nb-bit integers
bq=bi/2^(nb-1) %% convert back coefficients as nb-bit real values
[h2, w2]=freqz(bq); %% get the transfer function of the quantized filter

%% show the transfer functions
plot(w1/pi, 20*log10(abs(h1))); 
hold on;
plot(w2/pi, 20*log10(abs(h2)),'r--');
grid on;
xlabel('Normalized frequency');
ylabel('dB');
legend('Designed filter', 'Quantized filter')






