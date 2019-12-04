% BCH�������Berlekamp-Massey and Chien����,BCH�����������׼,
% ��ģ����Ҫ�������ȶ�������ɵ����ݽ��б����ڷֱ��ڴ��䲻ͬ���볤�½��е�������ڲ�ͬ���������δ����Ͳ�ͬ���ȵı�������ͬ��������±���õ��������ʵĴ�С֮�����ϵ��
function [ber]=bchmodel(m,k,snr)
n=2^m-1;
period=1000;
nwords=ceil(1000/k);
[genploy,t]=bchgenpoly(n,k);%�ҵ��ܾ����Ĵ���ĸ�����BCH������ɶ���ʽ
simplified=1;
alpha=gf(2,m);%����٤����������
zero=gf(0,m);
one=gf(1,m);
message=randi(1,nwords*k);
message1=gf(message);
decoded_data=gf(zeros(1,nwords*k));
%����alpha_tb������
alpha_tb=gf(zeros(1,2*t),m);
for i=1:2*t
    alpha_tb(i)=alpha^(2*t-i+1);
end

for j=1:nwords
    encoded_data((j-1)*n+1:(j-1)*n+n)=bchencoder(message((j-1)*k+1:(j-1)*k+k),genploy,n,k);
end
%��������
sigma=sqrt(1/(10^(snr/10))/2);
datalength=length(encoded_data);
snum=ceil(datalength/period);
for i=1:snum-1
    data2((i-1)*period+1:(i-1)*period+period)=encoded_data((i-1)*period+1:(i-1)*period+period)+sigma*randn(1,period);
end
data2((snum-1)*period+1:datalength)=encoded_data((snum-1)*period+1:datalength)+sigma*randn(1,length(encoded_data((snum-1)*period+1:datalength)));
%�˶γ�����Ҫ���жϴ��ź��Ƿ��Ǵ����,���������ݺ�ԭ�������ݽ��жԱ�,�������˴���,����ȡ����
rec_data2=zeros(1,nwords*n);
for i=1:nwords*n
    if abs(encoded_data(i)-data2(i))>0.5
    rec_data2(i)=xor(encoded_data(i),1);
    else
    rec_data2(i)=encoded_data(i);
    end
end


%��ʼ����
rec_data2=gf(rec_data2,m);
for j=1:nwords
    rec_data=rec_data2((j-1)*n+1:(j-1)*n+n);%������ն���ʽ
    syndrome=gf(zeros(1,2*t),m);
    for i=1:n
        syndrome=syndrome.*alpha_tb+rec_data(n-i+1);%ͨ�����ն���ʽ��������ɶ���ʽ
    end
    lambda=gf([1,zeros(1,t)],m);
    lambda0=lambda;
    b=gf([0,1,zeros(1,t)],m);
    b2=gf([0,0,1,zeros(1,t)],m);
    k1=0;
    gamma=one;
    delta=zero;
    syndrome_array=gf(zeros(1,t+1),m);
if(simplified==1)
    for r=1:t
        r1=2*t-2*r+2;
        r2=min(r1+t,2*t);
        num=r2-r1+1;
        syndrome_array(1:num)=syndrome(r1:r2);
        delta=syndrome_array*lambda';
        lambda0=lambda;
        lambda=gamma*lambda-delta*b2(2:t+2);
    if (delta~=zero)&&(k1>=0)
    b2(3)=zero;
    b2(4:3+t)=lambda0(1:t);
    gamma=delta;
    k1=-k1;
    else
    b2(3:3+t)=b2(1:t+1);
    gamma=gamma;
    k1=k1+2;
    end
    joke=1;
    end
else
    for r=1:2*t
    r1=2*t-r+l;
    r2=min(r1+t,2*t);
    num=r2-r1+1;
    syndrome_array(1:num)=syndrome(r1:r2);
    delta=syndrome_array*lambda';
    lambda0=lambda;
    lambda=gamma*lambda-delta*b(1:t+1);
    if ((delta~=zero)&&(k1>=0))
    b(2:2+t)=lambda0;
    gamma=delta;
    k1=-k1-1;
    else
    b(2:2+t)=b(1:t+1);
    gamma=gamma;
    k1=k1+1;
    end
    joke=1;
    end
end
    inverse_tb=gf(zeros(1,t+1),m);
    for i=1:t+1
    inverse_tb(i)=alpha^(-i+1);
    end
    lambda_v=zero;
    accu_tb=gf(ones(1,t+1),m);
    for i=1:n
        lambda_v=lambda* accu_tb';
        accu_tb=accu_tb.*inverse_tb;
    if(lambda_v==zero)
        error(1,n-i+1)=1;
    else
        error(1,n-i+1)=0;
    end
    end
    found=find(error(1,:)~=0);
    for i=1:length(found)
    location=found(i);
    if location<=k
        rec_data(n-location+1)=rec_data(n-location+1)+one;
    end
    end
    decoded_data((j-1)*k+1:(j-1)*k+k)=rec_data(n-k+1:n);
end
error=0;
for i=1:length(message)
    if message(i)~=decoded_data(i)
        error=error+1;
    end
end
ber=error/length(message);