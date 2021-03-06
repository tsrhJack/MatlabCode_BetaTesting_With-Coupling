function [LOutputVariables,ROutputVariables,OutputLabel]= Readvarblist(Outputmeasures,DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm)
j=1;

colheadings={'Variables','Plane','Start','Stop','Measure','OutputName','Timing'};

planeset = {'Sagittal','Coronal','Transverse'};
planevalues = num2cell([1,2,3]);
planemap = containers.Map(planeset,planevalues);

measureset={'Mean','Maximum','Minimum','Value','Integral','ROM'};
measurevalues = num2cell([1,2,3,4,5,6])';
measuremap = containers.Map(measureset,measurevalues);

timeset = {'Foot Strike','Opposite Foot Off','Opposite Foot Strike','Foot Off','33Stance','50Stance','66Stance','50Swing','90GaitCycle','NA'};
timevalues = num2cell([1,2,3,4,6,7,8,9,10,11]);
timemap = containers.Map(timeset,timevalues);

variableset = VariableList;
variablevalues = num2cell([1:length(VariableList)]);
variablemap = containers.Map(variableset,variablevalues);

for i=1:(size(Outputmeasures,1) %Normally should be to OM, changed to -1 for CalcGait Only
    Varb = OutputMeasures(i,1);
    firstlet = char(Varb);
    firstlet = firstlet(1);
    
    LVarb = strcat('L',Outputmeasures(i,1));
    RVarb = strcat('R',Outputmeasures(i,1));
    
    thisLangle = variablemap(LVarb{1});
    thisRangle = variablemap(RVarb{1});
    
    Plane = Outputmeasures(i,2);
    thisplane = planemap(Plane{1});
    
    measure = Outputmeasures(i,5);
    thismeasure = measuremap(measure{1});
    
    Startvarb = Outputmeasures(i,3);
    Stopvarb = Outputmeasures(i,4);
    
    thisstart = timemap(Startvarb{1});
    thisstop = timemap(Stopvarb{1});
    if thisstop == 1
        thisstop = 5;
    else if thisstop == 11;
            thisstop = 1;
        end
    end
    
    OPLabel = Outputmeasures(i,6);
    StrTiming = Outputmeasures(i,7);
    
    newvariables(i,:) = [thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop];
    if isequal(thismeasure,5) %If impulse measure used time based
        CalculatedVariable = GetMeasureTimeBased(DataArray,LCycles,RCycles,thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop,Startframe);
        LOutputVariables(1,j) = CalculatedVariable(1);
        ROutputVariables(1,j) = CalculatedVariable(2);
    else
        CalculatedVariable = GetMeasures(LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm,thisLangle,thisRangle,thisplane,thismeasure,thisstart,thisstop);
        LOutputVariables(1,j) = CalculatedVariable(1);
        ROutputVariables(1,j) = CalculatedVariable(2);
    end
    
    OutputLabel(1,j) = OPLabel;
    
    if strcmp(OutputMeasures{1,5},'ROM')        %%ADDED
        OPLabel2 = char(OPLabel);
        if strcmp(OPLabel2(end-2:end),'ROM')
                label = {OPLabel2(1:cellfun('length',OPLabel)-3)};
                OutputLabel(1,j)=strcat(label,'Max');
        end
    end
    
    k=findstr(Outputmeasures{i,1},'Moment'); %if its a moment - convert to Nm instead of Nmm
    
    if k >0
        LOutputVariables(1,j)=LOutputVariables(1,j)/1000;
        ROutputVariables(1,j)=ROutputVariables(1,j)/1000;
    end
    
    j=j+1;
    
    if strcmp(StrTiming,'Yes')
        if strcmp(measure,'ROM')
            if size(CalculatedVariable,2) == 2  %%added
                LOutputVariables(1,j) = CalculatedVariable(1);
                ROutputVariables(1,j) = CalculatedVariable(2);
            else
                LOutputVariables(1,j)=CalculatedVariable(3);
                ROutputVariables(1,j)=CalculatedVariable(4);
                OutputLabel(1,j)=strcat('Time',OPLabel);
                j=j+1;
                
                LOutputVariables(1,j)=CalculatedVariable(5);
                ROutputVariables(1,j)=CalculatedVariable(6);
                OutputLabel(1,j)=strcat(label,'Min');
                j=j+1;
                
                LOutputVariables(1,j)=CalculatedVariable(7);
                ROutputVariables(1,j)=CalculatedVariable(8);
                OutputLabel(1,j)=strcat('Time',OutputLabel(1,j-1));
                j=j+1;
                
                LOutputVariables(1,j)=CalculatedVariable(9);
                ROutputVariables(1,j)=CalculatedVariable(10);
                OutputLabel(1,j)=strcat(label,'ROM');
                j=j+1;
            end
        else
            LOutputVariables(1,j)=CalculatedVariable(1);
            ROutputVariables(1,j)=CalculatedVariable(2);
            OutputLabel(1,j)=strcat('Time',OPLabel);     %%changed from OPLabel
            j=j+1;
        end
    end
    
    if extracode == 3           %%added
        % This variable is for CalcGait and GCF Only
        MaxAnkleMoment = GetMeasures(LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm,15,17,1,2,1,5);
        nextone = length(LOutputVariables)+1;
        AnkleAngleatMaxMoment(1) = LeftGaitCycle(MaxAnkleMoment(3),1,4);
        AnkleAngleatMaxMoment(2) = RightGaitCycle(MaxAnkleMoment(4),1,9);
        LOutputVariables(1,nextone) = AnkleAngleatMaxMoment(1);
        ROutputVariables(1,nextone) = AnkleAngleatMaxMoment(2);
        OutputLabel(1,nextone) = cellstr('AnkleAngleatMaxMoment');
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
