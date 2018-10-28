function [data] = importData(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [Variable,Value] = IMPORTFILE(FILE) reads data from the first worksheet
%   in the Microsoft Excel spreadsheet file named FILE and returns the data
%   as column vectors.
%
%   [Variable,Value] = IMPORTFILE(FILE,SHEET) reads from the specified
%   worksheet.
%
%   [Variable,Value] = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from
%   the specified worksheet for the specified row interval(s). Specify
%   STARTROW and ENDROW as a pair of scalars or vectors of matching size
%   for dis-contiguous row intervals. To read to the end of the file
%   specify an ENDROW of inf.%
% Example:
%   [Variable,Value] = importfile('Data.xlsx','Sheet1',3,7);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2018/04/06 17:18:58

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 3;
    endRow = 7;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('B%d:C%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('B%d:C%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
stringVectors = string(raw(:,1));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,2);

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Variable = cellstr(stringVectors(:,1));
Value = data(:,1);

%% Generate Container of variables
data = containers.Map(Variable,Value);
end