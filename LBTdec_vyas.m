function Zp = LBTdec_vyas(vlc, qstep, s, N, M, bits, huffval, dcbits, W, H)

% Presume some default values if they have not been provided
error(nargchk(2, 10, nargin, 'struct'));
opthuff = true;
if (nargin<10)
  H = 256;
  W = 256;
  if (nargin<8)
    dcbits = 8;
    if (nargin<7)
      opthuff = false;
      if (nargin<5)
        if (nargin<4)
          N = 8;
          M = 8;
        else
          M = N;
        end
        if (nargin<3)
          s = 1
        end
      else 
        if (mod(M, N)~=0) error('M must be an integer multiple of N'); end
      end
    end
  end
end

 Z = jpegdec(vlc, qstep, N, M, bits, huffval, dcbits, W, H);
 
 % Post filtering
 I = 256;
[Pf Pr] = pot_ii(N, s);
t = [(1+N/2):(I-N/2)];
Zp = Z;
Zp(:,t) = colxfm(Zp(:,t)', Pr')';
Zp(t,:) = colxfm(Zp(t,:),Pr');
 

return