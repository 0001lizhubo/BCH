% ×Ó³ÌĞòbchuncoded
function [ber]=bchuncoded(m,k,snr)
n=2^m-1;
period=1000;
nwords=ceil(100000/k);
message=randn(1,nwords*k);
sigma=sqrt(1/(10^(snr/10))/2);
tran_data=message+sigma*randn(1,nwords*k);
rec_data=zeros(1,nwords*k);
for i=1:nwords*k
    if abs(tran_data(i)-message(i))>0.5
        rec_data(i)=xor(message(i),1);
    else
        rec_data(i)=message(i);
    end
end
error=0.;
for i=1:length(message)
if message(i)~=rec_data(i)
error=error+1;
end
end
ber=error/length(message);
        
        
        
        
        
        