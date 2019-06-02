function lbt_rise(X)

X = X-128;
N=4;
s=1.4;
C = dct_ii(N);
I = 256;
[Pf Pr] = pot_ii(N, s);

%Do POT
t = [(1+N/2):(I-N/2)];
Xp = X;
Xp(t,:)=colxfm(Xp(t,:), Pf);
Xp(:,t) = colxfm(Xp(:,t)',Pf)';

RMS = 4.8612;
ref_bits = 2.28118*(10^5);

% loop over rise size factor
for i = 0.5:0.1:8
    curr_RMS = 0;
    step = 1;
    % increase step size till RMS is correct
    while curr_RMS < RMS
        rise = step * i;
        Y = colxfm(colxfm(Xp,C)',C)';
        Yq = quantise(Y,step,rise);
        Yr = regroup(Yq,N)/N;
        Z = colxfm(colxfm(Yq',C')',C');
        Zp = Z;
        Zp(:,t) = colxfm(Zp(:,t)', Pr')';
        Zp(t,:) = colxfm(Zp(t,:),Pr');
        curr_RMS = std(X(:)-Zp(:));
        step = step+0.1;
    end
    bits = dctbpp(Yr, 16);
    comp = ref_bits/bits;
    disp("ratio :"+ rise/step+" compression: "+comp);
    
    
end




return