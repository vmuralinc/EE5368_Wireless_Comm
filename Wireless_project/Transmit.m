function[mSignalTx] = Transmit(mInfoBitsTx)

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
