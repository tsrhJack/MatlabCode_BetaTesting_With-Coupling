% created by Kirsten Tulchin-Francis on October 31, 2014
% Last updated: October 31, 2014
% This m file will extract event information from the c3d file.
% FootStrikes and ToeOffs for each side, as well as general events will be
% collected and sorted appropriately. The total number of cycles will be
% determined and for each side cycle information will be saved as followed
%
%  Cycles = [FS, OFO, OFS, FO, FS]
%
%If opposite foot off and foot strike are not available, values will remain
%at 0 for those events.
%
% All values are listed in video frames based upon a collection rate of
% 120.  Currently, does not handle unsided general events currently

%Create variables needed to store events by side and event type

RFootStrikeEvents =0;
RToeOffEvents=0;
 RGeneralEvents=0;
 LFootStrikeEvents=0;
 LToeOffEvents=0;
 LGeneralEvents=0;
global RCycles; % contains all cycle information as stated above
global LCycles; % contains all cycle information as stated above
global LNumCycles; % count of cycles
global RNumCycles; % count of cycles
global LeftGaitCycle;
global RightGaitCycle;
global LCycleNorm;
global RCycleNorm;
global OutputLabels;


FILECOUNT = FILECOUNT;
FileStruct = FileStruct;

Startframe = C3DCom.GetVideoFrame(0);
Endframe = C3DCom.GetVideoFrame(1);
SampleRate = C3DCom.GetVideoFrameRate;

EvIndex = C3DCom.GetParameterIndex('EVENT','LABELS'); %sets call type
EvItems = double(C3DCom.GetParameterLength(EvIndex)); %gets total# events
signalname = upper('PM5606_R.c3d');
signal_index = -1;

 bIndex = C3DCom.GetParameterIndex('EVENT', 'CONTEXTS'); %sets call type
 cIndex = C3DCom.GetParameterIndex('EVENT', 'LABELS');
 dIndex = C3DCom.GetParameterIndex('EVENT', 'TIMES');
 
 icountLFS = 1;
 icountLTO = 1;
 icountLGE = 1;
 icountRFS = 1;
 icountRTO = 1;
 icountRGE = 1;
    
