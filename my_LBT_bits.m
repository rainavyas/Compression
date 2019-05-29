function total_bits = my_LBT_bits(X, qstep, s, N, M, opthuff, dc_bits)

[vlc bits huffval] = LBTenc_vyas(X, qstep, s, N, M, opthuff, dc_bits);
total_bits = sum(vlc(:,2));

return