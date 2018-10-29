%% created by Kirsten Tulchin-Francis on October 31, 2014
% Last updated: October 31, 2014
% This m file will extract event information from the c3d file.
% FootStrikes, ToeOffs and General events will be
% collected and sorted appropriately. The total number of cycles will be
% determined and saved for each side 
%
%If opposite foot off and foot strike are not available, values will remain
%at 0 for those events.
global RCycles; % contains all cycle information as stated above
global LCycles; % contains all cycle information as stated above
global LNumCycles; % count of cycles
global RNumCycles; % count of cycles
global LeftGaitCycle;
global RightGaitCycle;
global LCycleNorm;
global RCycleNorm;
global OutputLabels;
global OutputMeasures;
global Variables;
global VariableStrings;
global Normalization;
global extracode;
global extraOutputs;
global FILECOUNT;
global Left_AllVariables_Labels;
global Right_AllVariables_Labels;
global CycleNorms;

RFootStrikeEvents =0;
RToeOffEvents=0;
RGeneralEvents=0;
LFootStrikeEvents=0;
LToeOffEvents=0;
LGeneralEvents=0;

FILECOUNT = FILECOUNT;
FileStruct = FileStruct;
%% Pulls information from the c3d file

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
 
 %If running pull on statics, add footstrike events so they do not need to
 %be added manually for each trial. Default is 1 sec (120frames) starting
 %at frame 10.
 %LFootStrikeEvents = [10 130];
 %RFootStrikeEvents = [10 130];
%% Calculate #cycles for normalization Schemes that begin and end with FS ...
% with 5 events.

 if Normalization == 1 || Normalization ==2 
    
    if LFootStrikeEvents > 1 % determines the number of cycles
        LNumCycles = length(LFootStrikeEvents)-1;
        LCycles = zeros(1,5);
    else
        LNumCycles = 0; % if only 1 FS, than no cycles exist
    end

    if RFootStrikeEvents > 1
        RNumCycles = length(RFootStrikeEvents)-1;
        RCycles = zeros(1,5);
    else
        RNumCycles = 0;
    end
 end
 
%% Calculatae#cycles for normalization scheme that begin/end with FS with
% only 4 events
 
 if Normalization == 3 || Normalization == 4 
    
    if LFootStrikeEvents > 1 % determines the number of cycles
        LNumCycles = length(LFootStrikeEvents)-1;
        LCycles = zeros(1,4);
    else
        LNumCycles = 0; % if only 1 FS, than no cycles exist
    end

    if RFootStrikeEvents > 1
        RNumCycles = length(RFootStrikeEvents)-1;
        RCycles = zeros(1,4);
    else
        RNumCycles = 0;
    end
 end
 
 
%% Calcuate #cycles for those that start with FS and end with GE
% Also determines cycle events

if Normalization == 5
% CYCLES LEFT
    if length(LFootStrikeEvents) > length(LGeneralEvents)
       LNumCycles = length(LGeneralEvents);
       LCycles = zeros(1,3);
   else if length(LFootStrikeEvents) < length(LGeneralEvents)
           LNumCycles = length(LFootStrikeEvents);
           LCycles = zeros(1,3);
       else if length(LFootStrikeEvents)== length(LGeneralEvents) && length(LFootStrikeEvents) > 0
               LNumCycles = length(LFootStrikeEvents);
               LCycles = zeros(1,3);
           else
               LNumCycles = 0;
           end
       end
   end
% #CYCLES RIGHT
   if length(RFootStrikeEvents) > length(RGeneralEvents)
       RNumCycles = length(RGeneralEvents);
       RCycles = zeros(1,3);
   else if length(RFootStrikeEvents) < length(RGeneralEvents)
           RNumCycles = length(RFootStrikeEvents);
           RCycles = zeros(1,3);
       else if length(RFootStrikeEvents)== length(RGeneralEvents) && length(RFootStrikeEvents)>0
               RNumCycles = length(RFootStrikeEvents);
               RCycles = zeros(1,3);
           else
               RNumCycles = 0;
           end
       end
   end
