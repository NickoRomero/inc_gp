setwd("D:/Borrador Gasolina/Income_vs_GPrices")

#Retailers Database
df = read.csv2("SuperSociedades_G52.csv", header=T, sep=",")

#Gasoline Database
gp <- read.csv("D:/Borrador Gasolina/gasoline/gasoline.csv", header=T)
gp$date <- as.Date(gp$date) 
gp$address <- as.character(gp$address)

#Variables
  #Date
  gp$year <- gp$date
  gp$year <- substr(gp$year, 0, 4)
  
  library(data.table)
  
  #City Average Price by Product (Yearly)
  gp <- data.table(gp)
  gp[, ca_price := mean(price), by = .(city, year, product)]
  gp <- as.data.frame(gp)

df$cod_ciudad <- factor(df$cod_ciudad, labels = c("MEDELLIN", "ENVIGADO", "ITAGUI", "BARRANQUILLA", 
                                                  "BOGOTA D.C.", "CARTAGENA DE INDIAS", "MANIZALES", "CAJICA",
                                                  "FACATATIVA", "SUBACHOQUE", "ZIPAQUIRA", "NEIVA",
                                                  "SAN JOSE DE CUCUTA", "BUCARAMANGA", "BARRANCABERMEJA", "SINCELEJO",
                                                  "IBAGUE", "SANTIAGO DE CALI", "PALMIRA", "YUMBO", "YOPAL"))

names(df)[names(df)=="cod_ciudad"] <- "city"
names(df)[names(df)=="anio"] <- "year"

gp <- gp[c(4, 6, 10, 11)]

gp <- gp[ which(gp$city==c("MEDELLIN", "ENVIGADO", "ITAGUI", "BARRANQUILLA", 
                                     "BOGOTA D.C.", "CARTAGENA DE INDIAS", "MANIZALES", "CAJICA",
                                     "FACATATIVA", "SUBACHOQUE", "ZIPAQUIRA", "NEIVA",
                                     "SAN JOSE DE CUCUTA", "BUCARAMANGA", "BARRANCABERMEJA", "SINCELEJO",
                                     "IBAGUE", "SANTIAGO DE CALI", "PALMIRA", "YUMBO", "YOPAL")), ]


duplicated(gp) #Muestra el valor TRUE cuando hay una fila repetida
gp[!duplicated(gp), ] -> gp # ! deja sólo las filas únicas (una por repetición)

gp <- gp[which(gp$product!="GASOLINA EXTRA"), ] #Conserva sólo las observaciones que no contenga el producto Gasolina Extra
i_acpm <- gp[which(gp$product=="ACPM - DIESEL"), ] #Conserva sólo las observaciones que contengan el producto ACPM
i_gasoline <- gp[which(gp$product=="GASOLINA CORRIENTE"), ]

#Deflation
ipc <- read.csv2("ipc.csv", header=T)
names(ipc)[names(ipc)=="AÑO"] <- "year"

ipp <- read.csv2("ipp.csv", header=T)
names(ipp)[names(ipp)=="AÑO"] <- "year"

df <- merge.data.frame(df, ipp, by="year")
df <- merge.data.frame(df, ipc, by="year")

df$ing2_ipc2012 <- df$ing2/(df$IPC/100)
df$ing2_ipp2012 <- df$ing2/(df$IPP/100)

df$ing2_ipc2012 <- as.integer(df$ing2_ipc2012, digits = 10)
df$ing2_ipp2012 <- as.integer(df$ing2_ipp2012, digits = 10)

df$ing2_def <- df$ing2_def*100

#Control Variables
df$net_profit <- df$utilidad/df$activo
df$activo_def <- df$activo/(df$IPC/100) #Se deflactan los activos con IPC a 2012 y se crea la variable dummy
attach(df)                              #con el salario de 2012 ($566.700)
df$size[activo_def<283350] <- "micro"   #Se le quitan 3 cero, ya que todo está en miles.
df$size[activo_def<2833500 & activo_def>283350] <- "small"
df$size[activo_def>2833500 & activo_def<17001000] <- "medium"
df$size[activo_def>17001000] <- "big"
detach(df)

df$size <- factor(df$size)

rm(ipc, ipp, gp) #cleaning

#Merge
  i_acpm <- merge.data.frame(df, i_acpm, by=c("year", "city"))
  i_gasoline <- merge.data.frame(df, i_gasoline, by=c("year", "city"))

