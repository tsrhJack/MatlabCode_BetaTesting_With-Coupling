function [LOutputVariables,ROutputVariables,OutputLabel]= ReadAtSquatDepth(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm)
j=1;

global Variables
global extraOutputs

%read in AtSquatDepth Variables
%read in AtSquatDepth Labels

OutputMeasures2=extraOutputs;
colheadings={'Variables','Plane','OutputName'};

planeset = {'Sagittal','Coronal','Transverse'};
planevalues = num2cell([1,2,3]);
planemap = containers.Map(planeset,planevalues);

% All variables are values at Knee = 60degs
% measureset={'Mean','Maximum','Minimum','Value','Integral'};
% measurevalues = num2cell([1,2,3,4,5])';
% measuremap = containers.Map(measureset,measurevalues);

% timeset = {'Knee60','NA'};
% timevalues = num2cell([20,11]);
% timemap = containers.Map(timeset,timevalues);
    
variableset = Variables;
variablevalues = num2cell([1:length(Variables)]);
variablemap = containers.Map(variableset,variablevalues);

%Find PeakKnee Angle
%LKneeAngNum = 3;
%RKneeAngNum = 8;
LHipJointZ = LeftGaitCycle(:,3,variablemap('LFEP'));
RHipJointZ = RightGaitCycle(:,3,variablemap('RFEP'));

[LSquatDepth,Lindice] = min(LHipJointZ);
[RSquatDepth,RIndice] = min(RHipJointZ);

    LStarttime = Lindice;
    LSDOutput = LSquatDepth;

    RStarttime = RIndice;
    RSDOutput = RSquatDepth;


for i=1:(length(OutputMeasures2)-1) %Normally should be to OM, changed to -1 for CalcGait Only
    LVarb = strcat('L',OutputMeasures2(i,1));
    RVarb = strcat('R',OutputMeasures2(i,1));
    
    thisLangle = variablemap(LVarb{1});
    thisRangle = variablemap(RVarb{1});
    
    Plane = OutputMeasures2(i,2);
    thisplane = planemap(Plane{1});
    
    OPLabel = OutputMeasures2(i,3);
       
    LAngleNum =int8(thisLangle);
    RAngleNum=int8(thisRangle);
    PlaneNum=int8(thisplane);
    
    LeftVar = LeftGaitCycle(LStarttime,PlaneNum,LAngleNum);
    RightVar = RightGaitCycle(RStarttime,PlaneNum,RAngleNum);
    
    LOutputVariables(1,j) = LeftVar;
    ROutputVariables(1,j) = RightVar;
    OutputLabel(1,j) = OPLabel;
    
    k=findstr(OutputMeasures2{i,1},'Moment'); %if its a moment - convert to Nm instead of Nmm
    if k >0
        LOutputVariables(1,j)=LOutputVariables(1,j)/1000;
        ROutputVariables(1,j)=ROutputVariables(1,j)/1000;
    end
    
    j=j+1;
    
    
end

LOutputVariables(1,j)=LSDOutput;
ROutputVariables(1,j)=RSDOutput;
OutputLabel(1,j)=cellstr('SD Used');

end
