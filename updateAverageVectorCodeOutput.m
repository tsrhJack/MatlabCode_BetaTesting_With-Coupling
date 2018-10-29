function updateAverageVectorCodeOutput(outputAverageVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                                currentPlane2, bincounts)
    global outputAverageVectorCode;
    global vectorCodeOutputRowCounter;
    global Normalization;
    outputAverageVectorCode(vectorCodeOutputRowCounter, 1:length(header)) = header;
    outputAverageVectorCode{vectorCodeOutputRowCounter, length(header)+1} = currentVariable1{:};
    outputAverageVectorCode{vectorCodeOutputRowCounter, length(header)+2} = currentPlane1{:};
    outputAverageVectorCode{vectorCodeOutputRowCounter, length(header)+3} = currentVariable2{:};
    outputAverageVectorCode{vectorCodeOutputRowCounter, length(header)+4} = currentPlane2{:};
    
    % Bin Counts Cycle
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+5} = bincounts(1,1);
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+6} = bincounts(1,2);
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+7} = bincounts(1,3);
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+8} = bincounts(1,4);
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+9} = bincounts(1,5);
    outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+10} = bincounts(1,6);
    
    if Normalization == 1
        % Bin Counts LR
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+11} = bincounts(2,1);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+12} = bincounts(2,2);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+13} = bincounts(2,3);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+14} = bincounts(2,4);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+15} = bincounts(2,5);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+16} = bincounts(2,6);

        % Bin Counts SLS
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+17} = bincounts(3,1);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+18} = bincounts(3,2);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+19} = bincounts(3,3);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+20} = bincounts(3,4);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+21} = bincounts(3,5);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+22} = bincounts(3,6);

        % Bin Counts PS
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+23} = bincounts(4,1);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+24} = bincounts(4,2);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+25} = bincounts(4,3);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+26} = bincounts(4,4);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+27} = bincounts(4,5);
        outputAverageVectorCode{vectorCodeOutputRowCounter,length(header)+28} = bincounts(4,6);
    end
    vectorCodeOutputRowCounter = vectorCodeOutputRowCounter + 1;
end