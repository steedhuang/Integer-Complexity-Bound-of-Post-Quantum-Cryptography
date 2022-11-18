% Created 2022-11-18
% Authors: ZH Wang, ST Zhou, T Xu, HC Lin, JS Huang
% Analysis of Post Quantum Crypto Example of Multiple Variable Quadratic Polynomial
% With Zhang Yitang's Landau-Siegel zero discrete mean estimated bound  
% And Juan Arias de Reyna Martínez integer complexity 
% This code shows how isomorphic graph polynomial hacked bound looks like
clc;
clear;
clf;
% Consider the graph G = (U, D), where U = 1, 2, 3, 4 ... N, and D = f(1, 2), (2, 3), (3, 4), (N, 1). 

% Data pattern to be tested like Prime, Minggatu, Fibonacci, Riesel: 
% sequences = readtable('sequencesM.xlsx','ReadVariableNames',1);

% Load Integer Complexity table
% https://www.mathworks.com/matlabcentral/fileexchange/49792-calculate-integer-complexity
IC=xlsread('IntCompl.xls');

% Generate Fractional Minggatu-Catalan Numbers
for n=1:86
    nn=3+n/10;
    CnF(n)=round(gamma(2*nn+1)/gamma(nn+2)/gamma(nn+1));
end
MiCa=CnF';
% https://prime-numbers.info/list/first-1000-primes
Prime=[2;3;5;7;11;13;17;19;23;29;31;37;41;43;47;53;59;61;67;71;73;79;83;89;97;101;103;107;109;113;127;131;137;139;149;151;157;163;167;173;179;181;191;193;197;199;211;223;227;229;233;239;241;251;257;263;269;271;277;281;283;293;307;311;313;317;331;337;347;349;353;359;367;373;379;383;389;397;401;409;419;421;431;433;439;443];
% http://oeis.org/A114813/b114813.txt
FiLu=[20;27;28;32;52;55;74;77;85;87;93;97;115;123;143;146;149;157;161;163;178;187;197;209;211;214;215;221;223;239;242;249;262;269;283;287;307;311;313;321;334;349;379;391;393;409;421;453;487;493;499;523;581;586;617;641;647;677;691;707;709;787;794;811;823;839;853;859;887;907;913;929;941;953;1031;1049;1063;1093;1229;1259;1277;1289;1307;1321;1361;1367];
% https://oeis.org/A087634/b087634.txt
RiPr=[5,11,13,19,23,37,43,47,61,67,73,79,103,151,157,163,191,193,211,223,271,277,283,313,331,367,383,397,421,457,463,487,523,541,547,607,613,631,661,673,691,733,751,757,787,823,877,907,991,997,1051,1087,1093,1123,1153,1171,1201,1213,1237,1279,1303,1321,1327,1381,1423,1447,1453,1471,1531,1543,1621,1657,1663,1723,1753,1783,1831,1867,1873,1933,1951,1993,2011,2017,2083,2137];
%https://www.researchgate.net/publication/296827182_Infinite_Cunningham_Chains_and_Infinite_Arithmetic_Primes
sequences(:,1)=Prime; 
sequences(:,2)=MiCa; % A000108
sequences(:,3)=FiLu; % A114813
sequences(:,4)=RiPr; % http://www.prothsearch.com/

% For graphes
Names = ['P';'M';'F';'R'];

% Total cases
N=86
% Total trials for each case
T=200

% 4 Sequences
for j=1:4
    M=sequences(:,j)
    for n=1:N
      count=0;
      TT=round(T*n) % show where we at
      for i=1:TT
     % Consider the halfway permutation beween 1 and N
      P1=round(1+(M(n)/2)*rand);
      P2=round(M(n)/2+(M(n)/2)*rand);
     % Edge P1 and Edge P2 will be removed from G and added into H 
      H1=round(1+(M(n)/2)*rand);
      H2=round(M(n)/2+(M(n)/2)*rand);
     % Check if hack simulation success
      if H1==P1&&H2==P2
          count=count+1;
      end
      % Changing bottom floor probability: 2 out of TT combination: 1/2~1/4
      if count==0
          bottom=0.3333/TT^2; % lower bound
      else    
          bottom=count/TT; % higher bound
      end
      P(n)=bottom;
      end
      % Check the spectrum
      if n<=86-15
      FF(n+7)=std(abs((fft(M(n:n+15)))));
      end
      % Add Yitang Zhang bound
      Z(n)=2022*(log(M(n)));
      % Add Juan Arias de Reyna Martínez's Integer Complexity
      I(n)=IC(n);
    end
% The diagrams of hacked bound
    figure(j)
% Original data
    plot(log(P));
    hold on;
    plot(log(movmean(P,16))); % a level of 16 nested
    plot(-log(FF)); % fft frequence whitening against machine learning
    plot(log(1./Z)); % Yitang Zhang's bound
    plot(log(1/T./I)); % Yuan's bound
    hold off;
    legend('simulated','windowed','spectrum','bounded','complexity')
    SequenName = strcat(Names(j),' Hacked Probability vs Permutation Length Index')
    title(SequenName)
    xlabel('Length Index (key)')
    ylabel('Chance of Broken (log)')
end