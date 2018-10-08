%Created by: Kirsten Tulchin-Francis on October 30, 2014
%Last Updated: March 26, 2017
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
global Variables;
global VariableStrings;
global VariableListFile;

global GDI_Only_Labels;
global AllKinematics_Labels;
global Left_AllVariables_Labels;
global Right_AllVariables_Labels;
global SaveFile;
global Normalization;
global extracode;
global extraOutputs;

ProblemFiles = {};
pf=1;
Target1 = Variables;

C3DCom = c3dserver;
[NumberFiles,holder]=size(FileStringArray);
thiswait = waitbar(0,'Processing')
clear DataArray
for i=1:NumberFiles
% for i = 28:NumberFiles
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
%             eval([v '= X']);
            DataArray(:,:,k) = X;
        end
        DataArrayLabels(k,1) = cellstr(v);
    end
    
%   for u = 23:24
%       V = DataArray(:,:,u);
%       for j = 1:3
%           for m=9999:length(V) %if still is NAN than make it 9999
%              W = DataArray(m,j,u);
%               if isnan(W)
%                   DataArray(m,j,u) = 0;
%               end
%           end
%       end
%    end
    
    %DataArray(isnan(DataArray))=999;
    x= i/NumberFiles;
    thisstring = ['Processing file: ' num2str(i)];
    waitbar(x,thiswait,thisstring)
    
    %Use interface to determine the gait cycle method.
    
    GetEvents_2017; % works for all files
    
end
%% When all files have been processed

%Write Vectors to ExcelFile
Num_Subs = size(FileStruct);
%Num_Subs = 234;

GDIcol=1;
LEKinecol=1;
Allcol=1;
%Run this loop on the variable_labels x3
for m=1:size(GDI_Only_Labels,1)
    GDI_ColumnA(GDIcol:(GDIcol+100),1) = cellstr(GDI_Only_Labels(m));
    GDIcol = 101*m+1;
end

for m=1:6
    LE_ColumnA(LEKinecol:(LEKinecol+100),1) = cellstr(AllKinematics_Labels(m));
    LEKinecol = 101*m+1;
end
Times(1,1) = 0;
for i = 1:100
    Times(i+1,1) = i;
end
TimeColumn = [];
if length(Left_AllVariables_Labels) == length(Right_AllVariables_Labels)
    for m=1:length(Left_AllVariables_Labels)
        ALL_ColumnA(Allcol:(Allcol+100),1) = cellstr(Left_AllVariables_Labels(m));
        Allcol = 101*m+1;
        TimeColumn(length(TimeColumn)+1:length(TimeColumn)+101,1) = Times(:,1);
    end
    
else
    h=errordlg('Left and Right Variable Lists are not equal length');
end
 
%% 
ColNum=1; 
for n = 1:Num_Subs(1,1)

        Thisside = FileStringArray(n,7);
             
   if strcmp(Thisside,'L') == 1
       % SubjectGDI_Vector(:,ColNum)= FileStruct(n).LeftGDI_Only;
       % SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Left_AllKinematics;
        SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Left_AllVariables;
        VariablePull(ColNum,:) = FileStruct(n).LOutputVar;

        SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
        SubjectGaitHeaders(ColNum,7)= cellstr('L');
   elseif strcmp(Thisside,'R') == 1
       % SubjectGDI_Vector(:,ColNum)= FileStruct(n).RightGDI_Only;
       % SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Right_AllKinematics;
         SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Right_AllVariables;
         VariablePull(ColNum,:) = FileStruct(n).ROutputVar;
           
         SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
         SubjectGaitHeaders(ColNum,7)= cellstr('R');
   elseif strcmp(Thisside, 'B') == 1
          %  SubjectGDI_Vector(:,ColNum)= FileStruct(n,1).LeftGDI_Only;
          %  SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Left_AllKinematics;
             SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Left_AllVariables;
             VariablePull(ColNum,:) = FileStruct(n,1).LOutputVar;
             SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
             SubjectGaitHeaders(ColNum,7)= cellstr('L');
             
             ColNum = ColNum+1;
          %  SubjectGDI_Vector(:,ColNum)= FileStruct(n,1).RightGDI_Only;
          %  SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Right_AllKinematics;
             SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Right_AllVariables;
             VariablePull(ColNum,:) = FileStruct(n,1).ROutputVar;
             SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
             SubjectGaitHeaders(ColNum,7)= cellstr('R');
             
        end
