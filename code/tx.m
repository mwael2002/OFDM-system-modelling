clear all;
close all;

no_bits=input('Please enter number of bits less than or equal to 512: ');

% Define Constats
fft_size=1024;
cp_size=4;
conv_ratio=2;
N=no_bits*conv_ratio;

% PN
initial_state=zeros(1,23);
initial_state(1:23)=1;
pnSequence = comm.PNSequence('Polynomial', 'x^23+x^5+1', 'InitialConditions',initial_state, 'SamplesPerFrame', no_bits);
out_pn=pnSequence();

%Convolutional encoder
trellis = poly2trellis(3,[6 7]);
out_conv = convenc(out_pn,trellis);

% Scrambler
initial_state_scramb=zeros(1,9);
initial_state_scramb(1:9)=1;
scramb0 = comm.Scrambler(2, 'x^9+x^2+1', initial_state_scramb);
out_scramb=scramb0(out_conv);

% Interleaver
initial_interlev=4831;
out_interlev = randintrlv(out_scramb,initial_interlev);


% Modulation
bpskModulator = comm.BPSKModulator;
qpskModulator = comm.QPSKModulator('BitInput',true);

num_padded_zeros_qpsk=(ceil(N/2)-(N/2)) *2;
num_padded_zeros_16_qam=(ceil(N/4)-(N/4)) *4;
num_padded_zeros_64_qam=(ceil(N/6)-(N/6)) *6;


out_mod_bpsk=bpskModulator(out_interlev);
out_mod_qpsk=qpskModulator([out_interlev; zeros(fix(num_padded_zeros_qpsk),1)]);
out_mod_16_qam=qammod([out_interlev; zeros(fix(num_padded_zeros_16_qam),1)],16,'InputType','bit','UnitAveragePower',true);
out_mod_64_qam=qammod([out_interlev; zeros(fix(num_padded_zeros_64_qam),1)],64,'InputType','bit','UnitAveragePower',true);

%IFFT
out_ifft_bpsk=ifft(out_mod_bpsk,fft_size);
out_ifft_qpsk=ifft(out_mod_qpsk,fft_size);
out_ifft_16_qam=ifft(out_mod_16_qam,fft_size);
out_ifft_64_qam=ifft(out_mod_64_qam,fft_size);

%CP
out_ifft_bpsk_cp=[out_ifft_bpsk(fft_size-cp_size+1:end); out_ifft_bpsk];
out_ifft_qpsk_cp=[out_ifft_qpsk(fft_size-cp_size+1:end); out_ifft_qpsk];
out_ifft_16_qam_cp=[out_ifft_16_qam(fft_size-cp_size+1:end); out_ifft_16_qam];
out_ifft_64_qam_cp=[out_ifft_64_qam(fft_size-cp_size+1:end); out_ifft_64_qam];