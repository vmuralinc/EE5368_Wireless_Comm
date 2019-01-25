function[mSignalTx] = PulseShaping(mUpSamples,mPulseShaping)
    
mPulseShapingLen = length(mPulseShaping);

mSignalConvTx = conv(mUpSamples,mPulseShaping);

mUpSamplesLen = length(mSignalConvTx);

mSignalTx = mSignalConvTx(((mPulseShapingLen + 1)/2):(mUpSamplesLen - ((mPulseShapingLen - 1)/2)));
