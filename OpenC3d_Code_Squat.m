%Created by: Kirsten Tulchin-Francis on October 30, 2014
%Last Updated: October 31, 2014
% This is the primary m code to activate data pull for c3d files. It
% activates the c3dserver application to access data within the c3d file.
% It also has several subfunctions and subroutines including:
%   1. Uses window dialog box to open a single c3D file
%   2. Calls GetVariables to retrieve all necessary data
%   3. Calls GetEvents to retrieve and sort all gait events
%   4. Calls NormalizeData to normalize gait variables to appropriate cycle
global DataArray;
global FILECOUNT;
global FileStruct;
global filename;
global VariableListFile;

[fname,path,filter] = uigetfile('*.xlsx', 'VariableList_final');
VariableListFile = [path,fname];
%VariableListFile = 'G:\GHS\FAI non-operative Study\Results\SCASB\2017\Non Op FAI Gait Variable List.xlsx';

[num2,VariableList]=xlsread(VariableListFile,'Variables');
Variables = VariableList;
Num_Variables = length(Variables);

ProblemFiles = {};
pf=1;
Target1 = Variables;

C3DCom = c3dserver;
[NumberFiles,holder]=size(FileStringArray);
thiswait = waitbar(0,'Processing')
clear DataArray
for i=1:NumberFiles

    FILECOUNT = i;
    openc3d(C3DCom,1,FileStruct(i,1).Filename);
    
    for k=1:Num_Variables
        v=cell2mat(genvarname(Target1(k,1)));
        X = get3dtarget(C3DCom,v,0);
        if isnan(X);
            v2 = strcat(FileStruct(i,1).Session,':',v);%add subject name to front of traj
            X=get3dtarget(C3DCom,v2,0); %pull Subj_traj
            eval([v '= X']);
            if isnan(X); %if still is NAN than make it 9999
                DataArray(:,:,k)=9999;
            else
                DataArray(:,:,k) = X;
            end
        else
            X=get3dtarget(C3DCom,v,0);
            eval([v '= X']);
            DataArray(:,:,k) = X;
        end
        DataArrayLabels(k,1) = cellstr(v);
    end
    
  for u = 23:24
      V = DataArray(:,:,u);
      for j = 1:3
          for m=9999:length(V) %if still is NAN than make it 9999
             W = DataArray(m,j,u);
              if isnan(W)
                  DataArray(m,j,u) = 0;
              end
          end
      end
   end
    
    %DataArray(isnan(DataArray))=999;
    x= i/NumberFiles;
    thisstring = ['Processing file: ' num2str(i)];
    waitbar(x,thiswait,thisstring)
    
    %Use interface to determine the gait cycle method.
    
    
    %Getevents_Kinematics;
    Getevents_KTF;
    %Getevents_ITB;
    %Getevents_Squat_ITB;
    %Getevents_Squat;
end
%%
%Write Vectors to ExcelFile
Num_Subs = size(FileStruct);
%Num_Subs = 234;

thiscol=1;
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMoment','SagKneePower','SagAnklePower','RawGRF-X','RawGRF-Y','RawGRF-Z','NormGRF-X','NormGRF-Y','NormGRF-Z','VGRF','NormVGRF','CentreofMass'}; %GetEvents_Squat_DDHSquat
%OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','KneeVarValg','TibRot','AnkleRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMom','CorKneeMom','SagAnkleMom','SagAnklePower','Trunktilt','TrunkLean','TrunkRot',};% GetEventsKTF
% OutputVectorLabels ={'HFDFPF','HFVarValg','HFRot','FFDFPF','FFInvEver','FFAbAd','ForeTibDFPF','ForeTibInvEver','ForeTibAbAd','HFmalDFPF','HFmalVarValg','HFmalRot','FFmalDFPF','FFmalInvEver','FFmalAbAd','FFnavDFPF','FFnavInvEver','FFnavAbAd','FnavTibDFPF','FnavTibInvEver','FnavTibAbAd','FnavMalDFPF','FnavMalInvEver','FnavMalAbAd','AnkDFPF','AnkRpt','FPA',}; %GetEventsKTF_FandaError
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagAnklePower',}; %GetEventsKTF_2016FAIGAIT
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMoment','SagKneePower','HJC-X','HJC-Y','HJC-Z', 'RawGRF-X','RawGRF-Y', 'RawGRF-Z','NormGRF-X','NormGRF-Y','NormGRF-Z','SagAnklePower'}; %GetEventsKTF_2016FAI_SQUAT
OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMoment','SagKneePower','SagAnklePower','RawGRF-X','RawGRF-Y','RawGRF-Z','NormGRF-X','NormGRF-Y','NormGRF-Z','VGRF','NormVGRF'}; %GetEventsKTF_DDHSquat
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','KneeVarValg','TibRot','AnkleRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMom','CorKneeMom','SagAnkleMom','SagAnklePower','Trunktilt','TrunkLean','TrunkRot','VGRF','NormVGRF'}; % GetEvents_ITB
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','KneeVarValg','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMoment','CorKneeMom','SagKneePower','HJC-X','HJC-Y','HJC-Z', 'RawGRF-X','RawGRF-Y', 'RawGRF-Z','NormGRF-X','NormGRF-Y','NormGRF-Z','SagAnklePower'}; %GetEventsKTF_2016ITB_SQUAT
%OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','KneeVarValg','TibRot','AnkleRot','Trunktilt','TrunkLean','TrunkRot',};% GetEventsKinematics
% OutputVectorLabels={'PelvicTilt','PelvicObliq','PelvicRot','HipFlex','HipAbAd','HipRot','KneeFlex','AnkleDF','FootProgress','Trunktilt','TrunkLean','TrunkRot','SagHipMoment','CorHipMoment','SagHipPower','SagKneeMoment','SagKneePower','SagAnklePower'}; %GetEventsKTF - GetSubjectGDI_AKDDH_BMI
for m=1:length(OutputVectorLabels)
    ColumnA(thiscol:(thiscol+100),1) = cellstr(OutputVectorLabels(m));
    thiscol = 101*m+1;
