***** trabalho econometria *****

***** importando a base de dados *****

import excel "C:\Users\rebec\OneDrive\Mestrado\Disciplinas\2023.2\Econometria\Trabalho final\base de dados.xlsx", sheet("Worksheet") firstrow

* mostrando ao stata os anos da base *

xtset cod ano, yearly

*** Examinando o banco de dados *****
describe
list in 1/5

**** Análise descritiva dos dados *************
summ analf gini dens idhm ensino_medio renda
summ analf gini dens idhm ensino_medio renda, detail

* Listando os 5 melhores e piores municípios em relação ao IDHM *

sort idhm
list mun idhm in 1/5 // Os 5 municípios com os piores IDHM 
list mun idhm in -5/l  // Os 5 municípios com melhores IDHM 


* a taxa de analfabetismo e a renda possuem uma relacao nao linear *
* criando a variavel renda per capita ao quadrado *

gen renda2 = renda^2


***** estimando através do modelo pooled *****
* modelo MQO *

reg analf gini dens idhm ensino_medio renda renda2

* Teste de Normalidade dos resíduos *
predict uhat1, resid
histogram uhat1, normal

* Análise gráfica dos resíduos *
gen lnanalf=ln(analf)
scatter uhat1 lnanalf
scatter uhat1 lnanalf, yline(0)

* criando uma variavel logaritmica *

gen lngini=ln(gini)

* testando o modelo com a nova variavel *

reg analf lngini dens idhm ensino_medio renda renda2


***** estimando através do modelo de efeitos fixos *****

xtreg analf gini dens idhm ensino_medio renda renda2, fe


***** estimando através do modelo de efeitos aleatórios *****

xtreg analf gini dens idhm ensino_medio renda renda2, re



***** utilizando o teste de Hausman para escolher qual modelo é mais adequado *****

qui xtreg analf gini dens idhm ensino_medio renda renda2, fe
estimates store fe

qui xtreg analf gini dens idhm ensino_medio renda renda2, re
estimates store re

hausman fe re


***** utilizando o teste de Breush-Pagan *****
* reestima-se o modelo de EA *
xtreg analf gini dens idhm ensino_medio renda renda2, re
xttest0


***** análise gráfica com duas variáveis ****
twoway fpfitci analf renda || scatter analf renda
twoway (scatter analf renda, mcolor(black)) (scatter analf renda if mun=="Maceió (AL)", mlabel(mun)),graphregion(color(white)) plotregion(color(white))


**** Criando gráfico box-plot para as variáveis *********
graph box analf ensino_medio 
gen lnrenda=ln(renda)
graph box analf gini dens idhm ensino_medio lnrenda