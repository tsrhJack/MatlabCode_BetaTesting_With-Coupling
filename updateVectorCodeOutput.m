function updateVectorCodeOutput(outputVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                                currentPlane2, bincounts)
    global outputVectorCode;
    global vectorCodeOutputRowCounter;
    global Normalization;
    outputVectorCode(vectorCodeOutputRowCounter, 1:length(header)) = header;
    outputVectorCode{vectorCodeOutputRowCounter, length(header)+1} = currentVariable1{:};
    outputVectorCode{vectorCodeOutputRowCounter, length(header)+2} = currentPlane1{:};
    outputVectorCode{vectorCodeOutputRowCounter, length(header)+3} = currentVariable2{:};
    outputVectorCode{vectorCodeOutputRowCounter, length(header)+4} = currentPlane2{:};

    % Bin Counts Cycle
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+5} = bincounts(1,1);
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+6} = bincounts(1,2);
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+7} = bincounts(1,3);
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+8} = bincounts(1,4);
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+9} = bincounts(1,5);
    outputVectorCode{vectorCodeOutputRowCounter,length(header)+10} = bincounts(1,6);
    
    if Normalization == 1
        % Bin Counts LR
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+11} = bincounts(2,1);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+12} = bincounts(2,2);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+13} = bincounts(2,3);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+14} = bincounts(2,4);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+15} = bincounts(2,5);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+16} = bincounts(2,6);

        % Bin Counts SLS
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+17} = bincounts(3,1);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+18} = bincounts(3,2);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+19} = bincounts(3,3);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+20} = bincounts(3,4);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+21} = bincounts(3,5);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+22} = bincounts(3,6);

        % Bin Counts PS
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+23} = bincounts(4,1);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+24} = bincounts(4,2);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+25} = bincounts(4,3);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+26} = bincounts(4,4);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+27} = bincounts(4,5);
        outputVectorCode{vectorCodeOutputRowCounter,length(header)+28} = bincounts(4,6);
    end

    vectorCodeOutputRowCounter = vectorCodeOutputRowCounter + 1;
end