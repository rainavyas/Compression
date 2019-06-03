function [ssim_value,N,s,step, cutoff] = final_LBT_compressor(X)
    X = double(X);
    N_list = [8,16,32];
    s_list = [1.2,1.4,1.6,1.8];
    best_ssim = [-1.0, 0, 0, 0, 0];
            
    for i = 1:length(N_list)
        for j = 1:length(s_list)
            N = N_list(i);
            s = s_list(j);
            for cutoff = N/4: 1: 2*N
            step = 10;
            bit_length = 1000000;
            while bit_length > 39520 && step<256
                step = step + 0.5;
                try
                    [vlc, bits, huffval] = LBTenc(X-128, step, s, N, N, true, 8, cutoff);
                    bit_length = sum(vlc(:,2));
                end
            end
            Z = LBTdec(vlc,step,s,N,N,bits,huffval,8);

            current_ssim = [ssim(Z,X-128), N, s, step, bit_length, cutoff];
            if current_ssim(1) > best_ssim(1)
                best_ssim = current_ssim;
            end
            end
        end
    end
    ssim_value = best_ssim(1);
	N = best_ssim(2);
    s = best_ssim(3);
    step = best_ssim(4);
    cutoff = best_ssim(6);
