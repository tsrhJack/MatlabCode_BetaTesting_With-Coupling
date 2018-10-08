function [RowVariable] = GetMeasuresTimeBased(FILECOUNT,DataArray,LCycles,RCycles,AngleLeft,AngleRight, Plane, Measure, Start, Stop,Startframe)

global FileStruct
global Normalization


tc = FileStruct(FILECOUNT,1).Cycle;
tc = tc(end);
thiscycle = str2num(tc);


LStart = int16(LCycles(thiscycle,1))-Startframe+1; %start of Left gait cycle
RStart = int16(RCycles(thiscycle,1))-Startframe+1; %start of Left gait cycle

if Normalization == 1 || Normalization == 2
    LEnd = int16(LCycles(thiscycle,5))-Startframe+1; %end of Left gait cycle
    REnd = int16(RCycles(thiscycle,5))-Startframe+1; %end of Left gait cycle
else
    if Normalization == 3 || Normalization == 4 || Normalization == 7
        LEnd = int16(LCycles(thiscycle,4))-Startframe+1; %end of Left gait cycle
        REnd = int16(RCycles(thiscycle,4))-Startframe+1; %end of Left gait cycle
    else
        if Normalization == 2 || Normalization == 5 || Normalization == 6 || Normalization == 8 || Normalization == 9
            LEnd = int16(LCycles(thiscycle,3))-Startframe+1; %end of Left gait cycle
            REnd = int16(RCycles(thiscycle,3))-Startframe+1; %end of Left gait cycle
        else
            LEnd = int16(LCycles(thiscycle,2))-Startframe+1; %end of Left gait cycle
            REnd = int16(RCycles(thiscycle,2))-Startframe+1; %end of Left gait cycle
        end
    end
end
LDataCycle = DataArray([LStart:LEnd],:,:); %CutArray to match cycle
RDataCycle = DataArray([RStart:REnd],:,:); %CutArray to match cycle

LAngleNum = int8(AngleLeft);
RAngleNum = int8(AngleRight);
PlaneNum = int8(Plane);

if Start < 6
    LStarttime =round(LCycles(thiscycle,Start));
    RStarttime = (round(RCycles(thiscycle,Start)));
else if Start == 6
        LStarttime = (round(LCycles(thiscycle,4)*.33));
        RStarttime = (round(RCycles(thiscycle,4)*.33));
    else if Start == 7
            LStarttime = (round(LCycles(thiscycle,4)*.50));
            RStarttime = (round(RCycles(thiscycle,4)*.50));
        else if Start == 8
                LStarttime = (round(LCycles(thiscycle,4)*.66));
                RStarttime = (round(RCycles(thiscycle,4)*.66));
            else if Start == 9
                    LStarttime = (round((LCycles(thiscycle,5)-LCycles(thiscycle,4))*.50+LCycles(thiscycle,4)));
                    RStarttime = (round((RCycles(thiscycle,5)-RCycles(thiscycle,4))*.50+RCycles(thiscycle,4)));
                else if Start == 10
                        LStarttime = 90;
                        RStarttime = 90;
                    end
                end
            end
        end
    end
end

LStarttime = int16(LStarttime-LCycles(thiscycle)+1);
RStarttime = int16(RStarttime-RCycles(thiscycle)+1);

if Stop < 4
    LStoptime =(round(LCycles(thiscycle,Stop)));
    RStoptime = (round(RCycles(thiscycle,Stop)));
else if Stop == 4
        LStoptime =(round(LCycles(thiscycle,Stop)))-1;
        RStoptime = (round(RCycles(thiscycle,Stop)))-1;
    else if Stop == 5
            LStoptime =(round(LCycles(thiscycle,Stop)));
            RStoptime = (round(RCycles(thiscycle,Stop)));
        else if Stop == 6
                LStoptime = (round(LCycles(thiscycle,4)*.33));
                RStoptime = (round(RCycles(thiscycle,4)*.33));
            else if Stop == 7
                    LStoptime = (round(LCycles(thiscycle,4)*.50));
                    RStoptime = (round(RCycles(thiscycle,4)*.50));
                else if Stop == 8
                        LStoptime =(round(LCycles(thiscycle,4)*.66));
                        RStoptime = (round(RCycles(thiscycle,4)*.66));
                    else if Stop == 9
                            LStoptime = (round((LCycles(thiscycle,5)-LCycles(thiscycle,4))*.50+LCycles(thiscycle,4)));
                            RStoptime = (round((RCycles(thiscycle,5)-RCycles(thiscycle,4))*.50+RCycles(thiscycle,4)));
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

LStoptime = int16(LStoptime-LCycles(thiscycle,1)+1);
RStoptime = int16(RStoptime-RCycles(thiscycle,1)+1);


if LStoptime > 1
    LeftVar = LDataCycle(LStarttime:LStoptime,PlaneNum,LAngleNum);
else
    LeftVar = LDataCycle(LStarttime,PlaneNum,LAngleNum);
end

if RStoptime > 1
    RightVar = RDataCycle(RStarttime:RStoptime,PlaneNum,RAngleNum);
else
    RightVar = RDataCycle(RStarttime,PlaneNum,RAngleNum);
end


if Measure == 1 % Mean
    %Calculate mean between Start/Stop
    RowVariable(1,1)= mean(LeftVar);
    RowVariable(1,2)= mean(RightVar);
else if Measure == 2 %Max
        % Calculate maximum between start/stop
        [RowVariable(1,1),RowVariable(1,3)] = max(LeftVar);
        [RowVariable(1,2),RowVariable(1,4)] = max(RightVar);
        RowVariable(1,3) = RowVariable(1,3);
        RowVariable(1,4) = RowVariable(1,4);
    else if Measure == 3 %Min
            % Calculate minimum between start/stop
            [RowVariable(1,1),RowVariable(1,3)] = min(LeftVar);
            [RowVariable(1,2),RowVariable(1,4)]= min(RightVar);
            RowVariable(1,3) = RowVariable(1,3);
            RowVariable(1,4) = RowVariable(1,4);
        else if Measure == 4 % Value
                % calculate value at start time
                RowVariable(1,1) = LeftVar;
                RowVariable(1,2) = RightVar;
            else if Measure == 5 % Integral
                    % Calculate integral' between start stop
                    LeftVar_nans=isnan(LeftVar);
                    Lnancount=length(find(LeftVar_nans));
                    if Lnancount == 0
                        RowVariable(1,1) = trapz(LeftVar)/120;
                    else
                        LeftVar=inpaint_nans(double(LeftVar),0);
                        RowVariable(1,1)=trapz(LeftVar)/120;
                    end
                    RightVar_nans=isnan(RightVar);
                    Rnancount=length(find(RightVar_nans));
                    if Rnancount==0
                        
                        RowVariable(1,2) = trapz(RightVar)/120;
                    else
                        RightVar=inpaint_nans(double(RightVar),0);
                        RowVariable(1,2) = trapz(RightVar)/120;
                    end
                end
            end
        end
    end
end



