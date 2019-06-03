function [scheme, vlc, bits, huffval, N, step, s_n, rms] = final_superscheme_encoder(X)
    [DCT_ssim, DCT_N, DCT_step, DCT_cutoff] = final_DCT_compressor(X);
    [LBT_ssim,LBT_N,LBT_s,LBT_step, LBT_cutoff] = final_LBT_compressor(X);
    [DWT_ssim, DWT_N, DWT_layers, DWT_step] = final_DWT_compressor(X);
    
    [DCT_vlc, DCT_bits, DCT_huffval] = jpegenc(X-128,DCT_step,DCT_N,DCT_N,true,8);
    DCT_Z = jpegdec(DCT_vlc,DCT_step,DCT_N,DCT_N,DCT_bits,DCT_huffval,8, DCT_cutoff);
    
    [LBT_vlc, LBT_bits, LBT_huffval] = LBTenc(X-128, LBT_step, LBT_s, LBT_N, LBT_N,true,8,LBT_cutoff);
    LBT_Z = LBTdec(LBT_vlc,LBT_step,LBT_s,LBT_N,LBT_N,LBT_bits,LBT_huffval,8);
     
    [DWT_vlc, DWT_bits, DWT_huffval] = DWTenc(X, DWT_step, DWT_N, DWT_layers, DWT_N,true,8);
    DWT_Z = DWTdec(DWT_vlc,DWT_step,DWT_layers,DWT_N,DWT_N,DWT_bits,DWT_huffval,8);
    
    if DCT_ssim >= LBT_ssim && DCT_ssim >= DWT_ssim
      rms = std(DCT_Z(:)-X(:));
      scheme = 1;
      vlc = DCT_vlc;
      bits = DCT_bits;
      huffval = DCT_huffval;
      N = DCT_N;
      step = DCT_step;
      s_n = -1;  
      return
    end 
    
    if LBT_ssim >= DCT_ssim && LBT_ssim >= DWT_ssim
       rms = std(LBT_Z(:)-X(:));
       scheme = 2;
       vlc = LBT_vlc;
       bits = LBT_bits;
       huffval = LBT_huffval;
       N = LBT_N;
       step = LBT_step;
       s_n = LBT_s;  
       return
    else
       rms = std(DWT_Z(:)-X(:));
       scheme = 3;
       vlc = DWT_vlc;
       bits = DWT_bits;
       huffval = DWT_huffval;
       N = DWT_N;
       step = DWT_step;
       s_n = DWT_s;    
       return
    end