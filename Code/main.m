% initialize the class
a = PlottingClass;

% !! only change inputs !! %
% ------------ Inputs ------------- %
% name of current .mat to be processed
filename = '/18_11_14/11142018_200015_UTC.mat';
% range
a.Range = [0, 0.25];
% red lines
a.right = [13,13];
a.left = [8,8];

% show figures or dont show figures
show = 1;
if show == 1
    a.figs = 'off';
else
    a.figs = 'on';
end 
% --------------------------------- %

% ------- Paths --------- %
% path to dir with .mat
path = pwd;
new = extractBefore(path, 'Code');
path2 = strcat(new, 'Data');
a.path = path2;
 
% location for the images
a.imagedir = extractBefore(a.path, "Data");

% make a file path to be found
filepath = strcat(new, '/Data', filename);
% the data is an object
S = load(filepath);
% we want the instance rdata inside of sp
rawdata = S.SP.rData;
% name for saving plots
newStr = extractBefore(filename,".");
% take the / out of the location path
a.newname = newStr(2:end);
% get the data from the microphones 
a.R1 = rawdata(1:1:end,1);
a.R2 = rawdata(1:1:end,2);
a.R3 = rawdata(1:1:end,3);

% call the function plotting to display the results of the recording
a.Data();

% setup data for lowpass filter
all = rawdata(:,:);
% call lowpass, filter and plot the data

a.filtering(all, a.newname);

% do some fft stuff
a.Perform()
