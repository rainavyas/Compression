function [ssim_value, N, layers, step] = final_DWT_compressor(X)
    X = double(X);
    N_list = [8,16,32];
    layer_list = [2,3,4];
    best_ssim = [-1.0, 0, 0, 0, 0, 0];
     
   for i = 1:length(N_list)
        for j = 1:length(layer_list)
            N = N_list(i);
            layers = layer_list(j);
            step = 1;
            bit_length = 1000000;
            while bit_length > 39536 && step<256
                step = step + 1;
                try
                    [vlc bits huffval] = DWTenc(X, step, N, layers, N, true, 8);
                    bit_length = sum(vlc(:,2));
                end
            end

            Z = DWTdec(vlc,step,layers,N,N,bits,huffval,8);

            current_ssim = [ssim(Z,X), N, layers, step, bit_length];
            if current_ssim(1) > best_ssim(1)
                best_ssim = current_ssim;
            end
        end
   end
    
    ssim_value = best_ssim(1);
	N = best_ssim(2);
    layers = best_ssim(3);
    step = best_ssim(4);