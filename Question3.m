
%% Question 3

clc
clear all

run lifecycle.m

rng(0,'twister');

%Create path of shocks:

z=1+sqrt(0.05)*randn(10,10);

% Section 1: Functional Forms

     sigma=2;  % c^(1-sigma)/(1-sigma)
     beta=.9;
     r=1/beta-1;

% Life span     

T=10;

% wage vector

wvector=[0.5 0.5 ...
    0.75 0.75...
    1 1 ...
    0.75 0.75...
    0.25 0.25];

%Profile of wages

for k=1:10
    for j=1:10
wprofile(k,j)=z(k,j)*wvector(k);
    end
end

wprofile=wprofile';

% Asset grid

Amin=0;
Amax=1;
n=300;
A=linspace(Amin,Amax,n);

V=zeros(n,T);
g=zeros(n,T-1);

for h=1:10

C = A' + wprofile(h,T);
 U=(C.^(1-sigma))/(1-sigma);
  V(:,T)=U;

 for i=1:T-1;

     I = A'+ wprofile(h,T-i);
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
     
for i=1:T-1     
     savingdec(i)=A(g(assetlevelindex,i));
       assetlevelindex=g(assetlevelindex,i);
        assetlevel(i+1)=A(assetlevelindex);
end

SavingDec(:,h)=savingdec;
AssetLevel(:,h)=assetlevel;


plot(savingdec)
hold on
plot(assetlevel)
hold off

disp('age asset asset+wage savings consumption')
[(1:T)'  assetlevel assetlevel+wprofile(h,:)'  savingdec assetlevel+wprofile(h,:)'-savingdec]

Copt= assetlevel+wprofile(h,:)'-savingdec;

COPT(:,h)=Copt;

plot(1:T,wprofile(h,:))
hold
plot(1:T,Copt)
title('wages and the optimal consumption decision')
xlabel('age')

end

plot(COPT);
hold on
plot(Coptdet,'color','red','LineWidth',6);
hold off