%     end
    ColNum=ColNum+1;
end
%% Create subject averages, if requested
if strcmp(AveFiles,'By Context')
    % use the number, reason and side
       NewFileString = strcat(FileStringArray(:,2),FileStringArray(:,5),FileStringArray(:,7));
       SubjectHeadersCat =strcat(SubjectGaitHeaders(:,2),SubjectGaitHeaders(:,5),SubjectGaitHeaders(:,7));
elseif strcmp(AveFiles,'Across Sides')
        % use number and reason
        NewFileString = strcat(FileStringArray(:,2),FileStringArray(:,5));
        SubjectHeadersCat =strcat(SubjectGaitHeaders(:,2),SubjectGaitHeaders(:,5));
end
%b=1;
% for n=1:size(NewFileString,1)
%     
%     if strcmp(teststring(end),'B')
%         FinalStrings(b,:)=strcat(teststring(n,1:end-1),'L');
%         b=b+1;
%         FinalStrings(b,:)=strcat(teststring(n,1:end-1),'R');
%     else
%         FinalStrings(b,:)=teststring;
%     end
%     b=b+1;
% end
%%
if strcmp(AveFiles,'No')
else
[Uniq,uniqindex] = unique(SubjectHeadersCat);
for l=1:length(Uniq)
    a=1;
    for m=1:size(SubjectALL_Vector,2)
        if strcmp(SubjectHeadersCat(m),Uniq(l))
            thisub(:,a)=SubjectALL_Vector(:,m);
            thisubcount=a;
            a=a+1;
        end
    end
    thissubave=mean(thisub,2);
    thisubtrials(:,l)=thisubcount;
    SubjectAves(:,l)=thissubave;
end
for l=1:length(Uniq)
    a=1;
    for m=1:size(VariablePull,1)
        if strcmp(SubjectHeadersCat(m),Uniq(l))
            thisub2(a,:)=VariablePull(m,:);
            thisubcount2=a;
            a=a+1;
        end
    end
    thissubave2=mean(thisub2,1);
    thisubtrials2(:,l)=thisubcount2;
    SubjectAves2(l,:)=thissubave2;
end
end

%%
SubjectGaitHeaders2 = transpose(SubjectGaitHeaders);

%Sheet 1 - GDI Vectors
xlswrite(SaveFile,SubjectGaitHeaders2,'Data','C1');
%xlswrite(SaveFile,NumberCycles,'Sheet1','B10');
xlswrite(SaveFile,SubjectALL_Vector,'Data','C11');
xlswrite(SaveFile,ALL_ColumnA,'Data','A11');
xlswrite(SaveFile,TimeColumn,'Data','B11');

%Sheet 2 - All Variable Vector
%xlswrite(SaveFile,SubjectGaitHeaders2,'Sheet2','B1');
%xlswrite(SaveFile,NumberCycles,'Sheet2','B10');
%xlswrite(SaveFile,SubjectALL_Vector,'Sheet2','B11');
%xlswrite(SaveFile,ALL_ColumnA,'Sheet2','A11');

%Sheet 3 - Outputvariables
VariableLab = FileStruct(1,1).OutputLab;
xlswrite(SaveFile,VariableLab,'Variables','J1');
xlswrite(SaveFile,SubjectGaitHeaders,'Variables','A2');
xlswrite(SaveFile,VariablePull,'Variables','J2');
%xlswrite('OutputGanz1.xlsx',ProblemFiles,'Sheet4','A1');

if strcmp(AveFiles,'No')
else
%Sheet4 - AveFiles
aveheadtemp=SubjectGaitHeaders(uniqindex,:);
aveheaders=aveheadtemp';
    xlswrite(SaveFile,aveheaders,'AveData','C1');
    xlswrite(SaveFile,thisubtrials,'AveData','C10');
    xlswrite(SaveFile,SubjectAves,'AveData','C11');
    xlswrite(SaveFile,ALL_ColumnA,'AveData','A11');
    xlswrite(SaveFile,TimeColumn,'AveData','B11');
end

%Sheet:AveVariables - Average Across Sides
xlswrite(SaveFile,VariableLab,'AveVariables','J1');
xlswrite(SaveFile,aveheadtemp,'AveVariables','A2');
xlswrite(SaveFile,SubjectAves2,'AveVariables','J2');

close(thiswait)

