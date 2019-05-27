function [Z_4, Z_8, Z_16, Z_32] = my_DCT_compressor(X)
    N = [4,8,16]
     
    N = 4;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_4 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    N = 8;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_8 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    N = 16;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_16 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    N = 16;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_16 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    N = 32;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_32 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    draw(beside(Z_4,beside(Z_8,beside(Z_16,Z_32))))