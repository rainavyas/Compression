function total_bits = my_LBT_bits(X, qstep, s, N, M, dc_bits)

vlc = LBTenc(X, qstep, s, N, M, 0, dc_bits);
total_bits = sum(vlc(:,2));

return