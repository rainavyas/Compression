function [vlc bits huffval] = LBTenc_vyas(X, qstep, s, N, M, opthuff, dcbits)

global huffhist  % Histogram of usage of Huffman codewords.

% Presume some default values if they have not been provided
error(nargchk(2, 7, nargin, 'struct'));
if ((nargout~=1) && (nargout~=3)) error('Must have one or three output arguments'); end
if (nargin<7)
  dcbits = 8;
  if (nargin<6)
    opthuff = false;
    if (nargin<5)
      if (nargin<4)
        N = 8;
        M = 8;
      else
        M = N;
      end
        if (nargin<3)
          s = 1;
        end
    else 
      if (mod(M, N)~=0) error('M must be an integer multiple of N'); end
    end
  end
end
 if ((opthuff==true) && (nargout==1)) error('Must output bits and huffval if optimising huffman tables'); end
 
 
% DO LBT
I = 256;
[Pf Pr] = pot_ii(N, s);

%Do POT
t = [(1+N/2):(I-N/2)];
Xp = X;
Xp(t,:)=colxfm(Xp(t,:), Pf);
Xp(:,t) = colxfm(Xp(:,t)',Pf)';

[vlc, bits, huffval] = jpegenc(Xp, qstep, N, M, opthuff, dcbits);

return

