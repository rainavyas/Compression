function my_DWT_compressor2(X)
    X = double(X);
    N_list = [8,16,32];
    M_list = [8,16,32];
    layer_list = [2,3,4];
    [n,m] = size(X)
    best_ssim = [-1.0, 0, 0, 0, 0, 0];
    results = ["current_ssim","N","M","layers","step","bits"]
     
   for k = 1:length(M_list)
        for i = 1:k
            for j = 1:length(layer_list)
                N = N_list(i);
                M = M_list(k);
                layers = layer_list(j);
                step = 1;
                bit_length = 1000000;
                while bit_length > 40960 && step<256
                    step = step + 1;
                    pause(0.05)
                    try
                        [vlc bits huffval] = DWTenc(X, step, N, layers, M, true, 8);
                        bit_length = sum(vlc(:,2))
                    catch ME
                        display("error coding with step size")
                    end
                end
                
                Z = DWTdec(vlc,step,layers,N,M,bits,huffval,8);
                
                current_ssim = ssim(Z,X);
                display(current_ssim)
                draw(Z)
                current_ssim = [current_ssim, N, M, layers, step, bit_length];
                results = [results; current_ssim]
                if current_ssim > best_ssim(1)
                    best_ssim = current_ssim;
                end
            end
        end
   end
   
    display(best_ssim(1:3))
    display(results)