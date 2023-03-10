### Rotina para metodologia BM (block maxima) e para POT (peaks over threshold) ###

rm(list=ls(all=TRUE)) ### limpar mem?ria ###

### Pacotes utilizados para an?lise dos valores extremos ###
library(evd) ### fun??es para as distribui??es de valores extremos ###
library(extRemes) ### fun??es gerais para realizar an?lises de valores extremos ###
library(hydroGOF) ### fun??es de qualidade de ajuste ###

### Exemplo de pacotes para um uso espec?fico ###
library(evir) ### uma alternativa -> fun??es para teoria de valores extremos ###
library(revdbayes) ### fun??es para a an?lise bayesiana de modelos de valores extremos ###
library(fExtremes) ### modelagem de eventos extremos em Finan?as ###
library(SpatialExtremes) ### modelar extremos Espaciais ###
library(lmom) ### fun??es para o uso do m?todo de momentos-L ###
### entre outros pacotes auxiliares ###

############################# metodologia BM (block maxima) ############################# 
### carregar dataset ### 
dados=read.csv(file.choose(), header=TRUE, sep=";", dec=",")
dados
head(dados)
tail(dados)
attach(dados)

dados2=aggregate(var~ano+m?s, data=dados,max);dados2

Y1=dados2$var; Y1
length(Y1)
summary(Y1)
summary(dados2)

############################# Gr?fico da s?rie ############################# 
### transformando em serie temporal ###
dados3<- ts(Y1, start=1, end=15)
dados3
plot(Y1,type="l", ylab="N?mero de mortes", 
     xlab="Tempo", col="red", bty="l", 
     panel.first=grid())

### teste de Mann-Kendall ### 
require(trend)
mk.test(Y1) ### teste de tend?ncia ###

### teste de Ljung-Box ###
Box.test(Y1, type = c("Ljung-Box")) ### teste de independ?ncia ###

############################# Distribui??es #############################
### ajuste da distribui??o Gumbel ###
fit1 <- fevd(var, dados2, type="Gumbel", period="month")
fit1 
loc1=fit1$results$par[1]
scale1=fit1$results$par[2]

### ajuste da distirbui??o GEV ###
fit2 <- fevd(var, dados2, type ="GEV", period="month")
fit2
loc2=fit2$results$par[1]
scale2=fit2$results$par[2]
shape2=fit2$results$par[3]

### diagnostico geral ###
plot(fit1, main="") 
plot(fit2, main="") 
rl1=return.level(fit1,return.period=c(seq(2,10,1)),time.units="months",
                 period="months",do.ci=TRUE)
rl1

rl2=return.level(fit2,return.period=c(seq(2,10,1)),time.units="months",
                 period="months",do.ci=TRUE)
rl2

### teste da raz?o de verossimilhan?a ###
lr.test(fit1, fit2) ### analisar o p-valor para a escolha da distribui??o (GVE ou Gumbel) ###
### para avaliar qual distribui??o de valores extremos se ajustam melhor aos dados ###

### Teste Kolmogorov-Smirnov -> avaliar a qualidade do ajuste ###
ks.test(Y1,"pgumbel", loc1, scale1) ### Gumbel ###
ks.test(Y1,"pgev", loc2, scale2, shape2) ### GVE ###

### Gr?fico de diagnostico ###
plot(fit1, "probprob", main="") ### Gr?fico percentil-percentil (PP) ### 
plot(fit1, "qq2", xlab="Empirical Quantiles") ### gr?fico quantil-quantil (QQ) ###
plot(fit1, "density", main="") ### densidade dos dados vs modelo ajustado ###

### diagnostico pelos gr?ficos de N?vel de retorno ###
plot(fit1, "rl", main="Gumbel") ### Gumbel ###
plot(fit2, "rl", main="GVE") ### GVE ###

############################# Probabilidades #############################
nivel<-c(1000,2000,3000,4000,5000) ### niveis de interesse ###
round(pevd(nivel,loc1,scale1,type="Gumbel",lower.tail=FALSE)*100,2) ### Gumbel ###
round(pevd(nivel,loc2,scale2,shape2,type="GEV",lower.tail=FALSE)*100,2) ### GVE ###

############################# Tempo de retorno #############################

tr<-c(seq(2,10,1)) ### Tempos de retorno armazenados no vetor x ###
p<-1-(1/tr)  ### Probabilidades para cada um dos tempos de retorno do vetor x ###

ret1=qgumbel(p,loc1, scale1) ### niveis de retorno pela Gumbel ###
ret1
ret2=qgev(p,loc2, scale2, shape2) ### niveis de retorno pela GVE ###
ret2

############################# gr?ficos do nivel de retorno #############################
par(mfrow=c(1,1))
### Gumbel ###
plot(tr,ret1,type ='b', pch=19, col = "red", lwd=2, xaxt="n", main="Distribui??o", 
     xlab='Time of return (month)', ylab='Return level', ylim=c(1000,5000), cex.lab=1.5, 
     cex.axis=1.2, cex.main=1.5,las=2, panel.first=grid(),bty="L")
lines(tr, rl1[,1], type ='b', lty=2, pch=19, col = 2, lwd=2)
lines(tr, rl1[,3], type ='b', lty=2, pch=19, col = 2, lwd=2)
axis(1, at=c(seq(2,10,1)),cex.axis=1.5)
### GVE ###
lines(tr, ret2, type ='b', lty=2, pch=19, col = 1, lwd=2)
lines(tr, rl2[,1], type ='b', lty=2, pch=19, col = 1, lwd=2)
lines(tr, rl2[,3], type ='b', lty=2, pch=19, col = 1, lwd=2)
### legenda ###
legend("topright", legend=c("Gumbel","GVE"), lty = c(1,1), lwd = c(2,2), 
       pch=c(16,16),col=c("red","black"), bty="n")

############################# metodologia POT (peaks over threshold) ############################# 
### carregar dataset ### 
dados=read.csv(file.choose(), header=TRUE, sep=";", dec=",")
dados
head(dados)
tail(dados)
attach(dados)

Y1=dados$var; Y1
length(Y1)
############################# Gr?fico da s?rie ############################# 
### transformando em serie temporal ###
dados2 <- ts(Y1)
dados2
plot(dados2,type="l", ylab="N?mero de mortes", 
     xlab="Tempo", col="red", bty="l", 
     panel.first=grid())

### gr?fico da media dos excedentes ###
mrlplot(Y1, main="Mean Residual Life Plot", 
        col=c("blue", "black", "blue"))

### gr?fico para escolha do threshold ###
par(mfrow=c(1,2))
tlim = c(0,3000)
tcplot(Y1,tlim,std.err= FALSE) ### threshold choice plot ###
ts<-2800 ### threshold selecionado ###

dadosmod<-Y1[Y1>ts] ### m?ximos acima de um limiar ###
length(dadosmod)

############################# Mesma estrutura da primeira metodologia  ############################# 
### teste de Ljung-Box 
### teste de Mann-Kendall 
### ajuste das distribui??es
### teste da raz?o de verossimilhan?a 
### teste Kolmogorov-Smirnov
### probabilidades 
### tempo de retorno

#####################################################################################
###    COLES, Stuart. An Introduction to Statistical Modeling of Extreme Values.  ### 
###            Springer series in statistics, v. 1, no 1, p. 1-219, 2001.         ### 
###            Dispon?vel em: https://doi.org/10.1007/978-1-4471-3675-0.          ### 
#####################################################################################

