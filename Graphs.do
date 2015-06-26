
*** OPEN DATA SET

use "/Users/jcmunozmora/Documents/data/PANEL CEDE - 07-14/PANELES/CONFLICTO Y VIOLENCIA/CONFLICTO Y VIOLENCIA/PANEL CONFLICTO Y VIOLENCIA.dta", clear

global graph_app "/Users/jcmunozmora/Documents/Tesis/Chap 3 - Back to Reality/Presentations/ULB-Sep2014/Figures"

*** Only municipalities around DZ
keep if codmpio==41001|codmpio==41078|codmpio==41206|codmpio==41615|codmpio==41799|codmpio==41020|codmpio==25120|codmpio==41016|codmpio==41132|codmpio==41524|codmpio==73024|codmpio==73236|codmpio==73555|codmpio==41306|codmpio==41349|codmpio==41132

*** Only years I care
keep if ano>1997 & ano<2007

**** Dummy neighors
gen d_neig=(codmpio==41001|codmpio==41078|codmpio==41206|codmpio==41615|codmpio==41799|codmpio==41020)

rename ano year

** MEAN TEST
gen dif_homi1=.
gen sig_homi1=.

forvalue i=1998/2006 {
ttest tpobc_FARC if year==`i', by(d_neig)  
replace sig_homi1=r(t)  if year==`i'
replace dif_homi1=r(mu_1)-r(mu_2) if year==`i'
}

collapse (mean) dif_* sig_*  tpobc_FARC, by(year d_neig)


twoway (line tpobc_FARC year if d_neig==1 , sort lcolor(black) lwidth( medthick )) (line  tpobc_FARC year if d_neig==0 , sort clpattern(shortdash) lcolor(gs5) lwidth( medthick )) (bar sig_homi1 year if d_neig==1 , yaxis(2) barw(.15)  color(gs10))  , xlabel(1998(2)2006, labsize(*.7))  ysca(axis(1) r(-0.5 5)) ysca(axis(2) r(-10 100))  ylabel(0, axis(2) labsize(*.7))  ylabel(0(1)5, axis(1) labsize(*.7))  yline(-1.96, lpattern(dot) lcolor(black) lwidth( medium ) axis(2)) yline(1.96, lpattern(dot) lcolor(black) lwidth( medium ) axis(2) ) graphregion(color(white)) xtitle("") ytitle("") ytitle("",axis(2)) legend( col(2) size(*.7) order(1 "(a) Villages at ZD Border" 2 "(b) Villages in the Neighborhood" 3 "(a) - (b) [t-stat]"    )  )

graph export "$graph_app/civil_population.png", replace width(4147) height(2250)