end


%%
ColNum=1;
for n = 1:Num_Subs(1,1)
%for n = 1:3
        Thisside = FileStringArray(n,7);
             
   if strcmp(Thisside,'L') == 1
        %SubjectGaitVectors(:,ColNum)= FileStruct(n,1).LeftGDIVector;
        SubjectGaitVectors(:,ColNum)= FileStruct(n,1).Left_AllVar;
        VariablePull(ColNum,:) = FileStruct(n,1).LOutputVar;
        NumberCycles(1,ColNum) = FileStruct(n,1).LeftHSGDIVector;
        SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
        SubjectGaitHeaders(ColNum,7)= cellstr('Left');
    else if strcmp(Thisside,'R') == 1
          %  SubjectGaitVectors(:,ColNum) = FileStruct(n,1).RightGDIVector;
            SubjectGaitVectors(:,ColNum) = FileStruct(n,1).Right_AllVar;
            VariablePull(ColNum,:) = FileStruct(n,1).ROutputVar;
            NumberCycles(1,ColNum) = FileStruct(n,1).RightHSGDIVector;
            SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
            SubjectGaitHeaders(ColNum,7)= cellstr('Right');
        else if strcmp(Thisside, 'B') == 1
           % SubjectGaitVectors(:,ColNum)= FileStruct(n,1).LeftGDIVector;
            SubjectGaitVectors(:,ColNum)= FileStruct(n,1).Left_AllVar;
            VariablePull(ColNum,:) = FileStruct(n,1).LOutputVar;
            NumberCycles(1,ColNum) = FileStruct(n,1).LeftHSGDIVector;
            SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
            SubjectGaitHeaders(ColNum,7)= cellstr('Left');
            
            ColNum = ColNum+1;
          % SubjectGaitVectors(:,ColNum) = FileStruct(n,1).RightGDIVector;
            SubjectGaitVectors(:,ColNum) = FileStruct(n,1).Right_AllVar;
            VariablePull(ColNum,:) = FileStruct(n,1).ROutputVar;
            NumberCycles(1,ColNum) = FileStruct(n,1).RightHSGDIVector;
            SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
            SubjectGaitHeaders(ColNum,7)= cellstr('Right');
            end
        end
    end
    ColNum=ColNum+1;
end
%%
SubjectGaitHeaders2 = transpose(SubjectGaitHeaders);
SaveFile = 'G:\GHS\Squat\DDH Squatting\Bilateral vs Unilateral DDH COP\Results\N Squat Data.xlsx';
xlswrite(SaveFile,SubjectGaitHeaders2,'Sheet1','B1');
xlswrite(SaveFile,NumberCycles,'Sheet1','B10');
xlswrite(SaveFile,SubjectGaitVectors,'Sheet1','B11');
xlswrite(SaveFile,ColumnA,'Sheet1','A11');
VariableLab = FileStruct(1,1).OutputLab;
xlswrite(SaveFile,VariableLab,'Sheet2','J1');
xlswrite(SaveFile,SubjectGaitHeaders,'Sheet2','A2');
xlswrite(SaveFile,VariablePull,'Sheet2','J2');
%xlswrite('OutputGanz1.xlsx',ProblemFiles,'Sheet4','A1');

%close(thiswait)

