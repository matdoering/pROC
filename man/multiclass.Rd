\encoding{UTF-8}
\name{multiclass.roc}
\alias{multiclass.roc}
\alias{multiclass.roc.default}
\alias{multiclass.roc.formula}
\title{
 Multi-class AUC
}
\description{
  This function builds builds multiple ROC curve to compute the
  multi-class AUC as defined by Hand and Till.
}
\usage{
multiclass.roc(...)
\S3method{multiclass.roc}{formula}(formula, data, ...)
\S3method{multiclass.roc}{default}(response, predictor,
levels=base::levels(as.factor(response)), 
percent=FALSE, direction = ">", ...)

}

\arguments{
  \item{response}{a factor, numeric or character vector of
    responses, typically encoded with 0 (controls) and 1 (cases), as in
    \code{\link{roc}}.
  }
  \item{predictor}{either a numeric vector, containing the value of each
    observation, as in \code{\link{roc}}, or, a matrix giving the decision value
    (e.g. probability) for each class.
  }
  \item{formula}{a formula of the type \code{response~predictor}.}
  \item{data}{a matrix or data.frame containing the variables in the
    formula. See \code{\link{model.frame}} for more details.}
  \item{levels}{the value of the response for controls and cases
    respectively. In contrast with \code{levels} argument to
    \code{\link{roc}}, all the levels are used and
    \link[=combn]{combined} to compute the multiclass AUC.
  }
  \item{percent}{if the sensitivities, specificities and AUC must be
    given in percent (\code{TRUE}) or in fraction (\code{FALSE}, default).
  }
  \item{direction}{in which direction to make the comparison?
    \dQuote{>} (default): if the predictor values for the control group are
    higher than the values of the case group (controls > t >= cases).
    \dQuote{<}: if the predictor values for the control group are lower
    or equal than the values of the case group (controls < t <= cases).
    Since setting the parameter to \dQuote{auto} would lead to inconsistent
    AUC values, a setting of \dQuote{auto} is automatically adjusted to
    the default setting.
  }
  \item{...}{further arguments passed to \code{\link{roc}}.
  }
}
\details{
This function performs multiclass AUC as defined by Hand and Till
(2001). A multiclass AUC is a mean of \code{\link{auc}} and cannot be
plotted.

This function has been much less tested than the rest of the package and
is more subject to bugs. Please report them if you find one. Confidence
intervals and comparison tests are not implemented yet.
}

\value{
  If \code{predictor} is a vector, a list of class \dQuote{multiclass.roc} with the following fields: 
  \item{auc}{if called with \code{auc=TRUE}, a numeric of class \dQuote{auc} as
    defined in \code{\link{auc}}. Note that this is not the standard AUC
    but the multi-class AUC as defined by Hand and Till.
  }
  \item{ci}{if called with \code{ci=TRUE}, a numeric of class \dQuote{ci} as
    defined in \code{\link{ci}}.
  }
  \item{response}{the response vector as passed in argument. If
    \code{NA} values were removed, a \code{na.action} attribute similar
    to \code{\link{na.omit}} stores the row numbers.
  }
  \item{predictor}{the predictor vector as passed in argument. If
    \code{NA} values were removed, a \code{na.action} attribute similar
    to \code{\link{na.omit}} stores the row numbers.
  }
  \item{levels}{the levels of the response as defined in argument.}
  \item{percent}{if the sensitivities, specificities and AUC are
    reported in percent, as defined in argument.
  }
  \item{call}{how the function was called. See \code{\link{match.call}} for
    more details.
  }
  If \code{predictor} is a matrix, a numeric giving the overall AUC. The attribute
  \code{pair_AUCs} is a vector indicating the pairwise AUCs, A(i,j), for individual pairs of classes (i,j).
}

\section{Warnings}{
  If \code{response} is an ordered factor and one of the levels
  specified in \code{levels} is missing, a warning is issued and the
  level is ignored.
}

