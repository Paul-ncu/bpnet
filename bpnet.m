
clc             % ����

clear all;      % ����ڴ��Ա�ӿ������ٶ�

close all;      % �رյ�ǰ����figureͼ��

warning off;    % ����û�б�Ҫ�ľ���

SamNum=20;      % ������������Ϊ20

TestSamNum=20;  % ������������Ҳ��20

ForcastSamNum=6;% Ԥ����������Ϊ2

HiddenUnitNum=8;% �м�����ڵ�����ȡ8

InDim=2;        % ��������ά��Ϊ3

OutDim=1;       % �������ά��Ϊ2

 

% ԭʼ����

% �˵�ѹ

sqddy=[12.503 12.531 12.497 12.447 12.350 12.308 12.254 12.215 12.107 12.071 11.947 11.899 11.796 11.718 11.609 11.513 11.397 11.238 11.138 10.971];

% ����

sqnz=[1006.67 1008.16 1009.25 1011.55 1013.62 1015.42 1018.81 1021.75 1025.81 1028.82 1040.63 1044.04 1043.73 1052.94 1057.07 1066.34 1072.37 1078.45 1088.13 1100.6];

% ����ֵ

smz=[1.0024 0.9991 0.9953 0.9927 0.9880 0.9833 0.9810 0.9735 0.9672 0.9603 0.9529 0.9448 0.9335 0.9256 0.9173 0.9078 0.8892 0.8754 0.8554 0.8393];
 

p=[sqddy;sqnz];  % �������ݾ���

t=[smz];         % Ŀ�����ݾ���

[SamIn,minp,maxp,tn,mint,maxt]=premnmx(p,t); % ԭʼ�����ԣ�������������ʼ��

 

rand('state',sum(100*clock));   % ����ϵͳʱ�����Ӳ��������

NoiseVar=0.01;                  % ����ǿ��Ϊ0.01�����������Ŀ����Ϊ�˷�ֹ���������ϣ�

Noise=NoiseVar*randn(2,SamNum); % ��������

SamOut=tn+Noise;                % ��������ӵ����������

 

TestSamIn=SamIn;                % ����ȡ�������������������ͬ����Ϊ��������ƫ��

TestSanOut=SamOut;              % Ҳȡ������������������ͬ

 

MaxEpochs=50000;                % ���ѵ������Ϊ50000

lr=0.035;                       % ѧϰ����Ϊ0.035     

E0=0.65*10^(-3);                % Ŀ�����Ϊ0.65*10^(-3)

W1=0.5*rand(HiddenUnitNum,InDim)-0.1;% ��ʼ���������������֮���Ȩֵ

B1=0.5*rand(HiddenUnitNum,1)-0.1;% ��ʼ���������������֮���Ȩֵ

W2=0.5*rand(OutDim,HiddenUnitNum)-0.1;% ��ʼ���������������֮���Ȩֵ

B2=0.5*rand(OutDim,1)-0.1;% ��ʼ���������������֮���Ȩֵ

 

ErrHistory=[];  % ���м����Ԥ��ռ���ڴ�

for i=1:MaxEpochs          

    HiddenOut=logsig(W1*SamIn+repmat(B1,1,SamNum)); % �������������

    NetworkOut=W2*HiddenOut+repmat(B2,1,SamNum);   %������������

    Error=SamOut-NetworkOut;  % ʵ��������������֮��

    SSE=sumsqr(Error);   % ��������(���ƽ����)

    ErrHistory=[ErrHistory SSE];

    if SSE<E0,break,end  % ����ﵽ���Ҫ��������ѧϰѭ��

    

    % ����6����BP��������ĵĳ���

    % ������Ȩֵ����ֵ�����������������ݶ��½�ԭ��������ÿһ����̬����

    Delta2=Error;

    Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);

    % ���������������֮���Ȩֵ����ֵ��������

    dW2=Delta2*HiddenOut';

    dB2=Delta2*ones(SamNum,1);

    % ���������������֮���Ȩֵ����ֵ��������

    dW1=Delta1*SamIn';

    dB1=Delta1*ones(SamNum,1);

    

    W2=W2+lr*dW2;

    B2=B2+lr*dB2;

    

    W1=W1+lr*dW1;

    B1=B1+lr*dB1;

    

end

 

HiddenOut=logsig(W1*SamIn+repmat(B1,1,TestSamNum));  % ������������ս��

NetworkOut=W2*HiddenOut+repmat(B2,1,TestSamNum);     % �����������ս��

a=postmnmx(NetworkOut,mint,maxt);                    % ��ԭ���������Ľ��

x=1:20;                                         % ʱ����̶�

newk=a(1,:);                                         % �������������

% newh=a(2,:);                                         % �������������

figure;

subplot;plot(x,newk,'r-o',x,smz,'b--+');  % ���ƹ�·�������Ա�ͼ

legend('�����������ֵ','ʵ������ֵ');

xlabel('�������'); ylabel('����ֵ');

title('Դ���������������ѧϰ�Ͳ��ԶԱ�ͼ');

 

% subplot(2,1,2);plot(x,newh,'r-o',x,glhyl,'b--+');  % ���ƹ�·�������Ա�ͼ
% 
% legend('�������������','ʵ�ʻ�����');
% 
% xlabel('���'); ylabel('������/����');
% 
% title('Դ���������������ѧϰ�Ͳ��ԶԱ�ͼ');

 

% ����ѵ���õ����ݽ���Ԥ��

% ����ѵ���õ������������pnew����Ԥ��ʱ��ҲӦ����Ӧ�Ĵ���

pnew=[10.822 10.729 10.564 10.409 10.278 10.093 

   1109.9 1119.69 1132.95 1147.54 1159.75 1177.83];   % 2010���2011����������

pnewn=tramnmx(pnew,minp,maxp);  %����ԭʼ�������ݵĹ�һ�������������ݽ��й�һ��

HiddenOut=logsig(W1*pnewn+repmat(B1,1,ForcastSamNum));  % ���������Ԥ����

anewn=W2*HiddenOut+repmat(B2,1,ForcastSamNum);          % ��������Ԥ����

% ������Ԥ��õ������ݻ�ԭΪԭʼ��������

format short

anew=postmnmx(anewn,mint,maxt)


