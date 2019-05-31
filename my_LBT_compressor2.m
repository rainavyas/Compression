function my_DCT_compressor2(X)
    X = double(X);
    N_list = [8,16,32];
    s_list = [1.0,1.4,1.6];
    [n,m] = size(X)
    best_ssim = [-1.0, 0, 0, 0];
    Results = ["current_ssim","N","s","step","bits"]
        
    for i = 1:length(N_list)
        for j = 1:length(s_list)
            N = N_list(i);
            s = s_list(j);
            step = 1;
            bit_length = 1000000;
            while bit_length > 39500
                step = step + 1;
                try
                    [vlc, bits, huffval] = LBTenc(X-128, step, s, N, N, true, 8);
                    bit_length = sum(vlc(:,2));
                catch ME
                    display("error coding with step size")
                end
            end
            Z = LBTdec(vlc,step,s,N,N,bits,huffval,8);

            current_ssim = ssim(Z,X-128);
            display(current_ssim)
            draw(Z)
            pause(2)
            current_ssim = [current_ssim, N, s, bit_length];

            if current_ssim > best_ssim(1)
                best_ssim = current_ssim;
            end
        end
    end
    display(best_ssim(1:3))