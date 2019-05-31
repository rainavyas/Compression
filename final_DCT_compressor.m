function [ssim_value, N, step] = final_DCT_compressor(X)
    X = double(X);
    N_list = [8,16,32];
    best_ssim = [-1.0, 0, 0, 0];
        
    for i = 1:length(N_list)
        N = N_list(i);
        step = 1;
        bit_length = 1000000;
        while bit_length > 39500 && step<256,
            step = step + 1;
            try
                [vlc, bits, huffval] = jpegenc(X-128,step,N,N,1,8);
                bit_length = sum(vlc(:,2));
            end
        end
        Z = jpegdec(vlc,step,N,N,bits,huffval,8);

        current_ssim = [ssim(Z,X-128), N, step, bit_length];
        if current_ssim(1) > best_ssim(1)
            best_ssim = current_ssim;
        end
    end
    
    ssim_value = best_ssim(1);
    N = best_ssim(2);
    step = best_ssim(3);
