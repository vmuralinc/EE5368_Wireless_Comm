function[mSymbolsTx] = QpskModulation(mBurstTx,mBurstLen)

mSymbolsTx = zeros(1,(mBurstLen/2));

mCount=0;

for mIndex = 1:mBurstLen/2
    
    mCount=mCount+1;
    
    if mBurstTx(2*mIndex-1) == 0
        
        if mBurstTx(2*mIndex) == 0
        
            mSymbolsTx(mCount) = 1;
        
        elseif mBurstTx(2*mIndex) == 1
        
            mSymbolsTx(mCount) = j;
                
        end
        
    elseif mBurstTx(2*mIndex-1) == 1
        
        if mBurstTx(2*mIndex) == 1
        
            mSymbolsTx(mCount) = -1;
        
        elseif mBurstTx(2*mIndex) == 0
        
            mSymbolsTx(mCount) = -j;
                
        end
    end
end