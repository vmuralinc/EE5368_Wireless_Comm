clear all
BERric = zeros(1,7);
for dbCount = 1:1:7
    snr = dbCount;
    TempBER = 0;
    for burstCount=1:1:1000
        %% transmission 

        %generate information bits 

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

        %es(i)=var(mSignalTx);

        %% generate rican fast fading channel 
        Tsample = 0.5 * 1 * 10 ^ (-3) / (546 * 16);

        Fm = 20;

        K = 7;

        mChannelRician = Rician(Tsample,Fm,K);

        % generate noise
        % snr = 10 log10(signalpower / (k^2 * noisepower)
        %snr = 7;

        signalPow = 0.9980;

        noisePow = 1.9908;

        k = sqrt((signalPow) / ((10^(snr/10)) * (noisePow)));

        mNoise = complex(k*randn(1,8736),k*randn(1,8736));

        % mix the signal with the channel

        mSignalRx = mSignalTx .* mChannelRician + mNoise;

        %% reception
        % Matched filter

        mFilteredSignalRx = MatchedFilter(mSignalRx,mPulseShaping);

        % downsampling

        mSymbolsRx = downsample(mFilteredSignalRx,16); 

        % BPSE

        mUwTx = mSymbolsTx(4:43);

        mUwRx = mSymbolsRx(4:43);

        mUwLen = length(mUwTx);

        mSigma = 0;

        for i=1:1:mUwLen

           mSigma = mSigma + (mUwTx(i) .* conj(mUwRx(i)));

        end

        theta = angle(mSigma / mUwLen);

        theta1 = theta;

        Nbpe = 45;

        Mbpe = 20;

        mBusrtLen = length(mSymbolsRx);

        mAngleArray = zeros(1,mBusrtLen);

        for i = 1 : Mbpe : (mBusrtLen - Nbpe)

            innerLen = i + Nbpe;

            mImagSignal = 0;

            mRealSignal = 0;

            for j = i : 1 : innerLen

                mImagSignal = mImagSignal + (imag(mSymbolsRx(j)) ^ 4);

                mRealSignal = mRealSignal + (real(mSymbolsRx(j)) ^ 4);

            end

            mAngle = atan(mImagSignal/mRealSignal) / 4;

            mTempAngles = [mAngle, (mAngle + (pi / 4)), (mAngle - (pi / 4)), (mAngle + (pi / 2)), (mAngle - (pi / 2)),   (mAngle + (3 * pi / 4)), (mAngle - (3 *pi /4)), (mAngle - pi)];

            [min_difference, array_position] = min(abs(mTempAngles - theta1));

            mAngleArray(i) = mTempAngles(array_position);

            theta1 = mAngleArray(i);

        end

        hm = mfilt.linearinterp(Mbpe);

        y = filter(hm,mAngleArray(1:Mbpe:(mBusrtLen - Nbpe)));
        mAngleArray1 = zeros(1,mBusrtLen);
        for i = 1:length(y)-Mbpe

            mAngleArray1(i) = y(i+Mbpe-1);

        end
        for i = length(y)-Mbpe+1:1:length(mAngleArray1)

            mAngleArray1(i) = y(length(y));

        end
        %stem(1:1:(mBusrtLen - Nbpe),mAngleArray(1:1:(mBusrtLen - Nbpe)));
        %figure(2);
        %plot(mAngleArray1);
        %disp('end');

        mSymbolsRx1 = zeros(1,length(mAngleArray1));

        %phase componsation
        for i = 1:1:length(mAngleArray1)
            mSymbolsRx1(i) = mSymbolsRx(i) .*exp(-j*mAngleArray1(i));
        end

        %hard-slicer
        mSymbolsRx2 = zeros(1,length(mAngleArray1));
        for i = 1:1:length(mSymbolsRx1)
            symbolAngle = angle(mSymbolsRx1(i));

            if  symbolAngle > pi
                symbolAngle = symbolAngle - 2*pi;
            elseif symbolAngle < -pi
                symbolAngle = symbolAngle + 2*pi;
            end


            if (symbolAngle >= 0 && symbolAngle < pi/4) || (symbolAngle >= -pi/4 && symbolAngle < 0) 
                mSymbolsRx2(i) = 1;
            elseif (symbolAngle >= pi/4 && symbolAngle < 3*pi/4) 
                mSymbolsRx2(i) = complex(0,1);
            elseif (symbolAngle >= 3*pi/4 && symbolAngle < pi) || (symbolAngle >= -pi && symbolAngle < -3*pi/4 )
                mSymbolsRx2(i) = -1;
            elseif (symbolAngle >= -3*pi/4 && symbolAngle < -pi/4) 
                mSymbolsRx2(i) = complex(0,-1);        
            else
                mSymbolsRx2(i) = 0;        
                disp('a');
            end
        end
%        result = (mSymbolsTx==mSymbolsRx2);
        
        %demodulation

        mBurstRx = QpskDemodulation(mSymbolsRx2,length(mSymbolsRx));

        %mGuardBitsRxFront = mBurstRx(1,1:6);

        %mUniqueWordRx = mBurstRx (1,7:86);

        mInfoBitsRx = mBurstRx(1,87:1086);

        %mGuardBitsRxRear = mBurstRx(1,1087:1092);
        
        TempBER = TempBER + (biterr(mInfoBitsTx,mInfoBitsRx)/length(mInfoBitsRx));
    end
    BERric(dbCount) = TempBER/1000;
end
BERtheo = [0.09 0.0699 0.0527 0.0387 0.0277 0.0193 0.0135];
semilogy(1:1:7,BERric,'-bo');
hold on
semilogy(1:1:7,BERtheo,'-r*');
hold off
xlabel('SNR (dB)')
ylabel('BER')
title('BER vs SNR')
disp('end');
