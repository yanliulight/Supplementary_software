% Matlab code for generating the pseudo-random aberrations (pink noise) that are applied to the DM, in order to measure the power rejection curve.
% See Supplementary Note 8 for more information.
% Author: Yan Liu, yl144@iu.edu

clear
% User input: 
N = 1000; % # of time points to be generated.
num_actuators = 97; %# of actuators on the DM
%%
N = N+1;
y = pinknoise(N,num_actuators); % Generate N time points of pink noise for each actuator.
k=0.2 
for ii=1:num_actuators
    y1 = y(:,ii);
    max_y = max(max(y1),-min(y1));
    y1_norm = y1/max_y*k;
    y_norm(:,ii) = y1_norm;
end

y_norm_diff = diff(y_norm);
y_norm_diff(1,:) = y_norm_diff(1,:)+y_norm(1,:); 
% Output: y_norm_diff, which is the pseudo-random aberrations (pink noise)
% to be injected to the DM.