% Create cycles L
       for i=1:LNumCycles %Sets events for Left Side
        LCycles(i,1) = LFootStrikeEvents(i); %  FS starts cycle
        if i<LNumCycles
            NextFS = LFootStrikeEvents(i+1);
            for k=1:length(LGeneralEvents)
                if  LGeneralEvents(k) > LCycles(i,1) && LGeneralEvents(k)<NextFS
                    LCycles(i,3) = LGeneralEvents(k);
                end
            end 
        else % last FS
            for k=1:length(LGeneralEvents)
                if LGeneralEvents(k) > LCycles(i,1)
                    LCycles(i,3) = LGeneralEvents(k);
                end
            end
        end
        for j=1:length(LToeOffEvents)
            % if TO exists between start.end, then set to this cycle
            if LToeOffEvents(j) > LCycles(i,1) && LToeOffEvents(j) < LCycles(i,3)
                LCycles(i,2) = LToeOffEvents(j);
            end
        end
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,3)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,3)-LCycles(i,1))*100;
       end
% Create cycles R
      for i=1:RNumCycles %Sets events for Left Side
        RCycles(i,1) = RFootStrikeEvents(i); %  FS starts cycle
        if i<RNumCycles
            NextFS = RFootStrikeEvents(i+1);
            for k=1:length(RGeneralEvents)
                if  RGeneralEvents(k) > RCycles(i,1) && RGeneralEvents(k)<NextFS
                    RCycles(i,3) = RGeneralEvents(k);
                end
            end 
        else % last FS
            for k=1:length(RGeneralEvents)
                if RGeneralEvents(k) > RCycles(i,1)
                    RCycles(i,3) = RGeneralEvents(k);
                end
            end
        end
        for j=1:length(RToeOffEvents)
            % if TO exists between start.end, then set to this cycle
            if RToeOffEvents(j) > RCycles(i,1) && RToeOffEvents(j) < RCycles(i,3)
                RCycles(i,2) = RToeOffEvents(j);
            end
        end
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,3)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,3)-RCycles(i,1))*100;
       end
end
%%  Calculate #cycles for normalization Schemes that begin TO & end GE.

if Normalization == 6
%Cycles L
    if length(LToeOffEvents) > length(LGeneralEvents)
       LNumCycles = length(LGeneralEvents);
       LCycles = zeros(1,3);
   else if length(LToeOffEvents) < length(LGeneralEvents)
           LNumCycles = length(LToeOffEvents);
           LCycles = zeros(1,3);
       else if length(LToeOffEvents)== length(LGeneralEvents) && LToeOffEvents>0
               LNumCycles = length(LToeOffEvents);
               LCycles = zeros(1,3);
           else
               LNumCycles = 0;
           end
       end
   end   
%Cycle R    
   if length(RToeOffEvents) > length(RGeneralEvents)
       RNumCycles = length(RGeneralEvents);
       RCycles = zeros(1,3);
   else if length(RToeOffEvents) < length(RGeneralEvents)
           RNumCycles = length(RToeOffEvents);
           RCycles = zeros(1,3);
       else if length(RToeOffEvents)== length(RGeneralEvents) && RToeOffEvents>0
               RNumCycles = length(RToeOffEvents);
               RCycles = zeros(1,3);
           else
               RNumCycles = 0;
           end
       end
   end
% Create cycles L
      for i=1:LNumCycles %Sets events for Left Side
        LCycles(i,1) = LToeOffEvents(i); %  FS starts cycle
        if i<LNumCycles
            NextFS = LToeOffEvents(i+1);
            for k=1:length(LGeneralEvents)
                if  LGeneralEvents(k) > LCycles(i,1) && LGeneralEvents(k)<NextFS
                    LCycles(i,3) = LGeneralEvents(k);
                end
            end 
        else % last FS
            for k=1:length(LGeneralEvents)
                if LGeneralEvents(k) > LCycles(i,1)
                    LCycles(i,3) = LGeneralEvents(k);
                end
            end
        end
        for j=1:length(LFootStrikeEvents)
            % if TO exists between start.end, then set to this cycle
            if LFootStrikeEvents(j) > LCycles(i,1) && LFootStrikeEvents(j) < LCycles(i,3)
                LCycles(i,2) = LFootStrikeEvents(j);
            end
        end
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,3)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,3)-LCycles(i,1))*100;
      end
