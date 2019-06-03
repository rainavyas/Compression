function Z = final_superscheme_decoder(scheme, vlc, bits, huffval, N, step, s_n, rms)
            
    if scheme == 1    
       Z = jpegdec(vlc,step,N,N,bits,huffval,8) + 128;
       display("DCT encoding used")
       display("N/M : " + N + ", step : " + step)
       display("RMS error : " + rms + ", bits : " + (sum(vlc(:,2))+1434)) 
       return
    end 
    
    if scheme == 2
       Z = LBTdec(vlc,step,s_n,N,N,bits,huffval,8) + 128;
       display("LBT encoding used")
       display("N/M : " + N + ", step : " + step + ", s: " + s_n)
       display("RMS error : " + rms + ", bits : " + (sum(vlc(:,2))+1434)) 
       return
    
    else
       Z = DWTdec(vlc,step,s_n,N,N,bits,huffval,8);
       display("DWT encoding used")
       display("N/M : " + N + ", step : " + step + ", # of layers : " + s_n)
       display("RMS error : " + rms + ", bits : " + (sum(vlc(:,2))+1434)) 
       return
    end
    
   figure(2)
   draw(DCT_Z)