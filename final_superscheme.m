function score = final_superscheme(X)
    [DCT_ssim, DCT_N, DCT_step] = final_DCT_compressor(X);
    [LBT_ssim,LBT_N,LBT_s,LBT_step] = final_LBT_compressor(X);
    [DWT_ssim, DWT_N, DWT_layers, DWT_step] = final_DWT_compressor(X);
    
    [DCT_vlc, bits, huffval] = jpegenc(X-128,DCT_step,DCT_N,DCT_N,true,8);
    DCT_Z = jpegdec(DCT_vlc,DCT_step,DCT_N,DCT_N,bits,huffval,8);
    
    [LBT_vlc, bits, huffval] = LBTenc(X-128, LBT_step, LBT_s, LBT_N, LBT_N,true,8);
    LBT_Z = LBTdec(LBT_vlc,LBT_step,LBT_s,LBT_N,LBT_N,bits,huffval,8);
     
    [DWT_vlc, bits, huffval] = DWTenc(X, DWT_step, DWT_N, DWT_layers, DWT_N,true,8);
    DWT_Z = DWTdec(DWT_vlc,DWT_step,DWT_layers,DWT_N,DWT_N,bits,huffval,8);
    
    if DCT_ssim >= LBT_ssim && DCT_ssim >= DWT_ssim
       display("DCT encoding used")
       display("N/M : " + DCT_N + ", step : " + DCT_step)
       display("RMS error : " + std(DCT_Z(:)-X(:)) + ", bits : " + (sum(DCT_vlc(:,2))+1424)) 
       %figure(1)
       %draw(X)
       %figure(2)
       draw(DCT_Z)
       score = (log2(DCT_N)-2)*10 + 1;
       return
    end 
    
    if LBT_ssim >= DCT_ssim && LBT_ssim >= DWT_ssim
       display("LBT encoding used")
       display("N/M : " + LBT_N + ", step : " + LBT_step + ", s: " + LBT_s)
       display("RMS error : " + std(LBT_Z(:)-X(:)) + ", bits : " + (sum(LBT_Z(:,2))+1424)) 
       %figure(1)
       %draw(X)
       %figure(2)
       draw(LBT_Z)
       score = (log2(LBT_N)-2)*10+(LBT_s*4-3);
       return
    
    else
       display("DWT encoding used")
       display("N/M : " + DWT_N + ", step : " + DWT_step + ", # of layers : " + DWT_layers)
       display("RMS error : " + std(DWT_Z(:)-X(:)) + ", bits : " + (sum(DWT_Z(:,2))+1424)) 
       %figure(1)
       %draw(X)
       %figure(2)
       draw(DWT_Z)
       score = (log2(DWT_N)-2)+(DWT_layers+4);
       return
    end