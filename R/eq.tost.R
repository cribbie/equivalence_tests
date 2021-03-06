#' Robust and Non-Robust Variants of the Two Independent Groups Equivalence Test using the two one-sided tests (TOST) methodology. 
#' 
#' This R function allows for the computation of the original Schuirmann TOST for the equivalence of two 
#' independent groups, the modified Schuirmann-Welch test (which does not require the variances to be equal), 
#' or the Schuirmann-Yuen test (if normality cannot be assumed), depending on the arguments specified. The original Schuirmann assumes 
#' equal variances and normality. The Schuirmann-Welch assumes normality but not equal variances. The Schuirmann-Yuen accounts for 
#' unequal variances and nonnormality using trimmed means and Winsorized variances.
#' @aliases eq.tost
#' 
#' x, y, ei, varequiv = FALSE, normality = FALSE, tr = 0.2, alpha = 0.05,  na.rm = TRUE, print = TRUE, ...
#' 
#' @param x a numeric vector for first sample
#' @param y a numeric vector for the second sample
#' @param ei numeric value defining the size (half-width) of the symmetric (around 0) equivalance interval
#' @param varequal logical; If true, equal variances are assumed. Only applicable when tr == 0
#' @param normality logical; If true, normality of x and y are assumed. 
#' @param tr proportion of data to trim from each tail of each distribution (i.e., symmetric trimming). When \code{tr == 0}, the standard Schuirmann test
#'  or Schuirmann-Welch is performed
#' @param alpha the maximum allowable Type I error rate
#' @param print whether or not to print a graphic of the results
#' @param ... additional arguments to be passed
#' 
#' @return returns a \code{list} 
#' 
#' @author Rob Cribbie \email{cribbie@@yorku.ca}
#' @export eq.tost
#' @references 
#' 
#' Schuirmann, D. J. (1987). A comparison of the two one-sided tests procedure and the power approach for assessing the equivalence of average bioavailability. \emph{Journal of pharmacokinetics and biopharmaceutics, 15(6)}, 657-680.
#' van Wieringen, K. & Cribbie, R. A. (2014). Robust normative comparison tests for evaluating clinical significance. \emph{British Journal of Mathematical and Statistical Psychology, 67}, 213-230.
#' Gruman, J., Cribbie, R. A., & Arpin-Cribbie, C. A. (2007). The effects of heteroscedasticity on tests of equivalence. \emph{Journal of Modern Applied Statistical Methods, 6}, 133-140. 
# 
#' @examples
#' \dontrun{
#' 
#' x <- rnorm(100, 1)
#' y <- rnorm(100, 1)

#' # Original Schuirman TOST
#' eq.tost(x, y, ei=0.5, alpha = 0.05, varequiv=FALSE, normality=FALSE)

#' # Schuirmann-Welch
#' eq.tost(x, y, ei=0.5, alpha = 0.05, varequiv=FALSE, normality=TRUE)

#' # Schuirmann-Yuen TOST (default)
#' eq.tost(x, y, ei=0.5, alpha = 0.05)

#' #' # Schuirmann-Yuen TOST (10% symmetric trimming)
#' eq.tost(x, y, ei=0.5, varequiv=FALSE, normality=FALSE, alpha = 0.05) 

#' }

