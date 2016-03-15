#' Pairwise unstandardized
#'
#' Equivalence interval is in unstandardized metric. If at least one pairwise mean difference is found not statistically significant (in equivalence), then the whole test fails to reject the null hypothesis.
#' @param data dataset in data.frame format
#' @param repeated a character vector containing the names of the repeated measures variables
#' @param ei the equivalence interval in unstandardized metric
#' @param alpha the alpha level for significance testing
#' @references Mara, C. A., & Cribbie, R. A. (2012). Paired-samples tests of equivalence. \emph{Communications in Statistics-Simulation and Computation}, 41(10), 1928-1943.
#' @references Wellek, S. (2010). \emph{Testing statistical hypotheses of equivalence and noninferiority}. CRC Press.
#' @export pw.std
#' @examples
pw.unstd <- function(data, repeated, ei, alpha = 0.05) {
    if (class(data) != "data.frame") 
        stop("Data input is not a dataframe.")
    dat <- data[, repeated]
    n <- nrow(dat)
    k <- length(repeated)
    sigma <- cov(dat)
    means <- as.matrix(apply(dat, 2, mean))
    allcontrasts <- getContrast(k, type = "allPW")
    
    
    mean_diff_names <- pairwise_meanDiffs(means, 
        allcontrasts)
    sqrt_varcovar <- pairwise_sd(allcontrasts, 
        sigma)  #sd of diffs 
    for (i in 1:length(mean_diff_names)) {
        leftside <- abs((mean_diff_names))
        rightside <- ei - (sqrt_varcovar/sqrt(n)) * 
            qt(df = n - 1, p = (1 - alpha))
    }
    
    # decision leftside<-unlist(leftside)
    find_nonequiv_res <- which((ifelse(leftside <= 
        rightside, check_equiv <- 1, check_equiv <- 0)) == 
        0)
    ifelse(length(find_nonequiv_res) > 0, decis <- "No evidence for equivalence", 
        decis <- "evidence for equivalence")  #if at least one pairwise test is signif, omnibus is not signif. 
    res <- list(repeatedMeasures = paste(k, "repeated measures"), 
        means = t(means), ei = paste(ei, "in unstandardized metric"), 
        Decision = decis)
    print(res)
    return(res)
} 