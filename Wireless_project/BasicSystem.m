clear all
%generate information bits 

%mInfoBitsTx = randint(1,1000);

Energy = zeros(1,100);
Eng = 0;
for i=1:1:100
%generate noise
mInfoBitsTx = randint(1,1000);

%generate guard bits

mGuardBitsTx = zeros(1,6);

%generate unique word

a = [1,0,1,1,0,1,0,0];

mUniqueWordTx = [a,a,a,a,a,a,a,a,a,a];

% generate burst

mBurstTx = [mGuardBitsTx,mUniqueWordTx,mInfoBitsTx,mGuardBitsTx];

%modulation

mSymbolsTx = QpskModulation(mBurstTx,length(mBurstTx));

% upsampling

mUpSamples = upsample(mSymbolsTx,16);
 
% Generate a square root rcosine filter system

mPulseShaping = rcosine(1,16,'sqrt',0.35);

% Pulse shaping

mSignalTx = PulseShaping(mUpSamples,mPulseShaping);

% channel
mNoise = randn(1,8736);% complex(randn(1,8736),randn(1,8736));

mSignalRx = mSignalTx;

% Matched filter
%mFilteredSignalRx = MatchedFilter(mNoise,mPulseShaping);
mFilteredSignalRx = MatchedFilter(mSignalRx,mPulseShaping);

% downsampling

mSymbolsRx = downsample(mFilteredSignalRx,16); 

Energy(i) = var(mSymbolsRx);
Eng = Eng + Energy(i);
end
Eng
Eng/100

%demodulation

%mBurstRx = QpskDemodulation(mSymbolsRx,length(mSymbolsRx));

%mGuardBitsRxFront = mBurstRx(1,1:6);

%mUniqueWordRx = mBurstRx (1,7:86);

%mInfoBitsRx = mBurstRx(1,87:1086);

%mGuardBitsRxRear = mBurstRx(1,1087:1092);

%result=(mInfoBitsRx==mInfoBitsTx);