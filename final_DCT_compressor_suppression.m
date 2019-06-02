function [ssim_value, N, step, cutoff] = final_DCT_compressor_suppression(X)

%This function optimises over the diagonal cut-off of pixels to be
%suppressed in dct of the image (suppressed means to set the intensities to
%zero- done to the high frequency pixels
    disp("ssim  N  step  bit_length  cutoff");
    X = double(X);
    N_list = [8,16,32];
    best_ssim = [-1.0, 0, 0, 0, 0];
        
    for i = 1:length(N_list)
        N = N_list(i);
        for cutoff = N/2: 1: 2*N
        step = 1;
        bit_length = 1000000;
        while bit_length > 39500 && step<256,
            step = step + 1;
            try
                [vlc, bits, huffval] = jpegenc_suppression(X-128,step,N,N,1,8, cutoff);
                bit_length = sum(vlc(:,2));
            catch ME
            end
        end
        Z = jpegdec(vlc,step,N,N,bits,huffval,8);

        current_ssim = [ssim(Z,X-128), N, step, bit_length, cutoff];
        disp(current_ssim(1) + " "+ current_ssim(2)+ " "+current_ssim(3)+ " "+current_ssim(4)+ " "+current_ssim(5)+ " ");
        if current_ssim(1) > best_ssim(1)
            best_ssim = current_ssim;
        end
        end
    end
    
    ssim_value = best_ssim(1);
    N = best_ssim(2);
    step = best_ssim(3);
    cutoff = best_ssim(5);
