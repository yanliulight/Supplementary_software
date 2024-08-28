% The code for plotting the power rejection curve and noise transfer function using AO system parameters. 
% See Supplementary Note 2 and Supplementary Note 5 for a detailed description.
% Author: Yan Liu (yl144@iu.edu)

clear
close all
%%
% User input
% Please update the following AO system parameters using those from your system, then run this section.
% See Supplementary Figure 1 and Supplementary Note 2 for the definition of these parameters.

t_DM = 0.55e-3 % Deformable mirror (DM) response time constant, see Supplementary Figure 1 and Supplementary Note 2. Unit is second.
t_computation = 1e-3*0.49 % Data processing time. Unit is second.
t_shws  = 1e-3*[0.126];  % Integration (exposure) time of SHWS. Unit is second.
t_readoutTransfer = 1e-3*[1.93] % Time for pixel readout and data transfer to a computer. Unit is second.
t_delay = t_readoutTransfer + t_computation;
AO_loop_rate = 233 % AO loop rate. Unit is Hz.
t_hold  = 1/AO_loop_rate %  The period for the DM to hold a wavefront correction pattern. Unit is second.
gain = [1]; % AO loop gain

%%
% Run the following section to calculate and plot the power rejection curve and noise transfer function. 
f = linspace(0,max(AO_loop_rate/2),10000);

s=1i*2*pi*f;

for ii=1:length(t_shws)
h_stare    =  (1 - exp(-s*t_shws(ii))) ./ (s*t_shws(ii)); 
h_delay    =  exp(-s*t_delay(ii)); 
h_cc      =  gain(ii) ./ (1 - exp(-s*t_hold(ii)));
h_zerohold =  (1 - exp(-s*t_hold(ii))) ./ (s*t_hold(ii));
h_DM = 1./(1+t_DM*f);
h_openloop = h_stare .* h_delay .* h_cc .* h_zerohold.*h_DM;
Hn = h_openloop./(1+h_openloop)./h_stare;
h_error(:,ii)   = abs( 1 ./ (1 + h_openloop) );
h_close(:,ii) = h_openloop./(1+h_openloop);
end

% Plot result
figure;
xs = f;
loglog(xs,(abs(h_error)).^2.,'k'), hold on
loglog(xs,(abs(Hn)).^2.,'b'), 
plot(xs, ones(size(xs)),'--'),hold off 

xlim([0, AO_loop_rate/2])
% ylim([1e-5, 1e1])
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(gcf,'color','w');
lg = legend('Power rejection curve', 'Noise transfer function')
lg.Position = [0.8463 0.8553 0.0452 0.0544];
