% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/equiv_drs.R
\name{equiv_drs}
\alias{equiv_drs}
\alias{print.equiv_drs}
\title{Dependent Correlations}
\usage{
equiv_drs(dat, ei, n = NULL, alpha = 0.05)

\method{print}{equiv_drs}(x, ...)
}
\arguments{
\item{dat}{an N x 3 matrix or data.frame containing raw data used to compute the 
correlation matrix between variables. The input may also be a 1 x 3 vector of correlations
(r12, r13, and r23, respectively) and requires a sample size input (N)}

\item{ei}{equivalence interval}

\item{n}{sample size when dat input is a vector of correlations}

\item{alpha}{desired alpha level}

\item{x}{object of class \code{equiv_drs}}

\item{...}{additional arguments}
}
\value{
returns a list containing the p-value, confidence interval, and statistical decision
}
\description{
Tests the equivalence of the correlations r12 and r13 (variable 1 is overlapping variable) in
a three variable correlation matrix. Standard errors based on William's modification 
to Hotellings test comparing dependent overlapping correlations.
}
\examples{
\dontrun{
#raw data
set.seed(1234)
dat <- cbind(rnorm(100), rnorm(100), rnorm(100)) 
equiv_drs(dat, ei = .2)

#correlations input
r12 <- cor(dat)[2,1]
r13 <- cor(dat)[3,1]
r23 <- cor(dat)[3,2]
equiv_drs(c(r12, r13, r23), ei = .2, n = nrow(dat))
}
}
\author{
Rob Cribbie \email{cribbie@yorku.ca} and 
  Alyssa Counsell \email{counsela@yorku.ca}
}

