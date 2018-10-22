%Created by: Kirsten Tulchin-Francis on October 30, 2014
%Last Updated: March 26, 2017
% This is the primary m code to activate data pull for c3d files. It
% activates the c3dserver application to access data within the c3d file.
% It also has several subfunctions and subroutines including:
%   1. Uses window dialog box to open a single c3D file
%   2. Calls GetVariables to retrieve all necessary data
%   3. Calls GetEvents to retrieve and sort all gait events
%   4. Calls NormalizeData to normalize gait variables to appropriate cycle
close all force
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
global VariableListFile;
global CycleNorms;
CycleNorms = [];
appendPrompt = 'No'; % Default value that may not be assigned. Avoids errors

if Normalization == 1
    eventsMap = {'Foot Strike', 'Opposite Foot Off', 'Opposite Foot Strike', 'Foot Off', 'Foot Strike'};
elseif Normalization == 2
    eventsMap = {'Foot Strike', 'Foot Off', 'Foot Strike'};
elseif Normalization == 3
    eventsMap = {'Foot Strike', 'Foot Off1', 'Foot Off2','Foot Strike'};
elseif Normalization == 4
    eventsMap = {'Foot Strike','General Event','Foot Off','Foot Strike'};
elseif Normalization == 5
    eventsMap = {'Foot Strike', 'Foot Off', 'General Event'};
elseif Normalization == 6
    eventsMap = {'Foot Off', 'General Event', 'Foot Off'};
elseif Normalization == 7
    eventsMap = {'General Event', 'Foot Off', 'Foot Strike', 'General Event'};
elseif Normalization == 8
    eventsMap = {'Foot Strike', 'General Event', 'Foot Off'};
elseif Normalization == 9
    eventsMap = {'Foot Off', 'Foot Strike','Foot Off'};
elseif Normalization == 10
    eventsMap = {'Foot Strike', 'Foot Strike'};
elseif Normalization == 11
    eventsMap = {'Foot Strike', 'General Event'};
end

ProblemFiles = {};
pf=1;
Target1 = Variables;

% ASK JACK ABOUT THIS!
% Explaination from Jack - A newer foot model was run on some trials, and
% rather than save over the original c3d file, a new file was saved with
% _fa added to the file name (Ex. Original - trail08.c3d, new model -
% trial08_fa.c3d). This piece of code allows you to check for these newer
% files. Before pulling the data if a c3d file exists with the specified
% "suffix," the data will be pulled from that newer file rather than the
% old c3d file. 
% I was working with a very large file list, so this was more convinient solution than
% manually updating each of the file names in the list, although that may
% be a better solution.
% It is wrapped in a Normalization == 1 if statement, because I didn't want
% the prompt to bother anyone that didn't need this function, however I left in
% a "custom" option if anyone else needs to use it in a similar situation.
if Normalization == 1
    msg = ['Do you want to check for newer versions of the files? (Example: fileName.c3d ', ...
            ' will also look for fileName_fa.c3d)'];
    appendPrompt = questdlg(msg, 'Append To File Name', ...
                'No', '_fa', 'Custom', 'No');
    drawnow; pause(0.05);  % This prevents matlab from hanging after the response is recieved

    if ~strcmp(appendPrompt, 'No')
        switch appendPrompt
            case 'Custom'
                suffix = input('Try to append this to file names: ', 's');
            case '_fa'
                suffix = '_fa';
        end
    end
end

C3DCom = c3dserver;
[NumberFiles,holder]=size(FileStringArray);
thiswait = waitbar(0,'Processing');

