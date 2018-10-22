function [LGaitCycle,RGaitCycle] = TimeNormalizeData_2017(LCycles,RCycles, DataArray,Num_Variables, Startframe)

    % Created by Kirsten Tulchin-Francis on October 31, 2014
    % Last Updated: March 27,2017
    % This m file will take all variables and time normalize them to the gait
    % cycle.

    global LGaitCycle
    global RGaitCycle
    global LThisCycle 
    global RThisCycle
    global FILECOUNT
    global FileStruct
    
    FILECOUNT = FILECOUNT;
    FileStruct = FileStruct;
    
    % Currently written to use the cycle indicated on the filelist
    % ADD Question - use all cycles or only that indicataed in study
    
     if size(LCycles,1) >1 % more than one cycle noted
        Lcycleselect = FileStruct(FILECOUNT,1).Cycle;    % used the cycle from the filelist
        LThisCycle = Lcycleselect(end);
        LThisCycle = str2double(LThisCycle);
     else
        LThisCycle=1;
     end
     
     if size(RCycles,1) >1 % more than one cycle noted
        Rcycleselect = FileStruct(FILECOUNT,1).Cycle; % used the cycle from the filelist
        RThisCycle = Rcycleselect(end);
        RThisCycle = str2double(RThisCycle);
     else
        RThisCycle=1;
     end
    
  LStart = int16(LCycles(LThisCycle,1))-Startframe; %start of Left gait cycle
  RStart = int16(RCycles(RThisCycle,1))-Startframe; %Start of Right gait cycle
  
  if size(LCycles,2)==4  % If cycle has 4 events
      REnd = int16(RCycles(RThisCycle,4))-Startframe;
      LEnd = int16(LCycles(LThisCycle,4))-Startframe; %end of Left gait cycle
  else if size(LCycles,2)==5 % If cycle has 5 events
            REnd = int16(RCycles(RThisCycle,5))-Startframe;
            LEnd = int16(LCycles(LThisCycle,5))-Startframe; 
      else if size(LCycles,2) ==3 % If cycle has 3 events
               REnd = int16(RCycles(RThisCycle,3))-Startframe;
               LEnd = int16(LCycles(LThisCycle,3))-Startframe; 
          end
      end
  end
 
    LDataCycle = DataArray([LStart:LEnd],:,:); %CutArray to match cycle
    
    sz = length(LDataCycle);
    x=0:1:(sz-1);
    x = (x/(sz-1))*100;
    for h=1:Num_Variables
        for i=1:3
            y=LDataCycle(:,i,h);
            for xx=0:100
                warning off
                LGaitCycle(xx+1,i,h)=spline(x,y,xx);
                warning on
             end
        end
    end
    
    RDataCycle =DataArray([RStart:REnd],:,:);
    sz = length(RDataCycle);
    x=0:1:(sz-1);
    x = (x/(sz-1))*100;
     for h=1:Num_Variables
        for i=1:3
            y=RDataCycle(:,i,h);
            for xx=0:100
                warning off
                RGaitCycle(xx+1,i,h)=spline(x,y,xx);
                warning on
            end
        end
    end
    
end
