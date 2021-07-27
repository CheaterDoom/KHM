clc
close all
clear 

%Erlant Wandresson Farias Gurjão-------------------------------------------
k=51.75e3;
f=2.2e6:k:212e6;
d=[50/1000,200/1000];
%dados---------------------------------------------------------------------
PSD_tx=-76.*ones(1,length(f));
BgNoise=-140.*ones(1,length(f));
GapSnr=9.75;
MargSnr=6;
GainSnr=5;
%CAD55 KHM-----------------------------------------------------------------
h1=106.5050;
h2=5.9318e+03;
k1=0.00185;
k2=1.20594e-07;
k3=3.11222e-05;

%parametros secundarios----------------------------------------------------
fsqrt=f.^0.5;
w=(2*pi).*f;
a2=(k2*2/pi).*f;

alfa=(k1.*fsqrt)+k2.*f;
beta=(k1.*fsqrt)-(a2.*log(f))+k3.*f;

RZ0=h1+h2.*(1./fsqrt);
IZ0=-h2.*(1./fsqrt);
R0=RZ0+j.*IZ0;


gamma=alfa+j.*beta;
gamma1=abs(gamma);
HV50=exp(-d(1).*gamma);
HV200=exp(-d(2).*gamma);

H50=20.*log10(abs(HV50));
H200=20.*log10(abs(HV200));

PSD_trans=10.^(PSD_tx./10);


PSD_r50=PSD_trans.*(abs(HV50).^2);
PSD_r200=PSD_trans.*(abs(HV200).^2);

%Conversão Log - Linear----------------------------------------------------
PSD_rx50=10.*log10(abs(PSD_r50));
PSD_rx200=10.*log10(abs(PSD_r200));
Ruido=10.^(BgNoise./10);
Gap=10.^(GapSnr./10);
Marg=10.^(MargSnr./10);
Ganho=10.^(GainSnr./10);

%--------------------------------------------------------------------------
%GAMMA=Gap+(Marg-Ganho);
GAMMA=10.^((GapSnr+(MargSnr-GainSnr))./10);

b50=floor(log2(1+(PSD_r50./(GAMMA.*Ruido))));
b200=floor(log2(1+(PSD_r200./(GAMMA.*Ruido))));
%--------------------------------------------------------------------------
i=1;
u=length(f)+1;

while i<u
    test1=b50(1,i);
    test2=b200(1,i);
    if test1>=12
       B50(1,i)=12;
    
    elseif test1<=1
       B50(1,i)=1;
    else
       B50(1,i)=b50(1,i); 
    end
    
    if test2>=12
       B200(1,i)=12;
    
    elseif test2<=1
       B200(1,i)=1;
    else
       B200(1,i)=b200(1,i); 
    end



i=i+1;

end

out='Taxa de transmissão 50m'
R50=k*sum(B50)

out='Taxa de transmissão 200m'
R200=k*sum(B200)



%--------------------------------------------------------------------------
%{
figure

plot(f,gamma1)
title('|Constante de propagação| gama(f)')
ylabel('Neper');
xlabel( 'Freq(Hz)' );

figure
plot(f,abs(R0))
title('Impedância Característica')
ylabel('Ohm');
xlabel( 'Freq(Hz)' );
%}


figure
plot(f,H50)
title('Função de Transferência H(f) 50m')
ylabel('dB');
xlabel( 'Freq(Hz)' );


figure
plot(f,H200)
title('Função de Transferência H(f) 200m')
ylabel('dB');
xlabel( 'Freq(Hz)' );


figure
plot(f,PSD_tx)
title('PSD Transmitida')
ylabel('dBm');
xlabel( 'Freq(Hz)' );

figure
plot(f,PSD_rx50)
title('PSD Recebida 50m')
ylabel('dBm');
xlabel( 'Freq(Hz)' );

figure
plot(f,PSD_rx200)
title('PSD Recebida 50m')
ylabel('dBm');
xlabel( 'Freq(Hz)' );

figure
plot(f,PSD_rx200)
title('PSD Recebida 200m')
ylabel('dBm');
xlabel( 'Freq(Hz)' );

figure
plot(f,B50)
title('Bitloading 50m')
ylabel('Bits');
xlabel( 'Freq(Hz)' );

figure
plot(f,B200)
title('Bitloading 200m')
ylabel('Bits');
xlabel( 'Freq(Hz)' );