for i=1:NumberFiles
    % for i = 28:NumberFiles
    FILECOUNT = i;
    if ~strcmp(appendPrompt, 'No')
        if isempty(strfind(FileStruct(i,1).Filename, suffix))
            if exist(strcat(FileStruct(i,1).Filename(1:end-4), suffix, '.c3d'), 'file') == 2
                msg = sprintf(['Current file is %s, and %s exists, so using that file instead.'], ...
                    FileStruct(i,1).Filename, strcat(FileStruct(i,1).Filename(1:end-4), suffix, '.c3d'));
                FileStruct(i,1).Filename = strcat(FileStruct(i,1).Filename(1:end-4), suffix, '.c3d');
                disp(msg)
            else
                msg = sprintf('%s does not exist. File will be skipped if model outputs are incomplete.', ...
                    strcat(FileStruct(i,1).Filename(1:end-4), suffix, '.c3d'));
                warning(msg)
            end
        end
    end
    openc3d(C3DCom,1,FileStruct(i,1).Filename);
    clear DataArray
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
    
    if strcmp(Thisside,'L') == 1 || strcmp(Thisside,'Left')
        % SubjectGDI_Vector(:,ColNum)= FileStruct(n).LeftGDI_Only;
        % SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Left_AllKinematics;
        SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Left_AllVariables;
        VariablePull(ColNum,:) = FileStruct(n).LOutputVar;
        
        SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
        SubjectGaitHeaders(ColNum,7)= cellstr('L');
    elseif strcmp(Thisside,'R') == 1 || strcmp(Thisside,'Right')
        % SubjectGDI_Vector(:,ColNum)= FileStruct(n).RightGDI_Only;
        % SubjectKine_Vector(:,ColNum)= FileStruct(n,1).Right_AllKinematics;
        SubjectALL_Vector(:,ColNum)=FileStruct(n,1).Right_AllVariables;
        VariablePull(ColNum,:) = FileStruct(n).ROutputVar;
        
        SubjectGaitHeaders(ColNum,:) = FileStringArray(n,:);
        SubjectGaitHeaders(ColNum,7)= cellstr('R');
    elseif strcmp(Thisside, 'B') == 1 || strcmp(Thisside,'Bilateral')
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
                thisCycle(:,a) = CycleNorms(:,m);
                thisubcount=a;
                a=a+1;
            end
        end
        thissubave=mean(thisub,2);
        thisubtrials(:,l)=thisubcount;
        SubjectAves(:,l)=thissubave;
        for i = 1:size(thisCycle,1)
            %CycleAves(i,s) = mean(thisCycle(i,:));
            % Note from Jack: The above line was in an older version of the
            % code. I suspected it was a typo, so I changed the "s" to an
            % "l". If this causes problems in the future, changing it back
            % to "s" may solve the problem, but ask me about it if that
            % happens! The Vector code requires CycleAves to be in a
            % specific format.
            CycleAves(i,l) = mean(thisCycle(i,:));
        end
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
warning off
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
    
    %Sheet:AveVariables - Average Across Sides
    xlswrite(SaveFile,VariableLab,'AveVariables','J1');
    xlswrite(SaveFile,aveheadtemp,'AveVariables','A2');
    xlswrite(SaveFile,SubjectAves2,'AveVariables','J2');
    warning on
end
close(thiswait)

%% VECTOR CODE
% Ask if you want to run the vector code
msg = 'Do you want to run a vector code analysis?';
vectorCodePrompt = questdlg(msg, 'Append To File Name', ...
    'Yes', 'No', 'No');
drawnow; pause(0.05);  % This prevents matlab from hanging after the response is recieved

