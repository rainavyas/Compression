function my_DCT_compressor2(X)
    X = double(X);
    N_list = [8,16,32];
    s_list = [1.0,1.4,1.6,1.8,2.0];
    [n,m] = size(X)
    best_ssim = [-1.0, 0, 0, 0];
    Results = ["current_ssim","N","s","step","bits"]
        
    for i = 1:length(N_list)
        for j = 1:length(s_list)
            N = N_list(i)
            s = s_list(j)
            pause(5)
            step = 1;
            bit_length = 1000000;
            while bit_length > 39500
                try
                    [vlc, bits, huffval] = LBTenc(X-128, step, s, N, N, true, 8);
                    bit_length = sum(vlc(:,2));
                catch ME
                    display("error coding with step size")
                end
                step = step + 1
            end
            Z = LBTdec(vlc,step,s,N,N,bits,huffval,8);

            current_ssim = ssim(Z,X-128);
            display(current_ssim)
            pause(5)
            current_ssim = [current_ssim, N, s, bit_length];
            draw(Z)

            if current_ssim > best_ssim(1)
                best_ssim = current_ssim;
            end
        end
    end
    display(best_ssim(1:3))