% 子程序bchencoder此模块主要功能是对随机生成的消息进行编码,并将编码结果返回到bchmodel中
function code=bchencoder(data,genpoly,n,k)
bb=zeros(1,n-k);
for i=k:-1:1
    feedback=xor(data(i),bb(n-k));
    if feedback~=0
        for j=n-k:-1:2
            if genpoly(n-k-j+2)~=0
                bb(j)=xor(bb(j-1),feedback);
            else
                bb(j)=bb(j-1);
            end
        end
        bb(1)=feedback;
    else
        for j=n-k:1:2
        bb(j)=bb(j-1);
        end
    bb(1)=feedback;
    end
end
code=[bb,data];