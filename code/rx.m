close all;
bpsk_demod = comm.BPSKDemodulator;
qpsk_demod = comm.QPSKDemodulator('BitOutput',true);
%Descrambler
descramb = comm.Descrambler(2, 'x^9+x^2+1', initial_state_scramb);

out_noisy_bpsk_arr_multi=(out_noisy_bpsk_p1_arr+out_noisy_bpsk_p2_arr)./2;
out_noisy_qpsk_arr_multi=(out_noisy_qpsk_p1_arr+out_noisy_qpsk_p2_arr)./2;
out_noisy_16_qam_arr_multi=(out_noisy_16_qam_p1_arr+out_noisy_16_qam_p2_arr)./2;
out_noisy_64_qam_arr_multi=(out_noisy_64_qam_p1_arr+out_noisy_64_qam_p2_arr)./2;

channel_equalize=(fft(h1,fft_size)+fft(h2,fft_size))./2;

% Remove CP
for i=1:11
out_bpsk_no_cp(i,:)=out_noisy_bpsk_arr_multi(i,cp_size+1:end);
out_qpsk_no_cp(i,:)=out_noisy_qpsk_arr_multi(i,cp_size+1:end);
out_16_qam_no_cp(i,:)=out_noisy_16_qam_arr_multi(i,cp_size+1:end);
out_64_qam_no_cp(i,:)=out_noisy_64_qam_arr_multi(i,cp_size+1:end);
end

for i=1:11
out_fft_bpsk=fft(out_bpsk_no_cp(i,:).',fft_size);
out_fft_bpsk=out_fft_bpsk./channel_equalize.';
scatterplot(out_fft_bpsk);
out_demod_bpsk=bpsk_demod(out_fft_bpsk);
out_deinterlev=randdeintrlv(out_demod_bpsk(1:N),initial_interlev);
out_descramb=descramb(out_deinterlev);
out_viterbi = vitdec(out_descramb,trellis,15,'trunc','hard');
[dummy,ber_bpsk_arr(i)]=biterr(out_viterbi,out_pn);
end

for i=1:11
out_fft_qpsk=fft(out_qpsk_no_cp(i,:).',fft_size);
out_fft_qpsk=out_fft_qpsk./channel_equalize.';
scatterplot(out_fft_qpsk(1:fft_size/2));
out_demod_qpsk=qpsk_demod(out_fft_qpsk(1:fft_size/2));
out_deinterlev=randdeintrlv(out_demod_qpsk(1:N),initial_interlev);
out_descramb=descramb(out_deinterlev);
out_viterbi = vitdec(out_descramb,trellis,15,'trunc','hard');
[dummy,ber_qpsk_arr(i)]=biterr(out_viterbi,out_pn);
end


for i=1:11
out_fft_16_qam=fft(out_16_qam_no_cp(i,:).',fft_size);
out_fft_16_qam=out_fft_16_qam./channel_equalize.';
scatterplot(out_fft_16_qam(1:fft_size/4));
out_demod_16_qam=qamdemod(out_fft_16_qam(1:fft_size/4),16,'UnitAveragePower',true,OutputType='bit');
out_deinterlev=randdeintrlv(out_demod_16_qam(1:N),initial_interlev);
out_descramb=descramb(out_deinterlev);
out_viterbi = vitdec(out_descramb,trellis,15,'trunc','hard');
[dummy,ber_16_qam_arr(i)]=biterr(out_viterbi,out_pn);
end

for i=1:11
out_fft_64_qam=fft(out_64_qam_no_cp(i,:).',fft_size);
out_fft_64_qam=out_fft_64_qam./channel_equalize.';
scatterplot(out_fft_64_qam(1:ceil(fft_size/6)));
out_demod_64_qam=qamdemod(out_fft_64_qam(1:ceil(fft_size/6)),64,'UnitAveragePower',true,OutputType='bit');
out_deinterlev=randdeintrlv(out_demod_64_qam(1:N),initial_interlev);
out_descramb=descramb(out_deinterlev);
out_viterbi = vitdec(out_descramb,trellis,15,'trunc','hard');
[dummy,ber_64_qam_arr(i)]=biterr(out_viterbi,out_pn);
end


figure
plot(snr_db_arr,ber_bpsk_arr);
hold on
plot(snr_db_arr,ber_qpsk_arr);
hold on;
plot(snr_db_arr,ber_16_qam_arr);
hold on;
plot(snr_db_arr,ber_64_qam_arr);

ylabel("BER");
xlabel("SNR (dB)");
title("SNR (dB) vs BER");
legend('BPSK','QPSK','16QAM','64QAM');