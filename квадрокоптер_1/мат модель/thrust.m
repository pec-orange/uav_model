% Compute thrust given current inputs and thrust coefficient
function T = thrust(inputs, k)
 % Inputs are values for wi
 T = [0; 0; k * sum(inputs)];
 end