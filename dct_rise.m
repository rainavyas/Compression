function dct_rise(X)

X = X-128;
N=8;
C = dct_ii(N);

RMS = 4.8612;
ref_bits = 2.28118*(10^5);

% loop over rise size factor
for i = 0.5:0.1:8
    curr_RMS = 0;
    step = 1;
    % increase step size till RMS is correct
    while curr_RMS < RMS
        rise = step * i;
        Y = colxfm(colxfm(X,C)',C)';
        Yq = quantise(Y,step,rise);
        Yr = regroup(Yq,N)/N;
        Z = colxfm(colxfm(Yq',C')',C');
        curr_RMS = std(X(:)-Z(:));
        step = step+0.1;
    end
    bits = dctbpp(Yr, N);
    comp = ref_bits/bits;
    disp("ratio :"+ rise/step+" compression: "+comp);
    
    
end




return