for i=1:EvItems
    target_name = C3DCom.GetParameterValue(EvItems, i-1);
    newstring = target_name(1:min(findstr(target_name, ' '))-1);
    if strmatch(newstring, [], 'exact'),
        newstring = target_name;
    end
    if strmatch(upper(newstring), signalname, 'exact') == 1,
        signal_index = i-1;
    end
    
    bIndex = C3DCom.GetParameterIndex('EVENT', 'CONTEXTS'); %set call type
    cIndex = C3DCom.GetParameterIndex('EVENT', 'LABELS'); %set call type
    dIndex = C3DCom.GetParameterIndex('EVENT', 'TIMES'); %set call type

    %gets the context and type of event (Label)
    txtRawtmp = [C3DCom.GetParameterValue(bIndex, i-1),C3DCom.GetParameterValue(cIndex, i-1)];
    %gets the event time for that event (note, events are stored in even
    %numbered holders only
    timeRaw = double(C3DCom.GetParameterValue(dIndex, i*2-1));
    
    if strmatch(upper(txtRawtmp),'RIGHTFOOT OFF') 
       RToeOffEvents(icountRTO) = timeRaw; % gets time for event
       RToeOffEvents(icountRTO) = RToeOffEvents(icountRTO)*SampleRate+1; % converts to frames
       icountRTO = icountRTO + 1;
    elseif strmatch(upper(txtRawtmp),'LEFTFOOT OFF')
       LToeOffEvents(icountLTO) = timeRaw;
       LToeOffEvents(icountLTO) = LToeOffEvents(icountLTO)*SampleRate+1;
       icountLTO = icountLTO + 1;
    elseif strmatch(upper(txtRawtmp),'RIGHTFOOT STRIKE') 
       RFootStrikeEvents(icountRFS) = timeRaw;
       RFootStrikeEvents(icountRFS) = RFootStrikeEvents(icountRFS)*SampleRate+1;
       icountRFS = icountRFS+1;
    elseif strmatch(upper(txtRawtmp),'LEFTFOOT STRIKE')
       LFootStrikeEvents(icountLFS) = timeRaw;
       LFootStrikeEvents(icountLFS) = LFootStrikeEvents(icountLFS)*SampleRate+1;
       icountLFS = icountLFS+1;
    elseif strmatch(upper(txtRawtmp),'RIGHTEVENT') 
       RGeneralEvents(icountRGE) = timeRaw;
       RGeneralEvents(icountRGE) =RGeneralEvents(icountRGE)*SampleRate+1;
       icountRGE = icountRGE + 1;
    elseif strmatch(upper(txtRawtmp),'LEFTEVENT')   
       LGeneralEvents(icountLGE) = timeRaw;
       LGeneralEvents(icountLGE) = LGeneralEvents(icountLGE)*SampleRate+1;
       icountLGE = icountLGE + 1;
    elseif strmatch(upper(txtRawtmp),'GENERALEVENT')    
    end
   
end

% sorts the events into appropriate order
 RFootStrikeEvents = sort(RFootStrikeEvents);
 RToeOffEvents = sort(RToeOffEvents);
 RGeneralEvents = sort(RGeneralEvents);
 LFootStrikeEvents = sort(LFootStrikeEvents);
 LToeOffEvents = sort(LToeOffEvents);
 LGeneralEvents = sort(LGeneralEvents);

if LFootStrikeEvents > 1 % determines the number of cycles
    LNumCycles = length(LFootStrikeEvents)-1;
    LCycles = zeros(1,5); % sets cycle parameter to all zeros
else
    LNumCycles = 0; % if only 1 FS, than no cycles exist
end

if RFootStrikeEvents > 1
    RNumCycles = length(RFootStrikeEvents)-1;
    RCycles = zeros(1,5);
else
    RNumCycles = 0;
end

for i=1:LNumCycles
    LCycles(i,1) = LFootStrikeEvents(i); %  FS starts cycle
    LCycles(i,5) = LFootStrikeEvents(i+1); % subsequent FS ends cycle
    for j=1:length(LToeOffEvents)
        % if TO exists between two FS, then set to this cycle
        if LToeOffEvents(j) > LCycles(i,1) && LToeOffEvents(j) < LCycles(i,5)
            LCycles(i,4) = LToeOffEvents(j);
        end
    end
    for j=1:length(RToeOffEvents)
        % if OFO exists between two FS, then set to this cycle
        if RToeOffEvents(j) > LCycles(i,1) && RToeOffEvents(j) < LCycles(i,5)
            LCycles(i,2) = RToeOffEvents(j);
        end
    end
    for j=1:length(RFootStrikeEvents)
        % if OFS exists between two FS, then set to this cycle
        if RFootStrikeEvents(j) > LCycles(i,1) && RFootStrikeEvents(j) < LCycles(i,5)
            LCycles(i,3) = RFootStrikeEvents(j);
        end
    end
    LCycleNorm(i,1)= 0;
    LCycleNorm(i,5)=100;
    LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
    LCycleNorm(i,3)=(LCycles(i,3)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
    LCycleNorm(i,4)=(LCycles(i,4)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
    
end

for i=1:RNumCycles
    RCycles(i,1) = RFootStrikeEvents(i);
    RCycles(i,5) = RFootStrikeEvents(i+1);
    for j=1:length(RToeOffEvents)
        if RToeOffEvents(j) > RCycles(i,1) && RToeOffEvents(j) < RCycles(i,5)
            RCycles(i,4) = RToeOffEvents(j);
        end
    end
    for j=1:length(LToeOffEvents)
        if LToeOffEvents(j) > RCycles(i,1) && LToeOffEvents(j) < RCycles(i,5)
            RCycles(i,2) = LToeOffEvents(j);
        end
    end
    for j=1:length(LFootStrikeEvents)
        if LFootStrikeEvents(j) > RCycles(i,1) && LFootStrikeEvents(j) < RCycles(i,5)
            RCycles(i,3) = LFootStrikeEvents(j);
        end
    end
    RCycleNorm(i,1)= 0;
    RCycleNorm(i,5)=100;
    RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
    RCycleNorm(i,3)=(RCycles(i,3)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
    RCycleNorm(i,4)=(RCycles(i,4)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
    
end
%%
[LeftGaitCycle, RightGaitCycle] =TimeNormalizeData(LCycles,RCycles,DataArray,Num_Variables, Startframe);
FileStruct = GetSubjectGDIData(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT,FileStruct); % For gait cycle
%FileStruct = GetSubjectGDIData_AKDDH_BMI(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT,FileStruct); % For DDH BMI 
%FileStruct = GetSubjectGDIData_FandAError(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT,FileStruct); % For FANDA
%%
[LOutputVariables,ROutputVariables,OutputLabel] = Readvarblist(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm);

    
FileStruct(FILECOUNT,1).LOutputVar = LOutputVariables;
FileStruct(FILECOUNT,1).ROutputVar = ROutputVariables;
FileStruct(FILECOUNT,1).OutputLab = OutputLabel;
FileStruct(FILECOUNT,1).LeftHSGDIVector = LNumCycles;
FileStruct(FILECOUNT,1).RightHSGDIVector = RNumCycles;

   clearvars -except FileStringArray FileStruct Target1 Num_Variables Variables C3DCom NumberFiles thiswait pf ProblemFiles
