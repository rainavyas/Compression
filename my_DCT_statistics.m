function Z = my_DCT_statistics(X,N,step)
    [n,m] = size(X);
    C = dct_ii(N);
    Y = colxfm(colxfm(X,C)',C)';
    
    %quantising
    Yq = quantise(Y,step,step);
    Yr = regroup(Yq,N)/N;
    
    %Decoding and looking at picture quality
    Z = colxfm(colxfm(Yq',C')',C');