\references{
  David J. Hand and Robert J. Till (2001). A Simple Generalisation of
  the Area Under the ROC Curve for Multiple Class Classification
  Problems. \emph{Machine Learning} \bold{45}(2), p. 171--186. DOI:
  \href{http://dx.doi.org/10.1023/A:1010920819831}{10.1023/A:1010920819831}.
}

\seealso{
 \code{\link{auc}}
}

\examples{
####
# Examples for a univariate decision value
####
data(aSAH)

# Basic example
multiclass.roc(aSAH$gos6, aSAH$s100b)
# Produces an innocuous warning because one level has no observation

# Select only 3 of the aSAH$gos6 levels:
multiclass.roc(aSAH$gos6, aSAH$s100b, levels=c(3, 4, 5))

# Give the result in percent
multiclass.roc(aSAH$gos6, aSAH$s100b, percent=TRUE)

####
# Examples for multivariate decision values (e.g. class probabilities)
####
n <- c(100, 80, 150)
responses <- factor(c(rep("X1", n[1]), rep("X2", n[2]), rep("X3", n[3])))
# construct prediction matrix: one column per class
set.seed(42)

# Perfect separation
preds <- lapply(n, function(x) runif(x, 0.8, 1))
predictor <- as.matrix(data.frame("X1" = c(preds[[1]], runif(n[2] + n[3], 0, 0.3)),
                                  "X2" = c(runif(n[1], 0.1, 0.4), preds[[2]], runif(n[3], 0, 0.2)),
                                  "X3" = c(runif(n[1] + n[2], 0, 0.5), preds[[3]])))
multiclass.roc(responses, predictor)

# Imperfect separation

preds <- lapply(n, function(x) runif(x, 0.4, 0.6))
predictor <- as.matrix(data.frame(
                "X1" = c(preds[[1]], runif(n[2] + n[3], 0, 0.7)),
                "X2" = c(runif(n[1], 0.1, 0.4), preds[[2]], runif(n[3], 0.2, 0.8)),
                "X3" = c(runif(n[1] + n[2], 0.3, 0.7), preds[[3]])
             ))
multiclass.roc(responses, predictor)
multiclass.roc(responses, predictor, direction = ">")

# AUC of random classifier

preds <- lapply(n, function(x) runif(x, 0, 1))
predictor <- as.matrix(data.frame("X1" = c(preds[[1]], runif(n[2] + n[3], 0, 1)),
                                  "X2" = c(runif(n[1], 0, 1), preds[[2]], runif(n[3], 0, 1)),
                                  "X3" = c(runif(n[1] + n[2], 0, 1), preds[[3]])))
multiclass.roc(responses, predictor)

# AUC of worst-case classifier

preds <- lapply(n, function(x) rep(0, x))
predictor <- as.matrix(data.frame("X1" = c(preds[[1]], runif(n[2] + n[3], 0.1, 1)),
                                  "X2" = c(runif(n[1], 0, 1), preds[[2]], runif(n[3], 0.1, 1)),
                                  "X3" = c(runif(n[1] + n[2], 0.1, 1), preds[[3]])))
multiclass.roc(responses, predictor)
multiclass.roc(formula = X3 ~ X2, data = predictor)


# Minimum example for preventing the use of direction = "auto"
responses <- factor(c("X1", "X2", "X3"))
predictor <- data.frame("X1" = c(0.9, 0.0, 0.1),
                                  "X2" = c(0.05, 0.1, 0.7),
                                  "X3" = c(0.05, 0.9, 0.2))
multiclass.roc(responses, predictor)
multiclass.roc(responses, predictor, percent=TRUE)
# Limit set of levels
multiclass.roc(responses, predictor, levels = c("X1", "X2"))
# Use with formula
data <- cbind(predictor, "response" = responses)
multiclass.roc(response ~ X1+X3, data)

}

\keyword{univar}
\keyword{nonparametric}
\keyword{utilities}
\keyword{roc}