i_acpm <- i_acpm[ ,c(1, 2, 3, 8, 14, 15, 17, 18, 19, 20, 21, 24, 25, 26, 28, 30)]
i_gasoline <- i_gasoline[ ,c(1, 2, 3, 8, 14, 15, 17, 18, 19, 20, 21, 24, 25, 26, 28, 30)]

#Regressions
  
  #Gasoline
    gasoline1 <- lm(log(ing2) ~ log(ca_price) + size + net_profit, data = i_gasoline)
    summary(gasoline1)

    gasoline2 <- lm(log(ing2_def) ~ log(ca_price) + size + net_profit, data = i_gasoline)
    summary(gasoline2)
    
    gasoline3 <- lm(log(ing2_ipc2012) ~ log(ca_price) + size + net_profit, data = i_gasoline)
    summary(gasoline3)
    
    gasoline4 <- lm(log(ing2_ipp2012) ~ log(ca_price) + size + net_profit, data = i_gasoline)
    summary(gasoline4)
    
    gasoline5 <- lm(log(ing2) ~ log(ca_price) + size, data = i_gasoline)
    summary(gasoline5)
    
    gasoline6 <- lm(log(ing2_def) ~ log(ca_price) + size, data = i_gasoline)
    summary(gasoline6)
    
    gasoline7 <- lm(log(ing2_ipc2012) ~ log(ca_price) + size, data = i_gasoline)
    summary(gasoline7)
    
    gasoline8 <- lm(log(ing2_ipp2012) ~ log(ca_price) + size, data = i_gasoline)
    summary(gasoline8)
    
  #ACPM
    acpm1 <- lm(log(ing2) ~ log(ca_price) + size + net_profit, data = i_acpm)
    summary(acpm1)
    
    acpm2 <- lm(log(ing2_def) ~ log(ca_price) + size + net_profit, data = i_acpm)
    summary(acpm2)
    
    acpm3 <- lm(log(ing2_ipc2012) ~ log(ca_price) + size + net_profit, data = i_acpm)
    summary(acpm3)
    
    acpm4 <- lm(log(ing2_ipp2012) ~ log(ca_price) + size + net_profit, data = i_acpm)
    summary(acpm4)
    
    acpm5 <- lm(log(ing2) ~ log(ca_price) + size, data = i_acpm)
    summary(acpm5)
    
    acpm6 <- lm(log(ing2_def) ~ log(ca_price) + size, data = i_acpm)
    summary(acpm6)
    
    acpm7 <- lm(log(ing2_ipc2012) ~ log(ca_price) + size, data = i_acpm)
    summary(acpm7)
    
    acpm8 <- lm(log(ing2_ipp2012) ~ log(ca_price) + size, data = i_acpm)
    summary(acpm8)

#Output

library(stargazer)

stargazer(gasoline1, gasoline2, gasoline3, gasoline4, gasoline5, gasoline6, gasoline7, gasoline8, type="text", dep.var.labels=c("income",
                  "income deflated IPP05", "Income deflated IPC12", "Income deflated IPP12", "income", "income deflated IPP05", 
                  "Income deflated IPC12", "Income deflated IPP12"), covariate.labels=c("Gasoline Price", "Size: Medium", "Size: Small",
                  "Size: Micro", "Net Profit Ratio"), notes = "Standard Errors in parentheses.", no.space = T, notes.append = T, out="gasoline_ols.txt")

stargazer(acpm1, acpm2, acpm3, acpm4, acpm5, acpm6, acpm7, acpm8, type="text", dep.var.labels=c("income",
                  "income deflated IPP05", "Income deflated IPC12", "Income deflated IPP12", "income", "income deflated IPP05", 
                  "Income deflated IPC12", "Income deflated IPP12"), covariate.labels=c("acpm Price", "Size: Medium", "Size: Small",
                  "Size: Micro", "Net Profit Ratio"), notes = "Standard Errors in parentheses.", no.space = T, notes.append = T, out="acpm_ols.txt") 

stargazer(gasoline1, gasoline7, acpm1, acpm7, type="text", dep.var.labels=c("income", "Income deflated IPC12", "income", "Income deflated IPC12"), 
                  covariate.labels=c("Fuel Price", "Size: Medium", "Size: Small", "Size: Micro", "Net Profit Ratio"), 
                  notes = "Estimation (1) and (2) use gasoline price, (3) and (4) use ACPM price. Standard Errors in parentheses.", 
                  no.space = T, notes.append = T, out="fuel_ols.txt") 







