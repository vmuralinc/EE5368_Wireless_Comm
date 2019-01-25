function[mBurstRx] = QpskDemodulation(mSymbolsRx,mSymbolsRxLen)

mBurstRx = zeros(1,mSymbolsRxLen*2);
mCount = 1;

for mIndex = 1:mSymbolsRxLen
    
    if mSymbolsRx(1,mIndex) == 1
        
        mBurstRx(mCount) = 0;
        mBurstRx(mCount+1) = 0;
        
    elseif mSymbolsRx(1,mIndex) == j
        
        mBurstRx(mCount) = 0;
        mBurstRx(mCount+1) = 1;
    
    elseif mSymbolsRx(1,mIndex) == -1
        
        mBurstRx(mCount) = 1;
        mBurstRx(mCount+1) = 1;

    elseif mSymbolsRx(1,mIndex) == -j
        
        mBurstRx(mCount) = 1;
        mBurstRx(mCount+1) = 0;
       
    end
    mCount = mCount + 2;
end