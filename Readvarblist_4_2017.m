function [LOutputVariables,ROutputVariables,OutputLabel]= Readvarblist_4_2017(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm)
j=1;

global Variables
global OutputMeasures
global Normalization
global FILECOUNT

colheadings={'Variables','Plane','Start','Stop','Measure','OutputName','Timing'};

planeset = {'Sagittal','Coronal','Transverse'};
planevalues = num2cell([1,2,3]);
planemap = containers.Map(planeset,planevalues);

measureset={'Mean','Maximum','Minimum','Value','Integral'};
measurevalues = num2cell([1,2,3,4,5])';
measuremap = containers.Map(measureset,measurevalues);

if Normalization == 3
    timeset = {'Foot Strike', 'Foot Off1', 'Foot Off2','NA'};
end
if Normalization == 4
    timeset = {'Foot Strike','General Event','Foot Off','NA'};
end
if Normalization == 7
    timeset = {'General Event', 'Foot Off', 'Foot Strike', 'NA'};
end

timevalues = num2cell([1,2,3,11]);
timemap = containers.Map(timeset,timevalues);
    
variableset = Variables;
variablevalues = num2cell([1:length(Variables)]);
variablemap = containers.Map(variableset,variablevalues);

for i=1:(size(OutputMeasures,1)) %Normally should be to OM, changed to -1 for CalcGait Only
    LVarb = strcat('L',OutputMeasures(i,1));
    RVarb = strcat('R',OutputMeasures(i,1));
    
    thisLangle = variablemap(LVarb{1});
    thisRangle = variablemap(RVarb{1});
    
    Plane = OutputMeasures(i,2);
    thisplane = planemap(Plane{1});
    
    measure = OutputMeasures(i,5);
    thismeasure = measuremap(measure{1});
    
    Startvarb = OutputMeasures(i,3);
    Stopvarb = OutputMeasures(i,4);
    thisstart = timemap(Startvarb{1});
    thisstop = timemap(Stopvarb{1});
    if thisstop == 1
        thisstop = 4;
    else if thisstop == 11;
            thisstop = thisstart;
        end
    end
    
    OPLabel = OutputMeasures(i,6);
    StrTiming = OutputMeasures(i,7);
    
    newvariables(i,:) = [thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop];
    if isequal(thismeasure,5) %If impulse measure used time based 
        CalculatedVariable = GetMeasureTimeBased(FILECOUNT,DataArray,LCycles,RCycles,thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop,Startframe);
        LOutputVariables(1,j) = CalculatedVariable(1);
        ROutputVariables(1,j) = CalculatedVariable(2);
    else
        CalculatedVariable = GetMeasures(LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm,thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop);
        LOutputVariables(1,j) = CalculatedVariable(1);
        ROutputVariables(1,j) = CalculatedVariable(2);
    end
    OutputLabel(1,j) = OPLabel;
    
    k=findstr(OutputMeasures{i,1},'Moment'); %if its a moment - convert to Nm instead of Nmm
    
    if k >0
        LOutputVariables(1,j)=LOutputVariables(1,j)/1000;
        ROutputVariables(1,j)=ROutputVariables(1,j)/1000;
    end
    
    j=j+1;
    
    if strcmp(StrTiming,'Yes')
        LOutputVariables(1,j)=CalculatedVariable(3);
        ROutputVariables(1,j)=CalculatedVariable(4);
        OutputLabel(1,j)=strcat('Time',OPLabel);
        j=j+1;
        if isequal(thisstart,1)
        else
            if thisstart >5 
            LOutputVariables(1,j)=CalculatedVariable(3)+int16(round(LCycleNorm(1,thisstart)*0.5));
            ROutputVariables(1,j)=CalculatedVariable(4)+int16(round(RCycleNorm(1,thisstart)*0.5));
            end
        end
    end
end

% This variable is for CalcGait and GCF Only
% MaxAnkleMoment = GetMeasures(LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm,17,18,1,2,1,5);
% nextone = length(LOutputVariables)+1;
% AnkleAngleatMaxMoment(1) = LeftGaitCycle(MaxAnkleMoment(3),1,4);
% AnkleAngleatMaxMoment(2) = RightGaitCycle(MaxAnkleMoment(4),1,9);
%      LOutputVariables(1,nextone) = AnkleAngleatMaxMoment(1);
%      ROutputVariables(1,nextone) = AnkleAngleatMaxMoment(2);
%     OutputLabel(1,nextone) = cellstr('AnkleAngleatMaxMoment');
end
