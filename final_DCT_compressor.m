function [N,step] = final_DCT_compressor(X)
    X = double(X);
    N_list = [8,16,32];
    [n,m] = size(X)
    best_ssim = [-1.0, 0, 0, 0];
    Results = ["current_ssim","N","step","bits"]
        
    for i = 1:length(N_list)
        N = N_list(i);
        step = 1;
        bit_length = 1000000;
        while bit_length > 40960,
            try
                [vlc, bits, huffval] = jpegenc(X-128,step,N);
                bit_length = sum(vlc(:,2));
            catch ME
                display("error coding with step size")
            end
            step = step + 1;
        end
        Z = jpegdec(vlc,step,N,N,bits,huffval,8);
        current_ssim = ssim(Z,X-128);


        current_ssim = [current_ssim, N, step, bit_length];
        figure(i)
        draw(Z)
        if current_ssim > best_ssim(1)
            best_ssim = current_ssim;
        end
        Results = [Results;current_ssim];
        display(Results)
        pause(3)
    end
    
    N = best_ssim(2)
    step = best_ssim(3)
    final_ssim = best_ssim(4)