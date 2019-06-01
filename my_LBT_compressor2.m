function [N,s,step] = my_LBT_compressor2(X)
    X = double(X);
    N_list = [8,16,32];
    s_list = [1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0];
    results = ["current_ssim","N","s","bits"]
    for j = 1:length(s_list)
        best_ssim = [-1.0, 0, 0, 0, 0];
        for i = 1:length(N_list)
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
            current_ssim = [ssim(Z,X-128), N, s, bit_length];

            if current_ssim > best_ssim(1)
                best_ssim = current_ssim;
            end
        end
        results = [results; best_ssim]
    end
    display(results)
	N = best_ssim(1);
    s = best_ssim(2);
    step = best_ssim(3);