% Create cycles R
      for i=1:RNumCycles %Sets events for Left Side
        RCycles(i,1) = RToeOffEvents(i); %  FS starts cycle
        if i<RNumCycles
            NextFS = RToeOffEvents(i+1);
            for k=1:length(RGeneralEvents)
                if  RGeneralEvents(k) > RCycles(i,1) && RGeneralEvents(k)<NextFS
                    RCycles(i,3) = RGeneralEvents(k);
                end
            end 
        else % last FS
            for k=1:length(RGeneralEvents)
                if RGeneralEvents(k) > RCycles(i,1)
                    RCycles(i,3) = RGeneralEvents(k);
                end
            end
        end
        for j=1:length(RFootStrikeEvents)
            % if TO exists between start.end, then set to this cycle
            if RFootStrikeEvents(j) > RCycles(i,1) && RFootStrikeEvents(j) < RCycles(i,3)
                RCycles(i,2) = RFootStrikeEvents(j);
            end
        end
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,3)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,3)-RCycles(i,1))*100;
       end
end
%% Calculatae #cycles for normalization schemes that being/end with GE
if Normalization == 7
% # Cycles L
    if LGeneralEvents > 1
        LNumCycles = length(LGeneralEvents)-1;
        if length(LToeOffEvents) < LNumCycles;
            LNumCycles = length(LToeOffEvents);
            LCycles = zeros(1,4);
        else
            LCycles = zeros(1,4);
        end
    else
        LNumCycles = 0;
    end
% # Cycle R
    if RGeneralEvents > 1
        RNumCycles = length(RGeneralEvents)-1;
        if length(RToeOffEvents) < RNumCycles;
            RNumCycles = length(RToeOffEvents);
            RCycles = zeros(1,4);
        else
            RCycles = zeros(1,4);
        end
    else
        RNumCycles = 0;
    end    
% Create Cycles L
    for i=1:LNumCycles %Sets events for Left Side
        LCycles(i,1) = LGeneralEvents(i); %  FS starts cycle
        LCycles(i,4) = LGeneralEvents(i+1); % subsequent FS ends cycle
        for j=1:length(LToeOffEvents)
            % if TO exists between two FS, then set to this cycle
            if LToeOffEvents(j) > LCycles(i,1) && LToeOffEvents(j) < LCycles(i,4)
                LCycles(i,2) = LToeOffEvents(j);
            end
        end
        for j=1:length(LFootStrikeEvents)
            % if OFS exists between two FS, then set to this cycle
            if LFootStrikeEvents(j) > LCycles(i,1) && LFootStrikeEvents(j) < LCycles(i,4)
                LCycles(i,3) = LFootStrikeEvents(j);
            end
        end
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,4)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
        LCycleNorm(i,3)=(LCycles(i,3)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
    end
% Create Cycles R
    for i=1:RNumCycles %Sets events for Left Side
        RCycles(i,1) = RGeneralEvents(i); %  FS starts cycle
        RCycles(i,4) = RGeneralEvents(i+1); % subsequent FS ends cycle
        for j=1:length(RToeOffEvents)
            % if TO exists between two FS, then set to this cycle
            if RToeOffEvents(j) > RCycles(i,1) && RToeOffEvents(j)< RCycles(i,4)
                RCycles(i,2) = RToeOffEvents(j);
            end
        end
        for j=1:length(RFootStrikeEvents)
            % if OFS exists between two FS, then set to this cycle
            if RFootStrikeEvents(j) > RCycles(i,1) && RFootStrikeEvents(j) < RCycles(i,4)
                RCycles(i,3) = RFootStrikeEvents(j);
            end
        end
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,4)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,4)-RCycles(i,1))*100;
        RCycleNorm(i,3)=(RCycles(i,3)-RCycles(i,1))/(RCycles(i,4)-RCycles(i,1))*100;
    end
end

