function updateAverageVectorCodeOutput(outputAverageVectorCode, header, currentVariable1, currentPlane1, currentVariable2,...
                                currentPlane2, bincounts)
    global outputAverageVectorCode;
    global vectorCodeOutputRowCounter;
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

    vectorCodeOutputRowCounter = vectorCodeOutputRowCounter + 1;
end