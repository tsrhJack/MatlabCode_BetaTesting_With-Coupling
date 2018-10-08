function [RowVariable] = GetMeasures(LeftGaitCycle,RightGaitCycle,LCycleNorm,RCycleNorm,AngleLeft,AngleRight, Plane, Measure, Start, Stop, LeftROM, RightROM)

global Normalization

LAngleNum = int8(AngleLeft);
RAngleNum = int8(AngleRight);
PlaneNum = int8(Plane);
    
if Start < 6
    LStarttime =int8(round(LCycleNorm(1,Start)))+1;
    RStarttime = int8(round(RCycleNorm(1,Start)))+1;
else if Start == 6
        LStarttime = int8(round(LCycleNorm(1,4)*.33))+1;
        RStarttime = int8(round(RCycleNorm(1,4)*.33))+1;
    else if Start == 7
            LStarttime = int8(round(LCycleNorm(1,4)*.50))+1;
            RStarttime = int8(round(RCycleNorm(1,4)*.50))+1;
        else if Start == 8
                LStarttime = int8(round(LCycleNorm(1,4)*.66))+1;
                RStarttime = int8(round(RCycleNorm(1,4)*.66))+1;
            else if Start == 9
                    LStarttime = int8(round((LCycleNorm(1,5)-LCycleNorm(1,4))*.50+LCycleNorm(1,4)))+1;
                    RStarttime = int8(round((RCycleNorm(1,5)-RCycleNorm(1,4))*.50+RCycleNorm(1,4)))+1;
                else if Start == 10
                        LStarttime = 91;
                        RStarttime = 91;
                    end
                end
            end
        end
    end
end



if Stop < 4
    LStoptime =int8(round(LCycleNorm(1,Stop)))+1;
    RStoptime = int8(round(RCycleNorm(1,Stop)))+1;
else if Stop == 4
    LStoptime =int8(round(LCycleNorm(1,Stop)));
    RStoptime = int8(round(RCycleNorm(1,Stop)));
else if Stop == 5
    LStoptime =int8(round(LCycleNorm(1,Stop)))+1;
    RStoptime = int8(round(RCycleNorm(1,Stop)))+1;
else if Stop == 6
        LStoptime = int8(round(LCycleNorm(1,4)*.33))+1;
        RStoptime = int8(round(RCycleNorm(1,4)*.33))+1;
    else if Stop == 7
            LStoptime = int8(round(LCycleNorm(1,4)*.50))+1;
            RStoptime = int8(round(RCycleNorm(1,4)*.50))+1;
        else if Stop == 8
                LStoptime = int8(round(LCycleNorm(1,4)*.66))+1;
                RStoptime = int8(round(RCycleNorm(1,4)*.66))+1;
            else if Stop == 9
                    LStoptime = int8(round((LCycleNorm(1,5)-LCycleNorm(1,4))*.50+LCycleNorm(1,4)))+1;
                    RStoptime = int8(round((RCycleNorm(1,5)-RCycleNorm(1,4))*.50+RCycleNorm(1,4)))+1;
                else if Stop == 10
                        LStoptime = 91;
                        RStoptime = 91;
                    end
                end
            end
        end
    end
    end
    end
end


    
if LStoptime > 1       
    LeftVar = LeftGaitCycle(LStarttime:LStoptime,PlaneNum,LAngleNum);
else
    LeftVar = LeftGaitCycle(LStarttime,PlaneNum,LAngleNum);
end

if RStoptime > 1 
    RightVar = RightGaitCycle(RStarttime:RStoptime,PlaneNum,RAngleNum);
else
    RightVar = RightGaitCycle(RStarttime,PlaneNum,RAngleNum);
end


if Measure == 1 % Mean
    %Calculate mean between Start/Stop
    RowVariable(1,1)= mean(LeftVar);
    RowVariable(1,2)= mean(RightVar);
else if Measure == 2 %Max
        % Calculate maximum between start/stop
       [RowVariable(1,1),RowVariable(1,3)] = max(LeftVar);
       [RowVariable(1,2),RowVariable(1,4)] = max(RightVar);
       RowVariable(1,3) = RowVariable(1,3)-1+LStarttime-1;
       RowVariable(1,4) = RowVariable(1,4)-1+RStarttime-1;
    else if Measure == 3 %Min
            % Calculate minimum between start/stop
            [RowVariable(1,1),RowVariable(1,3)] = min(LeftVar);
            [RowVariable(1,2),RowVariable(1,4)]= min(RightVar);
            RowVariable(1,3) = RowVariable(1,3)-1+LStarttime-1;
            RowVariable(1,4) = RowVariable(1,4)-1+RStarttime-1;
        else if Measure == 4 % Value
                % calculate value at start time
                RowVariable(1,1) = LeftVar;
                RowVariable(1,2) = RightVar;
            else if Measure == 5 % Integral
                    % Calculate integral' between start stop
                    RowVariable(1,1) = trapz(LeftVar);
                    RowVariable(1,2) = trapz(RightVar);
                else if Measure == 6 %Range of Motion
                        %Calculate maximum between start/stop
                        [RowVariable(1,1),RowVariable(1,3)] = max(LeftVar);
                        [RowVariable(1,2),RowVariable(1,4)] = max(RightVar);
                        %Calculate minimum between start/stop
                        [RowVariable(1,5),RowVariable(1,7)] = min(LeftVar);
                        [RowVariable(1,6),RowVariable(1,8)]= min(RightVar);
                        %Calculate Range of Motion for left side
                        RowVariable(1,9) = max(LeftVar)-min(LeftVar);
                        RowVariable(1,3) = RowVariable(1,3)-1+LStarttime-1;
                        RowVariable(1,4) = RowVariable(1,4)-1+RStarttime-1;
                        RowVariable(1,7) = RowVariable(1,7)-1+LStarttime-1;
                        RowVariable(1,8) = RowVariable(1,8)-1+RStarttime-1;
                        %Calculate Range of Motion for right side
                        RowVariable(1,10) = max(RightVar)-min(RightVar);
                    end
                end
            end
        end
    end
end



