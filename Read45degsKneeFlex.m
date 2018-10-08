function [LOutputVariables,ROutputVariables,OutputLabel]= Read45degsKneeFlex(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm)
j=1;

global Variables
global extraOutputs

%read in StepDown60 Variable list
%read in StepDown60 Labels

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
LKneeAngle = LeftGaitCycle(:,1,3);
RKneeAngle = RightGaitCycle(:,1,8);

[LKneeMax,Lindice] = max(LKneeAngle);
[RKneeMax,RIndice] = max(RKneeAngle);

   LStarttime = Lindice;
   LKAOutput = 9999;
   if LKneeMax >45
       for i=1:length(LKneeAngle)-1;
           if (LKneeAngle(i)<45 && LKneeAngle(i+1)>45)
               LStarttime = i+1;
               LKAOutput = LKneeAngle(i+1);
               continue;
           else

           end
           
       end
        Lat45=1;
    else
        LKAOutput = LKneeMax;
        Lat45=0;
    end
 RStarttime = RIndice;
 RKAOutput = 9999; 
    if RKneeMax >45
        for i=1:length(RKneeAngle)-1;
           if (RKneeAngle(i)<45 && RKneeAngle(i+1)>45)
               RStarttime = i+1;
               RKAOutput = RKneeAngle(i+1);
           else

           end
       end
       Rat45=1;
    else
        RKAOutput=RKneeMax;
        Rat45=0;
    end

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

LOutputVariables(1,j)=LKAOutput;
LOutputVariables(1,j+1)=Lat45;
ROutputVariables(1,j)=RKAOutput;
ROutputVariables(1,j+1)=Rat45;
OutputLabel(1,j)=cellstr('KneeAngle');
OutputLabel(1,j+1)=cellstr('At45?');
end