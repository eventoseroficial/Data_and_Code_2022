
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://github.com/IcaroBernardes/dubois/blob/master/man/figures/dubois.png" align="right" width = "160px"/> Palestra: Visualização de dados através do pacote dubois

Por: [Ícaro Bernardes](https://github.com/IcaroBernardes)

### Links úteis

-   [Slides em
    PDF](https://github.com/eventoseroficial/Data_and_code/blob/main/Icaro%20Bernardes%20dos%20Santos%20Coutinho/slides.pdf)
-   [Pacote dubois](https://github.com/IcaroBernardes/dubois)
-   [Código da função
    db_area](https://github.com/eventoseroficial/Data_and_code/blob/main/Icaro%20Bernardes%20dos%20Santos%20Coutinho/db_area.R)
-   [Banco de dados
    ‘managers’](https://github.com/eventoseroficial/Data_and_code/blob/main/Icaro%20Bernardes%20dos%20Santos%20Coutinho/gestores.Rds)

### Exemplo de uso do pacote

``` r
# Instala o pacote
# install.packages("devtools")
# devtools::install_github("IcaroBernardes/dubois")

# Carrega o pacote e outros auxiliares
library(dubois)

# Busca os dados sobre trabalhadores em cargos de comando contido no pacote
data <- dubois::managers

# Exporta os dados para que fiquem disponíveis neste repositório
readr::write_rds(data, file = "gestores.Rds")

# Faz pequenas manipulações nos dados
data <- data %>%
  dplyr::select(race, year, pct_bosses_total) %>%
  tidyr::pivot_wider(names_from = "race",
                     values_from = "pct_bosses_total")

# Define título, subtítulo e mensagem
title <- "PARTICIPATION IN MANAGERIAL POSITIONS BY RACE IN BRAZIL."
subtitle <- "INSPIRED BY: W.E.B. DU BOIS | DATA FROM: IBGE | GRAPHIC BY: ICARO BERNARDES"
message <- "IN THE SERIES, USUALLY WHITES OCCUPY SLIGHTLY LESS GENERAL WORK POSITIONS. HOWEVER WHITES OCCUPY WAY MORE MANAGERIAL POSITIONS THAN BLACKS"

# Faz uso da função. A figura é salva no working directory
dubois::db_area(data = data, order = "year", cat1 = "black", cat2 = "white",
                limits = c(-3,4), filename = "managers.png",
                title = title,
                subtitle = subtitle,
                message = message)
```

![](managers.png)

### Resumo

W.E.B. Du Bois, sociólogo americano e gênio do *dataviz* produziu
gráficos vanguardistas em sua exposição na Feira de Paris de 1900. Esse
trabalho inspirou a comunidade de visualização de dados a reproduzir os
trabalhos dele com elementos contemporâneos. O pacote
[dubois](https://github.com/IcaroBernardes/dubois) criado por Ícaro
Bernardes é um dos produtos dessa comunidade. O pacote está em
desenvolvimento, mas já contém uma função, **db_area**, a qual permite
fazer um gráfico de área com porcentagens de duas categorias. Esse
pacote busca facilitar o uso do estilo de Du Bois para usuários não
muito familiarizados com ggplot2, porém usuários experientes podem ir
além ao explorar as funções e customizar ainda mais os gráficos. O
pacote também deve tornar disponíveis, em inglês, recortes de bancos de
dados do IBGE com foco em estatísticas sobre a desigualdade racial no
Brasil. As futuras adições ao pacote devem ser baseadas em gráficos da
[#DuBoisChallenge2022](https://github.com/IcaroBernardes/webdubois)
