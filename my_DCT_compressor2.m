function my_DCT_compressor2(X)
    X = double(X);
    N_list = [4,8,16,32];
    M_list = [8,16,32];
    [n,m] = size(X)
    best_ssim = [-1.0, 0, 0, 0];
    Results = ["current_ssim","M","N","step","bits"]
        
    for i = 1:length(M_list)
        for j = 1:i+1
            M = M_list(i);
            N = N_list(j);
            a = [N,M]
            pause(2)
            step = 1;
            bit_length = 1000000;
            while bit_length > 40960,
                try
                    [vlc, bits, huffval] = jpegenc(X-128,step,N,M,false,8);
                    bit_length = sum(vlc(:,2));
                catch ME
                    display("error coding with step size")
                end
                step = step + 1;
            end
            Z = jpegdec(vlc,step,N,M,bits,huffval,8);
            current_ssim = ssim(Z,X-128);


            current_ssim = [current_ssim, M, N, step, bit_length];
            draw(Z)
            if current_ssim > best_ssim(1)
                best_ssim = current_ssim;
            end
            Results = [Results;current_ssim];
            display(Results)
            pause(3)
        end
    end