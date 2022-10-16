

clear

cd "C:\Users\ACER\OneDrive\QEM\Tercer semestre\Clases\Labor\Set6\cepr_march_2015"

use cepr_march_2015, clear

preserve
drop if female==0
generate salario=hrwage*hours
collapse(median) salario, by(age)
*summ salario
*scalar mean_male=r(mean)
*generate earnings_salario=salario/mean_male
save "salario.dta", replace
restore

preserve
drop if female==0
collapse(sum) empl unem, by(age) 
generate participation=empl/(empl+unem)
save "participation.dta", replace
restore

preserve
drop if female==0
summ rincp_ern
scalar mean_male=r(mean)
collapse(median) rincp_ern, by(age) 
generate earnings_profile1=rincp_ern/mean_male
save "median.dta", replace
restore

use participation,clear
merge 1:1 age using median.dta
generate earnings_prof=earnings_profile1*participation
drop _merge
save "merged.dta", replace
twoway fpfit earnings_prof age if age>19
graph export "PolynomialFitting.pdf", replace

export excel using "C:\Users\ACER\OneDrive\QEM\Tercer semestre\Clases\Labor\Set6\merged.xls", firstrow(variables)


use participation,clear
merge 1:1 age using salario.dta
generate earnings_prof=salario*participation
summ earnings_prof
scalar mean_male=r(mean)
generate earnings_prof_salario=earnings_prof/mean_male
drop _merge
save "merged.dta", replace
twoway fpfit earnings_prof_salario age if age>19
fp <age>: regress earnings_prof_salario <age>
predict byhand
twoway fpfit earnings_prof_salario age || mspline byhand age, sort
graph export "PolynomialFitting.pdf", replace



export excel using "C:\Users\ACER\OneDrive\QEM\Tercer semestre\Clases\Labor\Set6\merged_salario.xls", firstrow(variables)




*preserve
*%drop if female==0
*summ hrearn
*scalar mean_male2=r(hrearn)
*collapse(median) hrearn, by(age) 
*generate earnings_profile2=hrearn/mean_male
*save "median2.dta", replace
*restore