%%  Calculate #cycles for normalization Schemes that begin FS & end TO.
if Normalization == 8
% # Cycles L
   if length(LFootStrikeEvents) > length(LToeOffEvents)
       LNumCycles = length(LToeOffEvents);
       LCycles = zeros(1,3);
   else if length(LFootStrikeEvents) < length(LToeOffEvents)
           LNumCycles = length(LFootStrikeEvents);
           LCycles = zeros(1,3);
       else if length(LFootStrikeEvents)== length(LToeOffEvents) && LFootStrikeEvents>0
               LNumCycles = length(LFootStrikeEvents);
               LCycles = zeros(1,3);
           else
               LNumCycles = 0;
           end
       end
   end
% # Cycles R 
   if length(RFootStrikeEvents) > length(RToeOffEvents)
       RNumCycles = length(RToeOffEvents);
       RCycles = zeros(1,3);
   else if length(RFootStrikeEvents) < length(RToeOffEvents)
           RNumCycles = length(RFootStrikeEvents);
           RCycles = zeros(1,3);
       else if length(RFootStrikeEvents)== length(RToeOffEvents) && RFootStrikeEvents>0
               RNumCycles = length(RFootStrikeEvents);
               RCycles = zeros(1,3);
           else
               RNumCycles = 0;
           end
       end
   end
% Create Cycles L
      for i=1:LNumCycles %Sets events for Left Side
        LCycles(i,1) = LFootStrikeEvents(i); %  FS starts cycle
        if i<LNumCycles
            NextFS = LFootStrikeEvents(i+1);
            for k=1:length(LToeOffEvents)
                if  LToeOffEvents(k) > LCycles(i,1) && LToeOffEvents(k)<NextFS
                    LCycles(i,3) = LToeOffEvents(k);
                end
            end 
        else % last FS
            for k=1:length(LToeOffEvents)
                if LToeOffEvents(k) > LCycles(i,1)
                    LCycles(i,3) = LToeOffEvents(k);
                end
            end
        end
        for j=1:length(LGeneralEvents)
            % if TO exists between start.end, then set to this cycle
            if LGeneralEvents(j) > LCycles(i,1) && LGeneralEvents(j) < LCycles(i,3)
                LCycles(i,2) = LGeneralEvents(j);
            end
        end
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,3)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,3)-LCycles(i,1))*100;
% Create Cycles R
      for i=1:RNumCycles %Sets events for Left Side
        RCycles(i,1) = RFootStrikeEvents(i); %  FS starts cycle
        if i<RNumCycles
            NextFS = RFootStrikeEvents(i+1);
            for k=1:length(RToeOffEvents)
                if  RToeOffEvents(k) > RCycles(i,1) && RToeOffEvents(k)<NextFS
                    RCycles(i,3) = RToeOffEvents(k);
                end
            end 
        else % last FS
            for k=1:length(RToeOffEvents)
                if RToeOffEvents(k) > RCycles(i,1)
                    RCycles(i,3) = RToeOffEvents(k);
                end
            end
        end
        for j=1:length(RGeneralEvents)
            % if TO exists between start.end, then set to this cycle
            if RGeneralEvents(j) > RCycles(i,1) && RGeneralEvents(j) < RCycles(i,3)
                RCycles(i,2) = RGeneralEvents(j);
            end
        end
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,3)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,3)-RCycles(i,1))*100;
       end
      end
end
%% Uses interface from start to determine the correct cycle type

