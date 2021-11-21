clear all
clc
fco=2000;
fs=10000; %% sampling frequency
f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)

p=1;
%%Names in alphabetic order: Filandra, Noto, Potenza
x=8;
y=4;

N=(2^p)*[mod(x,2)+1]+6*p %% filter order N=8
nb=mod(y,7)+8 %% number of bits nb=12

%now we consider a large period T and then we consider
%a window of time samples that goes from 0 to 10*T divided
%in 1/fs small periods

T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

%Then we create the various samples of the signals
x1=sin(2*pi*f1*tt); %% first sinewave
x2=sin(2*pi*f2*tt); %% second sinewave

%The input signal x will be made of 201 samples
x=(x1+x2)/2; %% input signal samples

[bi, bq]=myfir_design(N, nb); %% filter design

%% Signal application to the quantized filter
y=filter(bq, 1, x); %% apply filter

%% plots
figure
plot(tt,x1,'--d');
hold on
plot(tt,x2,'r--s');
plot(tt,x, 'g--+');
plot(tt, y, 'c--o');

legend('x1', 'x2', 'x', 'y')

%% quantize input and output
xq=floor(x*2^(nb-1)); %% convert coefficients into nb-bit integers
idx=find(xq==2^(nb-1));
xq(idx)=2^(nb-1)-1;

yq=floor(y*2^(nb-1));
idy=find(yq==2^(nb-1));
yq(idy)=2^(nb-1)-1;

figure
thd(yq)

%% save input and output
fp=fopen('samples.txt','w');
fprintf(fp,'%d\n', xq);
fclose(fp);

fp=fopen('resultsm.txt', 'w');
fprintf(fp, '%d\n', yq);
fclose(fp);

%% In order to measure the THD for the file generated from the C program
%  we simply write 
    load output.txt;
    c_output = output;
    figure 
    thd(c_output)
                



