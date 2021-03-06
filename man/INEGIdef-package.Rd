\name{CensosEco2014-package}
\alias{CensosEco2014-package}
\alias{CensosEco2014}
\encoding{UTF-8}
\docType{package}
\title{Soporte para registros administrativos}
\description{
Este paquete tiene la finalidad de ayudar a la dirección de registros administrativos, con varios procesos, con el fin de llevar las estadísticas de los registros administrativos
}
\details{
\tabular{ll}{
Package: \tab CensosEco2014\cr
Type: \tab Package\cr
Version: \tab 0.0.15\cr
Date: \tab 2014-07-23\cr
License: \tab GPL (>= 3)\cr
}
Aquí se usan pocas funciones como es DefCap y Etapa01, otras en desarrollo.
}
\author{
José D. Loera <jose.loera@inegi.org.mx>
}
\references{Datos de registros administrativos}
\keyword{package}
\keyword{Registros}
\keyword{Procesos}
\keyword{Estadisticas}
\examples{
##Aquí vemos como usar la función DefCap, ejemplo general.
Capis<-c("P456","C682","M613","F629","X392")
DefCap(Capis)

data(DatPru)
DatCap
InfCap

##Cuando ya tenemos el tamaño de la muestra usamos la función así.
Etapa01(IDm=DatCap[,1], CausaD=DatCap[,2], n=InfCap$n)
}