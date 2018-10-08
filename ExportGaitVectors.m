function [] = ExportGaitVectors()
% this function will export all dynamic trials for each subject to a
% seperate file in excel.  It will export all foot vectors based upon the
% side indicated in the original fandafiles setup document

global PL
global Dynam
LHeader = {};
RHeader = {};
Ldatamatrix = [];
Rdatamatrix = [];
LHeaderALL = [];
RHeaderALL = [];
LdatamatrixALL = [];
RdatamatrixALL = [];
Lcount = 1;
Rcount = 1;
for i = 1:length(PL)
%for i= 1:4
    for j = 1:length(Dynam(i,1).file)
    thisside = Dynam(i,1).file(j,1).side;
%         if strcmp(thisside,'Left')
% %         LSubmatrix(:,Lsubcount) = [Dynam(i,1).file(j,1).LeftVector(1:1818,1);Dynam(i,1).file(j,1).LeftPIGVector(1:101,1);Dynam(i,1).file(j,1).LeftPIGVector(203:303,1);Dynam(i,1).file(j,1).LeftPIGVector(506:606,1)];
% %         LSubheader(:,Lsubcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
% %                     Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
% %                     Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
% %                     'Left','Cycle',Dynam(i,1).file(j,1).group));
% %         Lsubcount = Lsubcount +1;
%        Ldatamatrix(:,Lcount) = [Dynam(i,1).file(j,1).LeftVector(1:3939,1);Dynam(i,1).file(j,1).LeftPIGVector(1:303,1)];
%        LHeader(:,Lcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
%                    Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
%                    Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
%                    'Left','Cycle',Dynam(i,1).file(j,1).group));
%         Lcount = Lcount+1;
% 
%         else if strcmp(thisside,'Right')
% %                 Rsubmatrix(:,Rsubcount) = [Dynam(i,1).file(j,1).RightVector(1819:3636,1);Dynam(i,1).file(j,1).RightPIGVector(1:101,1);Dynam(i,1).file(j,1).RightPIGVector(203:303,1);Dynam(i,1).file(j,1).RightPIGVector(506:606,1)];
% %                 RSubheader(:,Rsubcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
% %                     Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
% %                     Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
% %                     'Right','Cycle',Dynam(i,1).file(j,1).group));
% %                 Rsubcount = Rsubcount+1;
%                 Rdatamatrix(:,Rcount) = [Dynam(i,1).file(j,1).RightVector(3940:7878,1);Dynam(i,1).file(j,1).RightPIGVector(304:606,1);Dynam(i,1).file(j,1).RightPIGVector(203:303,1)];
%                 RHeader(:,Rcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
%                     Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
%                     Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
%                     'Right','Cycle',Dynam(i,1).file(j,1).group));
%                 Rcount = Rcount+1;
%             else
%                 Lsubmatrix(:,Lsubcount) = [Dynam(i,1).file(j,1).LeftVector(1:1818,1);Dynam(i,1).file(j,1).LeftPIGVector(1:101,1);Dynam(i,1).file(j,1).LeftPIGVector(203:303,1);Dynam(i,1).file(j,1).LeftPIGVector(506:606,1)];
%                 Rsubmatrix(:,Rsubcount) = [Dynam(i,1).file(j,1).RightVector(1819:3636,1);Dynam(i,1).file(j,1).RightPIGVector(1:101,1);Dynam(i,1).file(j,1).RightPIGVector(203:303,1);Dynam(i,1).file(j,1).RightPIGVector(506:606,1)];
%                 LSubheader(:,Lsubcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
%                     Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
%                     Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
%                     'Left','Cycle',Dynam(i,1).file(j,1).group));
%                 RSubheader(:,Rsubcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
%                     Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
%                     Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
%                     'Right','Cycle',Dynam(i,1).file(j,1).group));
%                 Lsubcount=Lsubcount+1;
%                 Rsubcount=Rsubcount+1;
                Ldatamatrix(:,Lcount) = [Dynam(i,1).file(j,1).LeftVector(1:3939,1);Dynam(i,1).file(j,1).LeftPIGVector(1:303,1)];
                Rdatamatrix(:,Rcount) = [Dynam(i,1).file(j,1).RightVector(3940:7878,1);Dynam(i,1).file(j,1).RightPIGVector(304:606,1)];
                LHeader(:,Lcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
                    Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
                    Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
                    'Left','Cycle',Dynam(i,1).file(j,1).group));
                RHeader(:,Rcount) = cellstr(strvcat(Dynam(i,1).file(j,1).file,Dynam(i,1).file(j,1).sub,...
                    Dynam(i,1).file(j,1).first,Dynam(i,1).file(j,1).last,...
                    Dynam(i,1).file(j,1).group,Dynam(i,1).file(j,1).sess,...
                    'Right','Cycle',Dynam(i,1).file(j,1).group));
                Lcount=Lcount+1;
                Rcount=Rcount+1;
            %end
       % end
    end

    SubHeaders = [LHeader RHeader];
    SubOutputmatrix = num2cell([Ldatamatrix Rdatamatrix]);
    SubAllData = [SubHeaders;SubOutputmatrix];
    thissubfile = ['G:\FandA\Papers\2015 Marker Placement Accuracy\Updated\' Dynam(i,1).file(1,1).sub  '_'  Dynam(i,1).file(1,1).sess  '_fanda.xls'];
    [thisloc,thisfn,thisfext]=fileparts(PL(i,1).file);
    ptfolderfile = [thisloc '\Static.xlsx'];
  %  xlswrite(thissubfile,SubAllData,'Data','I1');
  %  xlswrite(ptfolderfile,SubAllData,'Data','I1');
    %PLsubfile = [Dynam(i,1).file(1,1).sub  '_'  Dynam(i,1).file(1,1).sess  '_PL.xls'];
    
    LHeaderALL = [LHeaderALL LHeader];
    RHeaderALL = [RHeaderALL RHeader];
    LdatamatrixALL = [LdatamatrixALL Ldatamatrix];
    RdatamatrixALL = [RdatamatrixALL Rdatamatrix];
    
    Lcount = 1; %reset subcount to 1 for both sides
    Rcount = 1;
    clear LHeader
    clear RHeader
    clear Ldatamatrix
    clear Rdatamatrix
end



Headers = [LHeaderALL RHeaderALL];
Outputmatrix = num2cell([LdatamatrixALL RdatamatrixALL]);
AllData = [Headers;Outputmatrix];
xlswrite('G:\FandA\Papers\2015 Marker Placement Accuracy\Updated\FootMarkerOutput.xls',AllData,'Data','I1');



end


