function Zp = DWTdec(vlc, qstep, n, N, M, bits, huffval, dcbits, W, H)

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

% Set up standard scan sequence
scan = diagscan(M);

if (opthuff)
  %disp('Generating huffcode and ehuf using custom tables')
else
  %disp('Generating huffcode and ehuf using default tables')
  [bits huffval] = huffdflt(1);
end
% Define starting addresses of each new code length in huffcode.
huffstart=cumsum([1; bits(1:15)]);
% Set up huffman coding arrays.
[huffcode, ehuf] = huffgen(bits, huffval);

% Define array of powers of 2 from 1 to 2^16.
k=[1; cumprod(2*ones(16,1))];

% For each block in the image:

% Decode the dc coef (a fixed-length word)
% Look for any 15/0 code words.
% Choose alternate code words to be decoded (excluding 15/0 ones).
% and mark these with vector t until the next 0/0 EOB code is found.
% Decode all the t huffman codes, and the t+1 amplitude codes.

eob = ehuf(1,:);
run16 = ehuf(15*16+1,:);
i = 1;
Zq = zeros(H, W);
t=1:M;

for r=0:M:(H-M),
  for c=0:M:(W-M),
    yq = zeros(M,M);

% Decode DC coef - assume no of bits is correctly given in vlc table.
    cf = 1;
    if (vlc(i,2)~=dcbits) error('The bits for the DC coefficient does not agree with vlc table'); end
    yq(cf) = vlc(i,1) - 2^(dcbits-1);
    i = i + 1;

% Loop for each non-zero AC coef.
    while any(vlc(i,:) ~= eob),
      run = 0;

% Decode any runs of 16 zeros first.
      while all(vlc(i,:) == run16), run = run + 16; i = i + 1; end

% Decode run and size (in bits) of AC coef.
      start = huffstart(vlc(i,2));
      res = huffval(start + vlc(i,1) - huffcode(start));
      run = run + fix(res/16);
      cf = cf + run + 1;  % Pointer to new coef.
      si = rem(res,16);
      i = i + 1;

% Decode amplitude of AC coef.
      if vlc(i,2) ~= si,
        error('Problem with decoding .. you might be using the wrong bits and huffval tables');
        return
      end
      ampl = vlc(i,1);

% Adjust ampl for negative coef (i.e. MSB = 0).
      thr = k(si);
      yq(scan(cf-1)) = ampl - (ampl < thr) * (2 * thr - 1);

      i = i + 1;      
    end

% End-of-block detected, save block.
    i = i + 1;

    % Possibly regroup yq
    if (M > N) yq = regroup(yq, M/N); end
    Zq(r+t,c+t) = yq;
  end
end

% Dequantise
Zi=quant2(Zq,qstep,qstep);

%Degroup
Zi = dwtgroup(Zi, -log2(N));

% Perform inverse dwt
m = 256/(2^n);

Zp = Zi;

for i = 1:n
    t=1:(2*m);
    Zp(t,t)=idwt(Zp(t,t));
    m = 2*m;
end

return