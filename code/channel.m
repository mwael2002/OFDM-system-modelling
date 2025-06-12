snr_db_arr=[0 5 10 15 20 25 30 35 40 45 50]; 

for i=1:11
out_noisy_bpsk_arr(i,:)=awgn(out_ifft_bpsk_cp,snr_db_arr(i),0,3);
out_noisy_qpsk_arr(i,:)=awgn(out_ifft_qpsk_cp,snr_db_arr(i),0,3);
out_noisy_16_qam_arr(i,:)=awgn(out_ifft_16_qam_cp,snr_db_arr(i),0,3);
out_noisy_64_qam_arr(i,:)=awgn(out_ifft_64_qam_cp,snr_db_arr(i),0,3);
end


h1=[2 2.5 3];
h2=[10 2 1.5];
h1=h1./norm(h1);
h2=h2./norm(h2);

for i=1:11
out_noisy_bpsk_p1_arr(i,:)=conv(out_noisy_bpsk_arr(i,:),h1);
out_noisy_qpsk_p1_arr(i,:)=conv(out_noisy_qpsk_arr(i,:),h1);
out_noisy_16_qam_p1_arr(i,:)=conv(out_noisy_16_qam_arr(i,:),h1);
out_noisy_64_qam_p1_arr(i,:)=conv(out_noisy_64_qam_arr(i,:),h1);

out_noisy_bpsk_p2_arr(i,:)=conv(out_noisy_bpsk_arr(i,:),h2);
out_noisy_qpsk_p2_arr(i,:)=conv(out_noisy_qpsk_arr(i,:),h2);
out_noisy_16_qam_p2_arr(i,:)=conv(out_noisy_16_qam_arr(i,:),h2);
out_noisy_64_qam_p2_arr(i,:)=conv(out_noisy_64_qam_arr(i,:),h2);

end