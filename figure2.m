% MIT License
% 
% Copyright (c) 2025 yassinlabyed
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

clc;
clear all;
close all;

pdff_thresholds = [5.75, 15.5, 21.35];    % Qadri thresholds

load results.mat 
data = results;
pdff = data.pdff_roi;
udff9c2= data.udff_9c2;
udff5c1 = data.udff_5c1;
udffdax = data.udff_dax;
age = data.age;
sex = categorical(data.gender); 
bmi = data.bmi;

% Logical condition to filter rows where pdff is not NaN
validPdff = ~isnan(pdff);

% Logical condition to filter rows where at least one udff (dax, 5c1, or 9c2) is not NaN
validUdff = ~isnan(udffdax) | ~isnan(udff5c1) | ~isnan(udff9c2);

% Combine conditions: only include rows with valid pdff and at least one valid udff
validRows = validPdff & validUdff;

% Filter the data
filteredData = data(validRows, :); % Assuming 'data' is a table or matrix

% Update variables with filtered data
pdff = pdff(validRows);
udff9c2 = udff9c2(validRows);
udff5c1 = udff5c1(validRows);
udffdax = udffdax(validRows);
age = age(validRows);
sex = sex(validRows);
bmi = bmi(validRows);
%..........................................................

% Initialize udffrandom as NaN array with the same length as the data
% Set the random seed for reproducibility
rng(135);  % You can choose any number for the seed
udffrandom = nan(size(pdff));

% Loop through each row and randomly select a non-NaN value from udffdax, udff5c1, and udff9c2
for i = 1:length(pdff)
    % Extract the available non-NaN values from udffdax, udff5c1, and udff9c2 for the current row
    values = [udffdax(i), udff5c1(i), udff9c2(i)];
    validValues = values(~isnan(values)); % Keep only non-NaN values
    
     % If there is exactly one valid value, assign it directly
    if length(validValues) == 1
        udffrandom(i) = validValues;
    % If there are multiple valid values, randomly pick one
    elseif ~isempty(validValues)
        udffrandom(i) = randsample(validValues, 1);
    end
end

% Grouping udff and pdff data into the four groups
udff_groups = {udffdax, udff5c1, udff9c2, udffrandom};
pdff_groups = {pdff, pdff, pdff, pdff};  % PDFF is the same for all groups

% Plot AUC comparison between multiple groups 
[params] = plot_auc_comparison(udff_groups, pdff, pdff_thresholds);





