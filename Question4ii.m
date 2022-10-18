
clear all;% this clears variables from the workspace


% Section 1: Functional Forms

     sigma=2;  % c^(1-sigma)/(1-sigma)
     beta=.9;
     r=1/beta-1;

% Life span     

T=95-25;

% wage vector

T = readtable('merged.xls','Range','G1:G83');

wvector=[T{25:63,1};zeros(32,1)];
T=71;
Amin=0;
Amax=1;
n=300;
A=linspace(Amin,Amax,n);

V=zeros(n,T);
 g=zeros(n,T-1);

C = A' + wvector(T);
 U=(C.^(1-sigma))/(1-sigma);
  V(:,T)=U;

for i=1:T-1;
    
    I = A'+ wvector(T-i);
     I=(I*ones(1,n))';
      C=I-(A'*ones(1,n))/(1+r);
        
       U=ones(n,n)*(-10000);
       
        for j=1:n;
         for   k=1:n;
           if C(j,k)>0;   
            U(j,k)=C(j,k).^(1-sigma)/(1-sigma);
           end
        end
       end
    
       
    [Vmax gmax] = max(U + beta*V(:,T-i+1)*ones(1,n));
         
    V(:,T-i)=Vmax';
    g(:,T-i)=gmax';    
    
end

savingdec=zeros(T,1);
 assetlevel=zeros(T,1);
    assetlevelindex=1;  
     
for i=1:T-1;     
     savingdec(i)=A(g(assetlevelindex,i));
       assetlevelindex=g(assetlevelindex,i);
        assetlevel(i+1)=A(assetlevelindex);
end

savingdecdet=savingdec;
assetleveldet=assetlevel;

plot(savingdec)
hold on
plot(assetlevel)
hold off

disp('age asset asset+wage savings consumption')
[(1:T)'  assetlevel assetlevel+wvector'  savingdec assetlevel+wvector'-savingdec]

Copt= assetlevel+wvector'-savingdec;
Coptdet=Copt;
plot(1:T,wvector)
hold
plot(1:T,Copt)
title('wages and the optimal consumption decision')
xlabel('age')
