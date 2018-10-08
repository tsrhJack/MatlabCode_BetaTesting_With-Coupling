%Created by: Kirsten Tulchin-Francis on December 1, 2014
%Last Updated: December 4, 2014
% This is the primary m code to read the list of files.

global FileStruct;
global filename;

filename = uigetfile('*.xlsx', 'N_Patient List');
%filename = 'G:\GHS\FAI non-operative Study\Results\SCASB\2017\Non Op FAI Gait File List.xlsx';
 
tic
[num1, FileStringArray]=xlsread(filename,'FileList','A:J');
columnheadings = {'Filename', 'ID', 'Last', 'First', 'Group', 'Session','Side','File','Study','cycle'};
Filepaths = FileStringArray(:,1);
%[path,filename,ext]=fileparts(Filepaths);

FileStruct = cell2struct(FileStringArray,columnheadings,2);
%[path,thisfile,ext]=fileparts(FileStruct().Filename);

FileStruct().LeftGDIVector=[];
FileStruct().RightGDIVector=[];
FileStruct().LeftHSGDIVector=[];
FileStruct().RightHSGDIVector=[];
FileStruct().LOutputVar=[];
FileStruct().ROutputVar=[];
FileStruct().OutputLab=[];
FileStruct().Left_AllVar=[];
FileStruct().Right_AllVar=[];

% Use this section to check that all files in the file list exist%
% 
% for ex = 1:length(Filepaths())
%     if (exist(Filepaths{ex}))== 2
%         thistrue(ex) = 2;
%     else 
%         thistrue(ex) = 0;
%     end
% end
%  thistrue = transpose(thistrue);
% if min(thistrue)== 0
%     return
% end

%CheckPelvis
OpenC3d_Code_Squat

toc