if strcmp(vectorCodePrompt, 'Yes')
    
    [numVectorCode,txtVectorCode,rawVectorCode] = xlsread(VariableListFile, 'Vector Code');
    number_vector_code_pairs = size(txtVectorCode,1);
    % *************** Need to make sure the header here matches the header she has ***************
    outputVectorCodeColumnNames = {'File Name', 'Number', 'Last Name', 'First Name', 'Trial Type', ...
        'Session', 'Side', 'Cycle Info', 'Affected Side', 'Variable 1', 'Plane 1', ...
        'Variable 2', 'Plane 2', 'PD In-Phase', 'In-Phase', 'DD In-Phase', ...
        'DD Anti-Phase', 'Anti-Phase', 'PD Anti-Phase'};
    outputVectorCode = cell([NumberFiles*number_vector_code_pairs,length(outputVectorCodeColumnNames)]);
    outputVectorCode(1,:) = outputVectorCodeColumnNames;
    outputAverageVectorCode = cell([NumberFiles*number_vector_code_pairs,length(outputVectorCodeColumnNames)]);
    outputAverageVectorCode(1,:) = outputVectorCodeColumnNames;
    
    % Ask about where to save figures
    customsave = 0;
    subjectFolderSave = 0;
    
    msg = ['Where would you like to save the figures?'];
    SaveResponse = questdlg(msg, ...
        'Figure Save Location', ...
        'Custom Folder', 'Subject Folders', 'Both', 'Custom Folder');
    drawnow; pause(0.05);  % This prevents matlab from hanging after the response is recieved
    
    if strcmp(SaveResponse, 'Both')
        customsave = 1;
        subjectFolderSave = 1;
    elseif strcmp(SaveResponse, 'Subject Folders')
        customsave = 0;
        subjectFolderSave = 1;
    elseif strcmp(SaveResponse, 'Custom Folder')
        customsave = 1;
        subjectFolderSave = 0;
    end
    
    if customsave
        customSavePath = uigetdir();
    else
        customSavePath = '';
    end
    
    % Run vector code function on raw data
    global vectorCodeOutputRowCounter;
    global outputVectorCode;
    global outputAverageVectorCode;
    vectorCodeOutputRowCounter = 2;
    for ii = 1:size(SubjectALL_Vector,2)
        ii
        c3dName = SubjectGaitHeaders(ii,1);
        c3dName = c3dName{1}; % converts cell to string
        pattern = '(?<=\\)[0-9]{6}|(?<=\\)H{1}[0-9]{4}';
        subjectID = regexp(c3dName, pattern, 'match');
        slashes = strfind(c3dName,'\');
        subjectFolder = c3dName(1:max(slashes));
        fileName = c3dName(max(slashes)+1:end);
        side = SubjectGaitHeaders(ii,7);
        header = SubjectGaitHeaders(ii,:);
        DataColumn = SubjectALL_Vector(:,ii);
        CycleNorm = CycleNorms(:,ii);
        for j = 1:number_vector_code_pairs
            currentVariable1 = txtVectorCode(j,1);
            currentVariable2 = txtVectorCode(j,4);
            currentVariable1 = strcat(side,currentVariable1);
            currentVariable2 = strcat(side,currentVariable2);
            currentPlane1 = txtVectorCode(j,2);
            currentPlane2 = txtVectorCode(j,5);
            norm1 = numVectorCode(j,1);
            norm2 = numVectorCode(j,4);
            event1 = txtVectorCode(j,7);
            event2 = txtVectorCode(j,8);
            % Find event map, DataColumn
            [mainFigure,figureName, bincounts] = VectorCode(currentVariable1, currentPlane1, norm1, ...
                currentVariable2, currentPlane2, norm2, ...
                event1, event2, eventsMap, ...
                DataColumn, CycleNorm, ALL_ColumnA);
            saveFigure(subjectID, subjectFolder, fileName, mainFigure,figureName, subjectFolderSave,customsave, customSavePath)
            updateVectorCodeOutput(outputVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                currentPlane2, bincounts)
        end
    end
    
    % IF AveFiles = Yes
    % Run vector code function on SubjectAves]
    if AveFiles
        vectorCodeOutputRowCounter = 2;
        for ii = 1:size(SubjectAves,2)
            c3dName = aveheadtemp(ii,1);
            c3dName = c3dName{1}; % converts cell to string
            pattern = '(?<=\\)[0-9]{6}|(?<=\\)H{1}[0-9]{4}';
            subjectID = regexp(c3dName, pattern, 'match');
            slashes = strfind(c3dName,'\');
            subjectFolder = c3dName(1:max(slashes));
            fileName = c3dName(max(slashes)+1:end);
            side = aveheadtemp(ii,7);
            header = aveheadtemp(ii,:);
            DataColumn = SubjectAves(:,ii);
            CycleNorm = CycleAves(:,ii);
            for j = 1:number_vector_code_pairs
                currentVariable1 = txtVectorCode(j,1);
                currentVariable2 = txtVectorCode(j,4);
                currentVariable1 = strcat(side,currentVariable1);
                currentVariable2 = strcat(side,currentVariable2);
                currentPlane1 = txtVectorCode(j,2);
                currentPlane2 = txtVectorCode(j,5);
                norm1 = numVectorCode(j,1);
                norm2 = numVectorCode(j,4);
                event1 = txtVectorCode(j,7);
                event2 = txtVectorCode(j,8);
                % Find event map, DataColumn
                [mainFigure,figureName, bincounts] = VectorCode(currentVariable1, currentPlane1, norm1, ...
                    currentVariable2, currentPlane2, norm2, ...
                    event1, event2, eventsMap, ...
                    DataColumn, CycleNorm, ALL_ColumnA);
                saveAveFigure(subjectID, subjectFolder, fileName, mainFigure,figureName, subjectFolderSave,customsave, customSavePath)
                updateAverageVectorCodeOutput(outputAverageVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                    currentPlane2, bincounts)
            end
        end
    end
    
    %% Save data
    saveSuccess = 0;
    counter = 1;
    while ~saveSuccess
        try
            % Try to open a workbook.
            xlswrite(SaveFile, outputVectorCode, 'Vector Code')
            saveSuccess = 1;
        catch ME
            counter = counter + 1;
            msg = sprintf(['Unable to save Vector Code to the results file. Results is open in Excel? ',...
                'Please close %s'],SaveFile);
            causeException = MException('MATLAB:myCode:dimensions',msg);
            ME = addCause(ME,causeException);
            warning(strcat(ME.message, msg))
            irrelevant_response = questdlg(msg, ...
                'Please close excel file', ...
                'Ok', 'Ok');
            drawnow; pause(0.05);  % This prevents matlab from hanging after the response is recieved
            if counter > 3
                rethrow(ME)
            end
            pause(3)
        end
    end
    fprintf('Data added to ''Vector Code'' sheet in %s',SaveFile)
    
    if AveFiles
        saveSuccess = 0;
        counter = 1;
        while ~saveSuccess
            try
                % Try to open a workbook.
                xlswrite(SaveFile, outputAverageVectorCode, 'Ave Vector Code')
                saveSuccess = 1;
            catch ME
                counter = counter + 1;
                msg = sprintf(['Unable to save Ave Vector Code to the results file. Results is open in Excel? ',...
                    'Please close %s'],SaveFile );
                causeException = MException('MATLAB:myCode:dimensions',msg);
                ME = addCause(ME,causeException);
                warning(strcat(ME.message, msg))
                irrelevant_response = questdlg(msg, ...
                    'Please close excel file', ...
                    'Ok', 'Ok');
                drawnow; pause(0.05);  % This prevents matlab from hanging after the response is recieved
                if counter > 3
                    rethrow(ME)
                end
                pause(3)
            end
        end
        fprintf('Data added to ''Ave Vector Code'' sheet in %s',SaveFile)
    end
end
