\encoding{UTF-8}
\name{ggroc.roc}
\alias{ggroc.roc}
\alias{ggroc.list}
\alias{ggroc}

\title{
  Plot a ROC curve with ggplot2
}
\description{
  This function plots a ROC curve with ggplot2.
}
\usage{
\S3method{ggroc}{roc}(data, legacy.axes = FALSE, ...)
\S3method{ggroc}{list}(data, aes = c("colour", "alpha", "linetype", "size", "group"),
      legacy.axes = FALSE, ...)
}
		   
\arguments{
  \item{data}{a roc object from the \link{roc} function, or a list of roc objects.
  }
  \item{aes}{the name of the aesthetics for \code{\link{geom_line}} to map to the different ROC curves supplied. Use \dQuote{group} if
  you want the curves to appear with the same aestetic, for instance if you are faceting instead.}
  \item{legacy.axes}{a logical indicating if the specificity axis (x
    axis) must be plotted as as decreasing \dQuote{specificity}
    (\code{FALSE}, the default) or increasing \dQuote{1 - specificity}
    (\code{TRUE}) as in most legacy software.}
  \item{...}{additional aesthetics for \code{\link{geom_line}} to set: \code{alpha}, \code{colour}, \code{linetype} and \code{size}.}
}

\details{
  This function initializes a ggplot object from a ROC curve (or multiple if a list is passed). It returns the ggplot with a line layer on it. You can print it directly or add your own layers and theme elements.
  
  This function is experimental and may change in the future. Please \href{https://github.com/xrobin/pROC/issues}{report bugs and feedback on the GitHub issue tracker}.
}


\seealso{
\code{\link{roc}}, \code{\link{plot.roc}}, \code{\link{ggplot2}}
}
\examples{
# Create a basic roc object
data(aSAH)
rocobj <- roc(aSAH$outcome, aSAH$s100b)
rocobj2 <- roc(aSAH$outcome, aSAH$wfns)

library(ggplot2)
g <- ggroc(rocobj)
g
# with additional aesthetics:
ggroc(rocobj, alpha = 0.5, colour = "red", linetype = 2, size = 2)

# You can then your own theme, etc.
g + theme_minimal() + ggtitle("My ROC curve")

# Multiple curves:
g2 <- ggroc(list(s100b=rocobj, wfns=rocobj2, ndka=roc(aSAH$outcome, aSAH$ndka)))
g2

# This is equivalent to using roc.formula:
roc.list <- roc(outcome ~ s100b + ndka + wfns, data = aSAH)
g.list <- ggroc(roc.list)
g.list

# with additional aesthetics:
g3 <- ggroc(roc.list, linetype=2)
g3
g4 <- ggroc(roc.list, aes="linetype", color="red")
g4

# OR faceting
g.list + facet_grid(.~name) + theme(legend.position="none")
# To have all the curves of the same color, use aes="group":
g.group <- ggroc(roc.list, aes="group")
g.group
g.group + facet_grid(.~name)

}
