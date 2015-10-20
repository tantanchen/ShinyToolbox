library(plyr)

CheckMatchingRecords<-function(inputTable, matchTable, match = "all", ids=intersect(colnames(inputTable),colnames(matchTable))){
    matchTable$Match <-TRUE
    x <- join(inputTable, matchTable, by = ids, match = match)
    return(!is.na(x$Match))
}

# This takes two tables with the same column names, and merges them by all but one of the columns, 
# defined by the third input. var is a character of the name of the column.
# Then it takes the absolute difference of the var column and outputs that into one table
TableOfDifferences <- function(input1 = data.frame(), input2 = data.frame(), var = character()){
    if(is.null(var))
        var <- colnames(input1)[1]
    listToJoinBy <- colnames(input1)
    listToJoinBy <- listToJoinBy[!(listToJoinBy %in% var)]
    output <- merge(input1, input2, by = listToJoinBy, all=TRUE)
    temp <- subset(output, select = c(paste(var, ".x",sep=""), paste(var, ".y",sep="")))
    temp[is.na(temp)] <- 0
    temp <- data.frame(abs(temp[,paste(var, ".x",sep="")] - temp[,paste(var, ".y",sep="")]))
    colnames(temp) <- paste(var, ".diff",sep="")
    output <- cbind(output, temp)
    output <- output[output[paste(var, ".diff",sep="")] > 0,] #filter to include differences greater than 0
    output <- subset(output, select = c(paste(var, ".x",sep=""), paste(var, ".y",sep=""), paste(var, ".diff",sep=""),listToJoinBy))
    colnames(output) <- c(paste(var, ".1",sep=""), paste(var, ".2",sep=""), paste(var, ".diff",sep=""),listToJoinBy)
    output
}
