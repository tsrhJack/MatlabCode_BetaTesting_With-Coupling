function [LOutputVariables,ROutputVariables,OutputLabel]= ReadAtJointAngle(DataArray,LCycles,RCycles,Startframe,LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm)
j=1;

global Variables extraOutputs JointChosen PlaneChosen AtAngle

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
LAngle = LeftGaitCycle(:,PlaneChosen,JointChosen);
RAngle = RightGaitCycle(:,PlaneChosen,5+JointChosen);

[LKneeMax,Lindice] = max(LAngle);
[RKneeMax,RIndice] = max(RAngle);

   LStarttime = Lindice;
   LKAOutput = 9999;
   if LKneeMax > cell2mat(AtAngle)
       for i=1:length(LAngle)-1;
           if (LAngle(i)< str2num(char(AtAngle)) && LAngle(i+1) > str2num(char(AtAngle)))
               LStarttime = i+1;
               LKAOutput = LAngle(i+1);
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
    if RKneeMax > cell2mat(AtAngle)
        for i=1:length(RAngle)-1;
           if (RAngle(i)< str2num(char(AtAngle)) && RAngle(i+1) > str2num(char(AtAngle)))
               RStarttime = i+1;
               RKAOutput = RAngle(i+1);
           else

           end
       end
       Rat45=1;
    else
        RKAOutput=RKneeMax;
        Rat45=0;
    end

for i=1:(length(OutputMeasures2)) %Normally should be to OM, changed to -1 for CalcGait Only
    LVarb = strcat('L',OutputMeasures2(i,1));
    RVarb = strcat('R',OutputMeasures2(i,1));
    
    thisLangle = variablemap(LVarb{1});
    thisRangle = variablemap(RVarb{1});
    
    Plane = OutputMeasures2(i,2);
    thisplane = planemap(Plane{1});
    
    OPLabel = [char(OutputMeasures2(i,3)) 'at' char(AtAngle)];
       
    LAngleNum =int8(thisLangle);
    RAngleNum=int8(thisRangle);
    PlaneNum=int8(thisplane);
    
    LeftVar = LeftGaitCycle(LStarttime,thisplane,thisLangle);
    RightVar = RightGaitCycle(RStarttime,thisplane,thisRangle);
    
    LOutputVariables(1,j) = LeftVar;
    ROutputVariables(1,j) = RightVar;
    OutputLabel{1,j} = OPLabel;
    
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
% OutputLabel(1,j)=cellstr('KneeAngle');
% OutputLabel(1,j+1)=cellstr('At45?');
end

