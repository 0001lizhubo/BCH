% % % % % % % % % % BCH(127,71)%%%%%%%%%%
m=7;
k=71;
SNRinddB=0:1:9;
ber=zeros(1,length(SNRinddB));
echo on
for i=1:length(SNRinddB)
    ber(i)=bchmodel(m,k,SNRinddB(i));
end
semilogy(SNRinddB,ber,'*r-');
hold on

% % % % % % % % % UNCODED%%%%%%%%%%%
for i=1:length(SNRinddB)
ber(i)=bchuncoded(m,k,SNRinddB(i));
end
semilogy(SNRinddB,ber,'*g-');
hold on
% % % % % % BCH(63,36)%%%%%
m=6;
k=36;
for i=1:length(SNRinddB)
    ber(i)=bchmodel(m,k,SNRinddB(i));
end
semilogy(SNRinddB,ber,'sb-');
legend('(127,71)','(63,36)','bchuncoded');
xlabel('SNR');
ylabel('BER');
hold off