eq.tost <- function(x, y, ei, varequiv = FALSE, 
    normality = FALSE, tr = 0.2, alpha = 0.05, na.rm = TRUE, 
    print = TRUE, ...) {
    if (na.rm) {
        x <- x[!is.na(x)]
        y <- y[!is.na(y)]
    }
    if (normality) {
        if (varequiv == FALSE) {
            denom <- sqrt((var(x)/length(x)) + (var(y)/length(y)))
            t1 <- (mean(x) - mean(y) - ei)/denom
            t2 <- (mean(x) - mean(y) + ei)/denom
            dft <- (((var(x)/length(x)) + (var(y)/length(y)))^2)/((var(x)^2/(length(x)^2 * 
                (length(x) - 1))) + (var(y)^2/(length(y)^2 * 
                (length(y) - 1))))
            probt1 <- pt(t1, dft, lower.tail = T)
            probt2 <- pt(t2, dft, lower.tail = F)
            ifelse(probt1 <= alpha & probt2 <= alpha, 
                decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval can be rejected", 
                decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval cannot be rejected")
            
            title <- "Schuirmann-Welch Test of the Equivalence of Two Independent Groups"
        }
        if (varequiv == TRUE) {
            denom <- sqrt(((((length(x) - 1) * sd(x)^2) + 
                ((length(y) - 1) * sd(y)^2))/(length(x) + 
                length(y) - 2)) * (1/length(x) + 
                1/length(y)))
            t1 <- (mean(x) - mean(y) - ei)/denom
            t2 <- (mean(x) - mean(y) + ei)/denom
            dft <- length(x) + length(y) - 2
            probt1 <- pt(t1, dft, lower.tail = T)
            probt2 <- pt(t2, dft, lower.tail = F)
            ifelse(probt1 <= alpha & probt2 <= alpha, 
                decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval can be rejected", 
                decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval cannot be rejected")
            
            title <- "Schuirmann's Test of the Equivalence of Two Independent Groups"
        }
        
    }
    if (normality == FALSE) {
        h1 <- length(x) - 2 * floor(tr * length(x))
        h2 <- length(y) - 2 * floor(tr * length(y))
        print("Winsorized variances are computed.")
        q1 <- (length(x) - 1) * winvar(x, tr)/(h1 * 
            (h1 - 1))
        q2 <- (length(y) - 1) * winvar(y, tr)/(h2 * 
            (h2 - 1))
        dft <- (q1 + q2)^2/((q1^2/(h1 - 1)) + (q2^2/(h2 - 
            1)))
        crit <- qt(1 - alpha/2, dft)
        dif1 <- mean(x, tr) - mean(y, tr) - ei
        dif2 <- mean(x, tr) - mean(y, tr) + ei
        t1 <- dif1/sqrt(q1 + q2)
        t2 <- dif2/sqrt(q1 + q2)
        probt1 <- pt(t1, dft)
        probt2 <- 1 - pt(t2, dft)
        ifelse(probt1 <= alpha & probt2 <= alpha, 
            decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval can be rejected", 
            decis <- "The null hypothesis that the difference between the means exceeds the equivalence interval cannot be rejected")
        title <- "Schuirmann-Yuen Test of the Equivalence of Two Independent Groups"
    }
    
    means <- c(mean(x), mean(y))
    names(means) <- c("Mean Grp 1", "Mean Grp 2")
    trimmeans <- c(mean(x, tr), mean(y, tr))
    names(trimmeans) <- c("Trimmed Mean Grp 1", 
        "Trimmed Mean Grp 2")
    sds <- c(sd(x), sd(y))
    names(sds) <- c("SD Grp 1", "SD Grp 2")
    ei <- (c(ei))
    names(ei) <- c("equivalence interval")
    tstats <- c(t1, t2)
    names(tstats) <- c("t1", "t2")
    dfs <- c(dft, dft)
    names(dfs) <- c("dft1", "dft2")
    pvals <- c(probt1, probt2)
    names(pvals) <- c("p_t1", "p_t2")
    res <- list(title, means = means, trimmeans = trimmeans, 
        sds = sds, ei = ei, tstats = tstats, 
        dfs = dfs, pvals = pvals, decis = decis)
    return(res)
}

#' @rdname eq.tost
#' @param x object of class \code{eq.tost}
#' @export
print.eq.tost <- function(x, ...) {
    cat("----", x$title, "----", "\n\n")
    cat("Means:", x$means, "\n")
    cat("SDs:", x$sds, "\n")
    cat("Trimmed Means:", x$trimmeans, "\n")
    cat("The equivalence interval was ", x$ei, 
        "in unstandardized metric.")
    cat("Test statistics: ", x$tstats, "\n")
    cat("Degrees of freedom: ", x$dfs, "\n")
    cat("p-value = ", x$p.vals, "\n")
    cat("Decision:", x$decis, "\n")
} 
