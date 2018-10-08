function updateVectorCodeOutput(outputVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                                currentPlane2, bincounts)
    global outputVectorCode;
    global vectorCodeOutputRowCounter;
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

    vectorCodeOutputRowCounter = vectorCodeOutputRowCounter + 1;
end