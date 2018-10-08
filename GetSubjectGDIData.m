function ThisStructure = GetSubjectGDIData(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT, FileStruct)

global LeftGDIData
global RightGDIData
global Left_Allvar
global Right_Allvar

%pulls data from normalized cycle info and creates array of variables
%needed) 
%THIS SECTION NEEDS TO BE RE_WRITTEN... PULL GDI VECTOR,PULL HSGDI
%VECTOR+Trunk

%This is the "core" group of variables. Will create two vectors
% 1. GDI only is a 909 x 1 vector used for GDI/GPS calculations
LeftGDI_Only = LeftGaitCycle(:,:,1:2);
LeftGDI_Only = reshape(LeftGDI_Only,606,1); % pelvis, hip 3x
LeftGDI_Only(607:707,1) = LeftGaitCycle(:,1,3); % knee flex
LeftGDI_Only(708:808,1) = LeftGaitCycle(:,1,4); % ankle DF
LeftGDI_Only(809:909,1) = LeftGaitCycle(:,3,5); % FPA

RightGDI_Only = RightGaitCycle(:,:,6:7);
RightGDI_Only = reshape(RightGDI_Only,606,1); 
RightGDI_Only(607:707,1) = RightGaitCycle(:,1,8); %Knee flex
RightGDI_Only(708:808,1) = RightGaitCycle(:,1,9); %Ankle DF
RightGDI_Only(809:909,1) = RightGaitCycle(:,3,10); %FPA

%SetsLabelList
GDI_Only_Labels(1:3,1)=VariableStrings(1,:); %Pelvis Labels
GDI_Only_Labels(3:6,1)=VariableStrings(2,:); %Hip Labels
GDI_Only_Labels(7,1)=VariableStrings(3,1); %Knee Flex
GDI_Only_Labels(8,1)=VariableStrings(4,1); %Ankle DF
GDI_Only_Labels(9,1)=VariableStrings(5,3); %Foot Progression

%2. AllKinematics - Standard LE-only variables (no foot, trunk, kinetics)
Left_AllKinematics=LeftGDI_Only;  %All LE Kinematics
Left_AllKinematics(910:1010,1)=LeftGaitCycle(:,2,3); % knee var/valg
Left_AllKinematics(1011:1111,1)= LeftGaitCycle(:,3,3); % tibial rotatoion
Left_AllKinematics(1112:1212,1) = LeftGaitCycle(:,3,4); % ankle rotation

Right_AllKinematics=RightGDI_Only;
Right_AllKinematics(910:1010,1) = RightGaitCycle(:,2,8); % knee var/valg
Right_AllKinematics(1011:1111,1) = RightGaitCycle(:,3,8); % tibial rotation
Right_AllKinematics(1112:1212,1) = RightGaitCycle(:,3,9); % ankle rotation

% Sets AllKinematics Labels
AllKinematics_Labels = LeftGDI_Only_Labels;
AllKinematics_Labels(10:11,1) = VariableStrings(3,1:2); %knee v/v, rotation
AllKinematics_Labels(12,1)=VariableStrings(4,3); %ankle rotation

%3. All Variables included in list
Left_AllVariables = Left_AllKinematics;
L_line = 1213;

for j=11:length(Variables)
    if left(Variables(j,1)) == 'L'
        if (Variablesstrings(j,1)=='xx'
        else
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,1,j);
            L_line=L_line+101;
            Left_AllVariables_Labels
        end
        if (Variablesstrings(j,2)=='xx'
        else
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,2,j);
            L_line=L_line+101;
        end
        if (Variablesstrings(j,3)=='xx'
        else
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,3,j);
            L_line=L_line+101;
        end
    end
end

    
    
    
    



FileStruct(FILECOUNT,1).LeftGDIVector = LeftGDI_Only;
FileStruct(FILECOUNT,1).RightGDIVector = RightGDI_Only;
%FileStruct(FILECOUNT,1).LeftHSGDIVector = LeftHSGDI;
%FileStruct(FILECOUNT,1).RightHSGDIVector = RightHSGDI;
FileStruct(FILECOUNT,1).Left_AllVar = Left_Allvar;
FileStruct(FILECOUNT,1).Right_AllVar = Right_Allvar;
LeftGDIData = LeftGDI_Only;
RightGDIData = RightGDI_Only;

ThisStructure = FileStruct;
%Left/Right GDI_Only is a 909 x 1 array that includes 3d pelvis, 3d hip,
%kneeflex, ankleDF, foot progress
%Left/Right HSGDi is a 909 x 1 array that includes 3dpelvis, 3dhip, sag/cor
%hip moment, sag hip power

% Now need to call GPS_GDI_MatlabCode.m with  - pass it a) subject array...
% 909 x 1, the features and the control array (909 x m subjects)

%Write to new structure









