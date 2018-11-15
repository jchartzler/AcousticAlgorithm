% initialize the class
a = PlottingClass;

% ------- Paths --------- %
% path to dir with .mat
path = '/Users/jackcook/Documents/Documents/Fall_2018/ExperimentalFluids/AcousticAlgorithm/Data';
a.path = path;
% name of current .mat to be processed
filename = '/11142018_222057_UTC.mat';


% ------- Range ---------- %
a.Range = [0, 0.25];
% red lines
a.right = [13,13];
a.left = [8,8];
% ------------------------ %

% location for the images
a.imagedir = extractBefore(path, "Data");

% make a file path to be found
filepath = strcat(path, filename);
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
