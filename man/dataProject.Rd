% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataProject.R
\name{dataProject}
\alias{dataProject}
\title{Compute Reference Component features for clustering analysis}
\usage{
dataProject(
  rca.obj,
  method = "GlobalPanel",
  customPath = NULL,
  corMeth = "pearson",
  power = 4,
  scale = T
)
}
\arguments{
\item{rca.obj}{RCA object.}

\item{method}{Either "GlobalPanel"(default), "ColonEpiPanel", "MonacoPanel","ENCODEMousePanel","ENCODEHumanPanel","ZhangMouseBrainPanel","NovershternPanel" or "Custom"}

\item{customPath}{directory path (including filename) to any custom panel stored in RDS format. Only used if method == "Custom".}

\item{corMeth}{Any of the correlation measures supported by R, defaults to pearson}

\item{power}{power to raise up to for the RCA features before clustering, default is 4}

\item{scale}{True if the data should be scaled, False otherwise}
}
\value{
RCA object.
}
\description{
Compute Reference Component features for clustering analysis
}
