function [ssim_value,N,s,step] = final_LBT_compressor(X)
    X = double(X);
    N_list = [8,16,32];
    s_list = [1.0,1.25,1.5,1.75,2.0];
    best_ssim = [-1.0, 0, 0, 0, 0];
        
    for i = 1:length(N_list)
        for j = 1:length(s_list)
            N = N_list(i);
            s = s_list(j);
            step = 1;
            bit_length = 1000000;
            while bit_length > 39536 && step<256
                step = step + 1;
                try
                    [vlc, bits, huffval] = LBTenc(X-128, step, s, N, N, true, 8);
                    bit_length = sum(vlc(:,2));
                end
            end
            Z = LBTdec(vlc,step,s,N,N,bits,huffval,8);

            current_ssim = [ssim(Z,X-128), N, s, step, bit_length];
            if current_ssim(1) > best_ssim(1)
                best_ssim = current_ssim;
            end
        end
    end
    ssim_value = best_ssim(1);
	N = best_ssim(2);
    s = best_ssim(3);
    step = best_ssim(4);