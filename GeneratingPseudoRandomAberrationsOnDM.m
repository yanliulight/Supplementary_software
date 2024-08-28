% Supplementary Software for the paper "Ultrafast adaptive optics for imaging the living human eye", by Yan Liu et al. from Indiana University.

% This code is used for generating the pseudo-random aberrations (pink noise) that are applied to the DM, in order to measure the power rejection curve.

% Please refer to Supplementary Note 8 and sub-section "Measuring the temporal performance of the ultrafast ophthalmic AO system" in Methods for more information.

% Author: Yan Liu (yl144@iu.edu)

%%
clear
% User input
% Please update the following two parameters according to your case. Then
% run this section.

N = 1000; % Number of time points for generating the pesudo-random aberrations.

num_actuators = 97; % Number of actuators of the deformable mirror (DM)

%%
% Run this section to calculate the pesudo-random aberrations.
N = N+1;
y = pinknoise(N,num_actuators); % Generate N time points of pink noise for each actuator.
k=0.2;
for ii=1:num_actuators
    y1 = y(:,ii);
    max_y = max(max(y1),-min(y1));
    y1_norm = y1/max_y*k;
    y_norm(:,ii) = y1_norm;
end

y_norm_diff = diff(y_norm);
y_norm_diff(1,:) = y_norm_diff(1,:)+y_norm(1,:); 

%%
% Run this section to save the result. y_norm_diff is the pseudo-random aberrations (pink noise) to be injected to the DM.
save result y_norm_diff
