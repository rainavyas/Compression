function [N, step, error] = my_DCT_compressor_return(X)
    X = double(X)
    N_list = [4,8,16,32];
    Z_list = [X, X, X, X];
    [n,m] = size(X)
    best_rms = [100, 8, 20];
    
    for i = 1:length(N_list)
        pixel_start = 1 + (i-1)*n
        pixel_end = i*n
        N = N_list(i)
        step = 1;
        bit_length = 1000000;
        while bit_length > 50000,
            try
                vlc = jpegenc(X-128,step,N);
                Z = jpegdec(vlc,step,N);
                Z_list(:,pixel_start:pixel_end) = Z;
                rms_error = std(X(:)-Z(:));
                bit_length = sum(vlc(:,2));
            catch ME
                display("error coding with step size")
                rms_error = 100
            end
            step = step + 1;
        end
        if rms_error < best_rms(1)
            best_rms = [rms_error, N, step]
            pause(5)
        end
    end
    
    Z_4 = Z_list(:,1:256);
    Z_8 = Z_list(:,257:512);
    Z_16 = Z_list(:,513:768);
    Z_32 = Z_list(:,769:1024);
    draw(beside(Z_4,beside(Z_8,beside(Z_16,Z_32))))
    display(best_rms)

    error = best_rms(1);
    N = best_rms(2);
    step = best_rms(3);
    
    