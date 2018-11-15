% initialize the class
a = PlottingClass;
% add the path to instances
path = '/Users/jackcook/Documents/Documents/Fall_2018/ExperimentalFluids/AcousticAlgorithm';
filename = '/11142018_222057_UTC.mat';
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
a.Data(a.R1, a.R2, a.R3, a.newname);

% setup data for lowpass filter
all = rawdata(:,:);
% call lowpass, filter and plot the data

a.filtering(all, a.newname);
