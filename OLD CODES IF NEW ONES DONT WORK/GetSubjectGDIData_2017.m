function ThisStructure = GetSubjectGDIData_2017(LeftGaitCycle,RightGaitCycle,Variables, FILECOUNT, FileStruct,VariableStrings)

global LeftGDI_Only
global RightGDI_Only
global Left_AllKinematics
global Right_AllKinematics
global Left_AllVariables
global Right_AllVariables
global GDI_Only_Labels
global AllKinematics_Labels
global Left_AllVariables_Labels
global Right_AllVariables_Labels

%This is the "core" group of variables.If you have a lower extremity of
%full body marker set, DO NOT edit the first 10 rows of the variables tab
%in the variable_list excel file.  See notes for each sectionn below

% ******************************************************
% THIS SECTION PULLS THE GDI VECTOR ONLY - DO NOT EDIT

Left_pelvhip = LeftGaitCycle(:,:,1:2);
LeftGDI_Only = reshape(Left_pelvhip,[],1); %  pelvis, hip 
LeftGDI_Only(607:707,1) = LeftGaitCycle(:,1,3); % knee flex
LeftGDI_Only(708:808,1) = LeftGaitCycle(:,1,4); % ankle DF
LeftGDI_Only(809:909,1) = LeftGaitCycle(:,3,5); % FPA
 
Right_pelvhip = RightGaitCycle(:,:,6:7);
RightGDI_Only = reshape(Right_pelvhip,[],1); % pelvis, hip
RightGDI_Only(607:707,1) = RightGaitCycle(:,1,8); % ankle DF
RightGDI_Only(708:808,1) = RightGaitCycle(:,1,9); %foot rotation
RightGDI_Only(809:909,1) = RightGaitCycle(:,3,10); %FPA

GDIOnly_Labels(1:3,1) = transpose(VariableStrings(1,:)); % Pelvis Labels
GDIOnly_Labels(4:6,1) = transpose(VariableStrings(2,:)); % Hip Labels
GDIOnly_Labels(7,1) = transpose(VariableStrings(3,1)); % Knee Flex
GDIOnly_Labels(8,1) = transpose(VariableStrings(4,1)); %Ankle DF
GDIOnly_Labels(9,1) = transpose(VariableStrings(5,3)); %Foot Progression
GDI_Only_Labels = GDIOnly_Labels;

% Adds in the other LE kinematics
Left_AllKinematics=LeftGDI_Only;  %All LE Kinematics
Left_AllKinematics(910:1010,1)= LeftGaitCycle(:,2,3); % knee var/valg
Left_AllKinematics(1011:1111,1)= LeftGaitCycle(:,3,3); % tibial rotatoion
Left_AllKinematics(1112:1212,1) = LeftGaitCycle(:,3,4); % ankle rotation

Right_AllKinematics=RightGDI_Only;
Right_AllKinematics(910:1010,1) = RightGaitCycle(:,2,8); % knee var/valg
Right_AllKinematics(1011:1111,1) = RightGaitCycle(:,3,8); % tibial rotation
Right_AllKinematics(1112:1212,1) = RightGaitCycle(:,3,9); % ankle rotation

AllKinematics_Labels = GDIOnly_Labels;
AllKinematics_Labels(10:11,1) = transpose(VariableStrings(3,2:3)); %knee v/v, rotation
AllKinematics_Labels(12,1)=VariableStrings(4,3); %ankle rotation

% End of GDI VECTOR SECTION
% ************************************************************

% ************************************************************
% Additional Variables - This section will set the rest of your data. It
% goes line by line - if the variable string is xx it will not pull that
% data, otherwise it should pull everything you listed in the excel
% spreadsheet. THIS SHOULD NOT HAVE TO BE EDITTED

Left_AllVariables = Left_AllKinematics;
Right_AllVariables = Right_AllKinematics;
L_line = 1213;
R_line = 1213;
l_label=13;
r_label=13;
Left_AllVariables_Labels = AllKinematics_Labels;
Right_AllVariables_Labels = AllKinematics_Labels;

for j=11:length(Variables)
    if strncmpi(Variables(j,1),'R',1) % for RIGHT Variables
        
        % as long as the variable string is not 'xx' add the variable
        % to ALLVariables & the label to ALLVariables_labels array
        
        if strncmpi(VariableStrings(j,1),'xx',2) %SAGITTAL
        else
            Right_AllVariables(R_line:(R_line+100),1)=RightGaitCycle(:,1,j);
            R_line=R_line+101;
            Right_AllVariables_Labels(r_label,1)=VariableStrings(j,1);
            r_label=r_label+1;
        end
        if strncmpi(VariableStrings(j,2),'xx',2) %CORONAL
        else
            Right_AllVariables(R_line:(R_line+100),1)=RightGaitCycle(:,2,j);
            R_line=R_line+101;
            Right_AllVariables_Labels(r_label,1)=VariableStrings(j,2);
            r_label=r_label+1;
        end
        if strncmpi(VariableStrings(j,3),'xx',2) %TRANSVERSE
        else
            Right_AllVariables(R_line:(R_line+100),1)=RightGaitCycle(:,3,j);
            R_line=R_line+101;
            Right_AllVariables_Labels(r_label,1)=VariableStrings(j,3);
            r_label=r_label+1;
        end
        
    else % if variable doesn't start with R - NOTE: must start with 'L'
        
        if strncmpi(VariableStrings(j,1),'xx',2) % SAGITTAL
        else 
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,1,j);
            L_line=L_line+101;
            Left_AllVariables_Labels(l_label,1)=VariableStrings(j,1);
            l_label=l_label+1;
        end
        if strncmpi(VariableStrings(j,2),'xx',2) % CORONAL
        else
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,2,j);
            L_line=L_line+101;
            Left_AllVariables_Labels(l_label,1)=VariableStrings(j,2);
            l_label=l_label+1;
        end
        if strncmpi(VariableStrings(j,3),'xx',2) %TRANSVERSE
        else
            Left_AllVariables(L_line:(L_line+100),1)=LeftGaitCycle(:,3,j);
            L_line=L_line+101;
            Left_AllVariables_Labels(l_label,1)=VariableStrings(j,3);
            l_label=l_label+1;
        end
    end
end
     
%Arrays of only GDI variables
FileStruct(FILECOUNT,1).LeftGDI_Only = LeftGDI_Only; 
FileStruct(FILECOUNT,1).RightGDI_Only = RightGDI_Only;

%Arrays of only LE kinematic variables (GDI+knee var/val, tib rot, foot
%rotation
FileStruct(FILECOUNT,1).Left_AllKinematics = Left_AllKinematics;
FileStruct(FILECOUNT,1).Right_AllKinematics = Right_AllKinematics;

%Arrays with all variables in Variables tab of excel
FileStruct(FILECOUNT,1).Left_AllVariables = Left_AllVariables;
FileStruct(FILECOUNT,1).Right_AllVariables = Right_AllVariables;

ThisStructure = FileStruct;


