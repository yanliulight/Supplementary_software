% Code to plot the power rejection curve and noise transfer function. See
% Supplementary Note 2 and Supplementary Note 5 for a detailed description.
% Author: Yan Liu, yl144@iu.edu

% User input. See Supplementary Figure 1 for the definition of user-input variables.

clear
t_DM = 0.55e-3 %[s], DM response time, See Supplementary Figure 1 and Supplementary Note 2
t_computation = 1e-3*0.49 % [s], computation time
t_shws  = 1e-3*[0.126];  % [s], integration (exposure) time of SHWS
t_readoutTransfer = 1e-3*[1.93] % [s], time for data readout, transfer
t_delay = t_readoutTransfer + t_computation;
AO_loop_rate = 233 % [Hz] AO loop rate
t_hold  = 1/AO_loop_rate % [s]
gain = [1]; % AO loop gain

% Calculation
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
