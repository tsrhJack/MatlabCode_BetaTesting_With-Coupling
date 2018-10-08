function [LGaitCycle,RGaitCycle] = TimeNormalizeData(LCycles,RCycles, DataArray,Num_Variables, Startframe)

    % Created by Kirsten TUlchin-Francis on October 31, 2014
    % Last Updated: October 31, 2014
    % This m file will take all variables and time normalize them to the gait
    % cycle.

    global LGaitCycle
    global RGaitCycle
   
    LStart = int16(LCycles(1,1))-Startframe; %start of Left gait cycle
    LEnd = int16(LCycles(1,5))-Startframe; %end of Left gait cycle
    LDataCycle = DataArray([LStart:LEnd],:,:); %CutArray to match cycle
    
    sz = length(LDataCycle);
    x=0:1:(sz-1);
    x = (x/(sz-1))*100;
    for h=1:Num_Variables
        for i=1:3
            y=LDataCycle(:,i,h);
            for xx=0:100
                LGaitCycle(xx+1,i,h)=spline(x,y,xx);
            end
        end
    end
    
    
    RStart = int16(RCycles(1,1))-Startframe;
    REnd = int16(RCycles(1,5))-Startframe;
    RDataCycle =DataArray([RStart:REnd],:,:);
    sz = length(RDataCycle);
    x=0:1:(sz-1);
    x = (x/(sz-1))*100;
     for h=1:Num_Variables
        for i=1:3
            y=RDataCycle(:,i,h);
            for xx=0:100
                RGaitCycle(xx+1,i,h)=spline(x,y,xx);
            end
        end
    end
    
end
