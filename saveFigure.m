function saveFigure(subjectID, subjectFolder, fileName, mainFigure,figureName, subjectFolderSave, customsave, customSavePath)
    if mainFigure ~= 9999
        if isa(subjectID, 'double')
            figureName = char(strcat(num2str(subjectID), {' '}, fileName(1:end-4), {' - '}, figureName));
        else
            figureName = char(strcat(subjectID, {' '}, fileName(1:end-4), {' - '}, figureName));
        end
        if subjectFolderSave
            oldFolder = cd(subjectFolder);
            saveas(mainFigure, figureName, 'jpg')
            fprintf('Saved %s.jpg in patient folder\n', figureName)
            cd( oldFolder )
        end
        if customsave
            oldFolder = cd(customSavePath);
            saveas(mainFigure, figureName, 'jpg')
            fprintf('Saved %s.jpg in custom folder\n', figureName)
            cd( oldFolder )
        end
        close(mainFigure)
    else
        warning('Invalid figure for file %s (R Side, %s %s). Moving on to next side...', currentFile, currentVariable1{:}, currentVariable2{:})
    end
end