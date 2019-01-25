function[mFilteredSignalRx] = MatchedFilter(mSignalRx,mPulseShaping)
    
mPulseShapingLen = length(mPulseShaping);

mSignalConvRx = conv(mSignalRx,mPulseShaping);

mSignalRxLen = length(mSignalConvRx);

mFilteredSignalRx = mSignalConvRx(((mPulseShapingLen + 1)/2):(mSignalRxLen - ((mPulseShapingLen - 1)/2)));