if Normalization == 1 || Normalization == 2
    
    % FS-XX-XX-XX-FS cycles, no duplicate events
    % Required: FS=1 & FS=5 & TO=4. Optional Events: OFO=2 OFC=3
    % # Create Cycles L
    Lcount = 1;
    for i=1:LNumCycles %Sets events for Left Side

        for j=1:length(LToeOffEvents)
            % if TO exists between two FS, then set to this cycle
            if LToeOffEvents(j) > LFootStrikeEvents(i) && LToeOffEvents(j) < LFootStrikeEvents(i+1)
               LCycles(Lcount,1) = LFootStrikeEvents(i); %  FS starts cycle
               LCycles(Lcount,5) = LFootStrikeEvents(i+1); % subsequent FS ends cycle
               LCycles(Lcount,4) = LToeOffEvents(j);
               for j=1:length(RToeOffEvents)
                    % if OFO exists between two FS, then set to this cycle
                    if RToeOffEvents(j) > LFootStrikeEvents(i) && RToeOffEvents(j) < LFootStrikeEvents(i+1)
                        LCycles(Lcount,2) = RToeOffEvents(j);
                    end
               end
               for j=1:length(RFootStrikeEvents)
                    % if OFS exists between two FS, then set to this cycle
                    if RFootStrikeEvents(j) > LFootStrikeEvents(i) && RFootStrikeEvents(j) < LFootStrikeEvents(i+1)
                        LCycles(Lcount,3) = RFootStrikeEvents(j);
                    end
               end
               Lcount=Lcount+1;
            end
                   
        end

 
    end
    
    for i=1:size(LCycles,1)        
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,5)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
        LCycleNorm(i,3)=(LCycles(i,3)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
        LCycleNorm(i,4)=(LCycles(i,4)-LCycles(i,1))/(LCycles(i,5)-LCycles(i,1))*100;
        if LCycleNorm(i,2)<0 || (int16(LCycleNorm(i,2))==int16(LCycleNorm(i,4)))
            % if event is zero or if it is equal to toe-off (L/R side
            % events) set to zero
            LCycleNorm(i,2)=0;
        end
        if LCycleNorm(i,3)<0 || (int16(LCycleNorm(i,3))==int16(LCycleNorm(i,5)))
            LCycleNorm(i,3)=0;
        end
    end
% Create Cycles R
    Rcount =1;
    for i=1:RNumCycles
        for j=1:length(RToeOffEvents)
            if RToeOffEvents(j) > RFootStrikeEvents(i) && RToeOffEvents(j) < RFootStrikeEvents(i+1)
                RCycles(Rcount,1) = RFootStrikeEvents(i);
                RCycles(Rcount,5) = RFootStrikeEvents(i+1);
                RCycles(Rcount,4) = RToeOffEvents(j);
                for j=1:length(LToeOffEvents)
                    if LToeOffEvents(j) > RFootStrikeEvents(i) && LToeOffEvents(j) < RFootStrikeEvents(i+1)
                    RCycles(Rcount,2) = LToeOffEvents(j);
                    end
                end
                for j=1:length(LFootStrikeEvents)
                    if LFootStrikeEvents(j) > RFootStrikeEvents(i) && LFootStrikeEvents(j) < RFootStrikeEvents(i+1)
                    RCycles(Rcount,3) = LFootStrikeEvents(j);
                    end
                end
                Rcount=Rcount+1;
            end
        end
    end
    
    for i=1:size(RCycles,1)   
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,5)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
        RCycleNorm(i,3)=(RCycles(i,3)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
        RCycleNorm(i,4)=(RCycles(i,4)-RCycles(i,1))/(RCycles(i,5)-RCycles(i,1))*100;
        if RCycleNorm(i,2)<0 || (int16(RCycleNorm(i,2))== int16(RCycleNorm(i,4)))
            RCycleNorm(i,2)=0;
        end
        if RCycleNorm(i,3)<0 || (int16(RCycleNorm(i,3))== int16(RCycleNorm(i,5)))
            RCycleNorm(i,3)=0;
        end

    end
end



%% Uses interface from start to determine the correct cycle type for
% define events for normalization type3
if Normalization == 3 
    % Create Cycles L
    for i=1:LNumCycles %Sets events for Left Side
        LCycles(i,1) = LFootStrikeEvents(i); %  FS starts cycle
        LCycles(i,4) = LFootStrikeEvents(i+1); % subsequent FS ends cycle
        for j=1:length(LToeOffEvents)
            % if TO exists between two FS, then set to this cycle
            if LCycles(i,2) == 0
                if LToeOffEvents(j) > LCycles(i,1) && LToeOffEvents(j) < LCycles(i,4)
                    LCycles(i,2) = LToeOffEvents(j);
                end
            else
                if LToeOffEvents(j) > LCycles(i,2) && LToeOffEvents(j) < LCycles(i,4)
                    LCycles(i,3) = LToeOffEvents(j);
                end
            end
        end
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,4)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
        LCycleNorm(i,3)=(LCycles(i,3)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
    end
   % Creates Cycles R
    for i=1:RNumCycles %Sets events for Left Side
        RCycles(i,1) = RFootStrikeEvents(i); %  FS starts cycle
        RCycles(i,4) = RFootStrikeEvents(i+1); % subsequent FS ends cycle
        for j=1:length(RToeOffEvents)
            % if TO exists between two FS, then set to this cycle
            if RCycles(i,2) == 0
                if RToeOffEvents(j) > RCycles(i,1) && RToeOffEvents(j) < RCycles(i,4)
                    RCycles(i,2) = RToeOffEvents(j);
                end
            else
                if RToeOffEvents(j) > RCycles(i,2) && RToeOffEvents(j) < RCycles(i,4)
                    RCycles(i,3) = RToeOffEvents(j);
                end
            end
        end
        RCycleNorm(i,1)= 0;
        RCycleNorm(i,4)=100;
        RCycleNorm(i,2)=(RCycles(i,2)-RCycles(i,1))/(RCycles(i,4)-RCycles(i,1))*100;
        RCycleNorm(i,3)=(RCycles(i,3)-RCycles(i,1))/(RCycles(i,4)-RCycles(i,1))*100;
    end
end

%% Define events for normalization type4 FS-GE-TO-FS

if Normalization ==4
    % Create Cycles L
    Lcount=1;
    Rcount=1;
    
    for i=1:LNumCycles %Sets events for Left Side
      
        for j=1:length(LGeneralEvents)
            % if GE exists between two FS, then set to this cycle
            if LGeneralEvents(j) > LFootStrikeEvents(i) && LGeneralEvents(j) < LFootStrikeEvents(i+1)
               for k=1:length(LToeOffEvents)
                    % if TO exists between two FS, then set to this cycle
                    if LToeOffEvents(k) > LFootStrikeEvents(i) && LToeOffEvents(k) < LFootStrikeEvents(i+1)
                        LCycles(Lcount,3) = LToeOffEvents(k);
                        LCycles(Lcount,2) = LGeneralEvents(j);
                        LCycles(Lcount,1) = LFootStrikeEvents(i); %  FS starts cycle
                        LCycles(Lcount,4) = LFootStrikeEvents(i+1); % subsequent FS ends cycle
                        Lcount=Lcount+1;
                    end
                end
                
            end
            
        end
    end
    
    for i=1:size(LCycles,1)
        LCycleNorm(i,1)= 0;
        LCycleNorm(i,4)=100;
        LCycleNorm(i,2)=(LCycles(i,2)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
        LCycleNorm(i,3)=(LCycles(i,3)-LCycles(i,1))/(LCycles(i,4)-LCycles(i,1))*100;
    end
   
% Creates R Cycles
     for i=1:RNumCycles %Sets events for Left Side

        for j=1:length(RGeneralEvents)
            % if OFS exists between two FS, then set to this cycle
            if RGeneralEvents(j) > RFootStrikeEvents(i) && RGeneralEvents(j) < RFootStrikeEvents(i+1)
                for k=1:length(RToeOffEvents)
                    % if TO exists between two FS, then set to this cycle
                    if RToeOffEvents(k) > RFootStrikeEvents(i) && RToeOffEvents(k) < RFootStrikeEvents(i+1)
                        RCycles(Rcount,3) = RToeOffEvents(k);
                        RCycles(Rcount,2) = RGeneralEvents(j);
                        RCycles(Rcount,1) = RFootStrikeEvents(i); %  FS starts cycle
                        RCycles(Rcount,4) = RFootStrikeEvents(i+1); % subsequent FS ends cycle
                        Rcount=Rcount+1;
                    end
                end
            end      
        end
     end
     
     for r=1:size(RCycles,1)
        RCycleNorm(r,1)= 0;
        RCycleNorm(r,4)=100;
        RCycleNorm(r,2)=(RCycles(r,2)-RCycles(r,1))/(RCycles(r,4)-RCycles(r,1))*100;
        RCycleNorm(r,3)=(RCycles(r,3)-RCycles(r,1))/(RCycles(r,4)-RCycles(r,1))*100;
     end
end

%% For cycles of TO-FS-TO

if Normalization == 9
   if LToeOffEvents >1 % there exist more than 1 TO
       LNumCycles = length(LToeOffEvents)-1;
       LCycles = zeros(1,3);
   else
       LNumCycles =0;
   end
   
   if RToeOffEvents >1 % there exist more than 1 TO
       RNumCycles = length(RToeOffEvents)-1;
       RCycles = zeros(1,3);
   else
       RNumCycles =0;
   end
    
 Lcount = 1;
 for i=1:LNumCycles
     for j=1:length(LFootStrikeEvents)
         %if FS exists between 2 TOs
         if LFootStrikeEvents(j) > LToeOffEvents(i) && LFootStrikeEvents(j)<LToeOffEvents(i+1)
             LCycles(Lcount,1)=LToeOffEvents(i);
             LCycles(Lcount,3)=LToeOffEvents(i+1);
             LCycles(Lcount,2)=LFootStrikeEvents(j);
             Lcount=Lcount+1;
         end
     end
 end
 
for l=1:size(LCycles,1)
    LCycleNorm(l,1)=0;
    LCycleNorm(l,3)=100;
    LCycleNorm(l,2)=(LCycles(l,2)-LCycles(l,1))/(LCycles(l,3)-LCycles(l,1))*100;
end

 Rcount = 1;
 for i=1:RNumCycles
     for j=1:length(RFootStrikeEvents)
         %if FS exists between 2 TOs
         if RFootStrikeEvents(j) > RToeOffEvents(i) && RFootStrikeEvents(j)<RToeOffEvents(i+1)
             RCycles(Rcount,1)=RToeOffEvents(i);
             RCycles(Rcount,3)=RToeOffEvents(i+1);
             RCycles(Rcount,2)=RFootStrikeEvents(j);
             Rcount=Rcount+1;
         end
     end
 end
 
for r=1:size(RCycles,1)
    RCycleNorm(r,1)=0;
    RCycleNorm(r,3)=100;
    RCycleNorm(r,2)=(RCycles(r,2)-RCycles(r,1))/(RCycles(r,3)-RCycles(r,1))*100;
end

         
end
%% For Normalization 10 - FS-FS

if Normalization == 10
    if LFootStrikeEvents >2 % There exists more than 1 FS
        LNumCycles = length(LFootStrikeEvents)-1;
        LCycles=zeros(1,3);
        Lcount =1;
        for n=1:length(LFootStrikeEvents)-1
            LCycles(Lcount,1)=LFootStrikeEvents(n);
            LCycles(Lcount,3)=LFootStrikeEvents(n+1);
            Lcount=Lcount+1;
        end
    else
            LNumCycles =0;
    end
    if RFootStrikeEvents >2 % There exists more than 1 FS
        RNumCycles = length(RFootStrikeEvents)-1;
        RCycles=zeros(1,3);
        Rcount =1;
        for p=1:length(RFootStrikeEvents)-1
            RCycles(Rcount,1)=RFootStrikeEvents(n);
            RCycles(Rcount,3)=RFootStrikeEvents(n+1);
            Rcount=Rcount+1;
        end
    else
            RNumCycles =0;
    end

    for l=1:size(LCycles,1)
        LCycleNorm(l,1)=0;
        LCycleNorm(l,3)=100;
        LCycleNorm(l,2)=50;
    end
    
    for r=1:size(RCycles,1)
        RCycleNorm(r,1)=0;
        RCycleNorm(r,3)=100;
        RCycleNorm(r,2)=50;
    end
end


%% For Normalization 11 - FS-FS

if Normalization == 11
    if LFootStrikeEvents >1 % There exists more than 1 FS
        if LGeneralEvents >0
            LNumCycles = length(LFootStrikeEvents);
            LCycles=zeros(1,3);
            Lcount =1;
            for n=1:length(LFootStrikeEvents)
                LCycles(Lcount,1)=LFootStrikeEvents(n);
                LCycles(Lcount,3)=LGeneralEvents(n);
                Lcount=Lcount+1;
            end
        end
    else
            LNumCycles =0;
    end
    if RFootStrikeEvents >1 % There exists more than 1 FS
        if RGeneralEvents >0
            RNumCycles = length(RFootStrikeEvents);
            RCycles=zeros(1,3);
            Rcount =1;
            for p=1:length(RFootStrikeEvents)
                RCycles(Rcount,1)=RFootStrikeEvents(n);
                RCycles(Rcount,3)=RGeneralEvents(n);
                Rcount=Rcount+1;
            end
        end
    else
            RNumCycles =0;
    end

    for l=1:size(LCycles,1)
        LCycleNorm(l,1)=0;
        LCycleNorm(l,3)=100;
        LCycleNorm(l,2)=50;
    end
    
    for r=1:size(RCycles,1)
        RCycleNorm(r,1)=0;
        RCycleNorm(r,3)=100;
        RCycleNorm(r,2)=50;
    end
end
%% Runs the TimeNormalization and SubjectData functions for all schemes
    [LeftGaitCycle, RightGaitCycle] = TimeNormalizeData_2017(LCycles,RCycles,DataArray,Num_Variables, Startframe);
    FileStruct = GetSubjectGDIData_2017(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT,FileStruct,VariableStrings); % For gait cycle
    
%% Runs the ReadVarbList based on the number of events in the Cycle
if Normalization == 1 || Normalization == 2
   [LOutputVariables,ROutputVariables,OutputLabel] = Readvarblist_2017(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm);
end

if Normalization == 3 || Normalization == 4 || Normalization == 7
   [LOutputVariables,ROutputVariables,OutputLabel] = Readvarblist_4_2017(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm);
end

if Normalization == 5 || Normalization == 6 || Normalization == 8 || Normalization == 9 || Normalization == 10 || Normalization == 11
   [LOutputVariables,ROutputVariables,OutputLabel] = Readvarblist_3_2017(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm);
end                  
%% Run any additional code on the files (use for special Variable Codes, etc)
% Be sure to comment out any functions that are not applicable.
if extracode==1;
    [LSpecialVariables,RSpecialVariables,SpecialLabels]= ReadStepDown60(DataArray, LCycles,RCycles,Startframe, LeftGaitCycle,RightGaitCycle,LCycleNorm, RCycleNorm);
    LOutputVariables = [LOutputVariables LSpecialVariables];
    ROutputVariables = [ROutputVariables RSpecialVariables];
    OutputLabel = [OutputLabel SpecialLabels];
end

if extracode ==2;
    %Run PeakSquatDepth code
    [LSpecialVariables,RSpecialVariables,SpecialLabels]= ReadAtSquatDepth(DataArray, LCycles,RCycles,Startframe, LeftGaitCycle,RightGaitCycle,LCycleNorm, RCycleNorm);
    LOutputVariables = [LOutputVariables LSpecialVariables];
    ROutputVariables = [ROutputVariables RSpecialVariables];
    OutputLabel = [OutputLabel SpecialLabels];
end

if extracode ==4;
    %Run Joint Angle code
    [LSpecialVariables,RSpecialVariables,SpecialLabels]= ReadAtJointAngle(DataArray, LCycles,RCycles,Startframe, LeftGaitCycle,RightGaitCycle,LCycleNorm, RCycleNorm);    LOutputVariables = [LOutputVariables LSpecialVariables];
    ROutputVariables = [ROutputVariables RSpecialVariables];
    OutputLabel = [OutputLabel SpecialLabels];
end

%%  Write data to filestruct 
FileStruct(FILECOUNT,1).LOutputVar = LOutputVariables;
FileStruct(FILECOUNT,1).ROutputVar = ROutputVariables;
FileStruct(FILECOUNT,1).OutputLab = OutputLabel;
FileStruct(FILECOUNT,1).NumCycle(1) = length(LCycles);
FileStruct(FILECOUNT,1).NumCycle(2) = length(RCycles);
CycleNorms(:,end+1) = LCycleNorm';
CycleNorms(:,end+1) = RCycleNorm';
%%
   %clearvars -except FileStringArray FileStruct Target1 VariableListFile Num_Variables Right_AllVariables_Labels Left_AllVariables_Labels  Variables C3DCom NumberFiles thiswait pf ProblemFiles GDI_Only_Labels AllKinematics_Labels SaveFile AveFiles FILECOUNT suffix CycleNorms; 