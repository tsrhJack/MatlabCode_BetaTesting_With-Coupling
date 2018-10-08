%Created by: Kirsten Tulchin-Francis on December 1, 2014
%Last Updated: December 4, 2014

% This is the primary m code to read the list of files.
clear all
close all
clc

global filename   FileStruct Variables VariableStrings VariableListFile OutputMeasures SaveFile Normalization extracode extraOutputs AtAngle JointChosen PlaneChosen

tic
global folderLocation;
folderLocation = 'W:\Movement Science Lab\Staff\GHS\Results\FAI Squatting\Variable Pull';
% [filename,filepath] = uigetfile('*.xlsx', 'FILE LIST: Select your batch processing file list','c:\temp\');
[filename,filepath] = uigetfile('*.xlsx', 'FILE LIST: Select your batch processing file list', folderLocation);
CompleteFileName = strcat(filepath,filename);

% [fname,path,filter] = uigetfile([filepath,'*.xlsx'], 'VARIABLE LIST:Select your variable list','c:\temp\');
[fname,path,filter] = uigetfile([filepath,'*.xlsx'], 'VARIABLE LIST:Select your variable list', folderLocation);
VariableListFile = [path,fname];

% [sfname,spath,sfilter]=uiputfile([filepath,'*.xlsx'], 'SAVE FILE: Select your output file save file','c:\temp\');
[sfname,spath,sfilter]=uiputfile([filepath,'*.xlsx'], 'SAVE FILE: Select your output file save file', folderLocation);
SaveFile = [spath,sfname];

str = {'1. FS-OFO-OFC-TO-FS  ex. Typical Gait Cycle (bilateral steps',...
    '2. FS-TO-FS  ex .Single-side Gait Cycle, Deep Squat, Sit to Stand',...
    '3. FS-TO-TO-FS  ex. Squat Hold','4. FS-GE-TO-FS ex. Step Down',...
    '5. FS-TO-GE ex. Single Limb Squat, Toe Raises','6. TO-FS-GE ex. Drop Landing'...
    '7. GE-TO-FS-GE ex. Single Leg Leap (FAI)','8. FS-GE-TO ex. Hopping (GCF)',...
    '9. TO-FS-TO ex. Full Hip ROTs-Int (FAI)','10. FS-FS ex. Static','11. FS-GE ex. DropLanding Stance'};

[s]=listdlg('ListString',str,'SelectionMode','single','OKString','Select',...
    'ListSize',[450 160],'PromptString','Select the Normalization Scheme for your files.',...
    'Name','Choose Your Event Scheme');
Normalization=s;

Checkfiles = questdlg('Would you like to check your filelist first?',...
   'Check Files','Yes','No','Yes');
Checkfiles =0;
AveFiles = questdlg('Would you like to average your data by subject?',...
    'Average Files','By Context', 'Across Sides', 'No','By Context');


extrastr = {'1. StepDown60 (FAI Grant)', '2. Peak Squat Depth (FAI grant)','3. Value at MaxAnkleMoment','4. At Joint Angle'};

[extras]=listdlg('ListString',extrastr,'SelectionMode','single','OKString','Select',...
    'ListSize',[450 160],'PromptString','Select the special variables you would like to run.',...
    'Name','Choose Your Special Code');

extracode=extras;

if extracode == 1
    extrafilename = 'W:\Movement Science Lab\Staff\GHS\FAI Grant\MATLAB\StepDown60_VariableList.xlsx';
    [~, extraOutputs]=xlsread(extrafilename,'Measures','A:C');
end

if extracode == 2
    extrafilename = 'W:\Movement Science Lab\Staff\GHS\Results\FAI Squatting\Variable Pull\AtSquatDepth_VariableList.xlsx';
    [~, extraOutputs]=xlsread(extrafilename,'Measures','A:C');
end

if extracode == 3
    %Run ValueatMaxAnkleMoment
end

if extracode == 4
    [AtAngle] = inputdlg('What angle would you like variables to be pulled at?','Joint Angle',1);
    str = {'Trunk','Pelvis','Hip','Knee','Ankle','Foot Progression'};
    [JointChosen] = listdlg('ListString',str,'SelectionMode','single','OKString','Select',...
    'ListSize',[450 160],'PromptString','Select the joint.',...
    'Name','Choose Your Joint');
    str = {'X','Y','Z'};
    [PlaneChosen] = listdlg('ListString',str,'SelectionMode','single','OKString','Select',...
    'ListSize',[450 160],'PromptString','Select the plane.',...
    'Name','Choose Your Plane');
    extrafilename = 'W:\Movement Science Lab\Staff\GHS\Results\FAI Squatting\Variable Pull\AtJointAngle_VariableList.xlsx';
    [~, extraOutputs]=xlsread(extrafilename,'Measures','A:C');
end

%% Use this section to check that all files in the file list exist%

columnheadings = {'Filename', 'ID', 'Last', 'First', 'Group', 'Session','Side','Cycle','Study'};

global VariableList
[num2,VariableList]=xlsread(VariableListFile,'Variables');
Variables = VariableList(:,1);
VariableStrings = VariableList(:,2:4);
Num_Variables = size(Variables,1);

[~,OutputMeasures]=xlsread(VariableListFile,'Measures','A:G');
[num1, FileStringArray]=xlsread(CompleteFileName,'FileList','A:J');
num1_1 = num2str(num1);
thisnum = strcmp(FileStringArray(:,2),'');
numcount = 1;
for i= 1:size(FileStringArray(:,2))
    if thisnum(i)== 1
    FileStringArray(i,2)= cellstr(num1_1(numcount,:));
    numcount=numcount+1;
    end
end
Filepaths = FileStringArray(:,1);
%[path,filename,ext]=fileparts(Filepaths);

FileStruct = cell2struct(FileStringArray,columnheadings,2);
%[path,thisfile,ext]=fileparts(FileStruct().Filename);

if strcmp(Checkfiles,'Yes')
    for ex = 1:length(Filepaths())
        if (exist(Filepaths{ex}))== 2
            thistrue(ex) = 2;
        else 
            thistrue(ex) = 0;
        end
    end
     thistrue = transpose(thistrue);
    if min(thistrue)== 0
        return
    end
end
% Update this with the ones used in subject data
% FileStruct = struct('LeftGDI_Only',{},'RightGDI_Only',{},'Left_AllKinematics',{},'Right_AllKinematics',{},'LOutputVar',{},'ROutputVar',{},'OutputLab',{},'Left_AllVar',{},'Right_AllVar',{});
FileStruct(1).LeftGDI_Only=[];
FileStruct(1).RightGDI_Only=[];
FileStruct(1).Left_AllKinematics=[];
FileStruct(1).Right_AllKinematics=[];
FileStruct(1).Left_AllVariables=[];
FileStruct(1).Right_AllVariables=[];
FileStruct(1).LOutputVar=[];
FileStruct(1).ROutputVar=[];
FileStruct(1).OutputLab=[];
FileStruct(1).Left_AllVar=[];
FileStruct(1).Right_AllVar=[];



%CheckPelvis
OpenC3d_Code_2017

toc
