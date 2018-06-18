** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\Sync\OneDrive - The University of the West Indies\repo_caribdata\repo_stata\"
log using equiplot_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      equiplot_001.do
**  project:
**  author:       HAMBLETON \ 11-MAR-2017
**  task:         Physical activity in the Caribbean by subjective and objective measures


** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200


** Primary dataset created using --> d100_join_mr_datasets.do
use "equiplot_001", clear
label data "Inactivity prevalence in the Caribbean (source: CHowitt, 2017)"
** Re-label the countries to allow sensible xy-axis aspect ratio
** UN 3-digit codes --> http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3, 
label define country 	1 "abw"			/// aruba
						2 "vgb"			/// bvi
						3 "brb"			/// barbados
						4 "bmu"			/// bermuda
						5 "cym"			/// cayman islands
						6 "dma"			/// dominica
						7 "dom"			/// dominican republic
						8 "grd"			/// grenada
						9 "jam"			/// jamaica
						10 "kna"		/// st kitts
						11 "lca"		/// st lucia
						12 "vct"		/// st vincent
						13 "sur"		/// suriname
						14 "tto"		/// trinidad
						, modify

label define country_long 	1 "aruba"			/// aruba
						2 "bvi"			/// bvi
						3 "barbados"			/// barbados
						4 "bermuda"			/// bermuda
						5 "cayman"			/// cayman islands
						6 "dominica"			/// dominica
						7 "dom rep"			/// dominican republic
						8 "grenada"			/// grenada
						9 "jamaica"			/// jamaica
						10 "st.kitts"		/// st kitts
						11 "st.lucia"		/// st lucia
						12 "st.vincent"		/// st vincent
						13 "suriname"		/// suriname
						14 "trinidad"		/// trinidad
						, modify

label values country country_long


** Order countries for women / men separately
** Re-assign country codes to match ordering

gen country2 = .
forval x = 1(1)2 {
	gsort sex -prev2
	gen country2_`x' = _n if sex==`x'
	decode country if sex==`x', gen(temp`x')
	replace country2 = country2_`x' if country2_`x'<.
	labmask country2_`x' if sex==`x', values(temp`x')
	///drop temp`x' country_string`x' country2_`x'
	}
replace country2 = country2 + 1 if sex==2
gen temp = temp1
replace temp = temp2 if temp==""
labmask country2, values(temp)
drop temp* country2_*





#delimit ;
	gr twoway
		/// Line between min and max
		(rspike prev1 prev2 country2 , 		hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc country2 prev1, 				msize(7) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc country2 prev2 , 				msize(7) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(12) xsize(4.5)

			xlab(0(20)100 , labs(5) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("prevalence", size(5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(10)100, tlc(gs0))

			ylab(1(1)14 16(1)29
					,
			valuelabel labc(gs0) labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)30))
				ytitle("", size(5) margin(l=2 r=5 t=2 b=2))

			text(7 100 "Men", place(w) color(gs0) size(5.5))
			text(21 100 "Women", place(w) color(gs0) size(5.5))

			note("abw=Aruba; vgb=British Virgin Islands; brb=Barbados; bmu=Bermuda;"
				 "cym=Cayman Islands; dma=Dominica; dom=Dominican Republic"
				 "grd=Grenada etc...")

			legend( size(5) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "Questionnaire")
			lab(3 "Objective")
			);
#delimit cr

/*

** Graphics for Enviro-Health workshop April 12 2017
** MEN INACTIVITY ACROSS THE CARIBBEAN
keep if sex==1

#delimit ;
	gr twoway
		/// Line between min and max
		(rspike prev1 prev2 country2 , 		hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc country2 prev1, 				msize(8) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc country2 prev2 , 				msize(8) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(12) xsize(7)

			xlab(0(20)100 , labs(6) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("", size(6) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(10)100, tlc(gs0))

			ylab(1(1)14
					,
			valuelabel labc(gs0) labs(6) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)15))
				ytitle("", size(6) margin(l=2 r=5 t=2 b=2))

			///text(7 100 "Men", place(w) color(gs0) size(5.5))
			///text(21 100 "Women", place(w) color(gs0) size(5.5))

			legend(off size(6) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "Questionnaire")
			lab(3 "Objective")
			);
#delimit cr


/*
** Graphics for Enviro-Health workshop April 12 2017
** WOMEN INACTIVITY ACROSS THE CARIBBEAN
keep if sex==2
drop country2
gen country2 = _n
decode country , gen(temp)
labmask country2, values(temp)

#delimit ;
	gr twoway
		/// Line between min and max
		(rspike prev1 prev2 country2 , 		hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc country2 prev1, 				msize(8) m(o) mlc(gs0) mfc("255 204 170") mlw(0.1))
		/// Maximum points
		(sc country2 prev2 , 				msize(8) m(o) mlc(gs0) mfc("255 127 42") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(12) xsize(7)

			xlab(0(20)100 , labs(6) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("", size(6) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(10)100, tlc(gs0))

			ylab(1(1)14
					,
			valuelabel labc(gs0) labs(6) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)15))
				ytitle("", size(6) margin(l=2 r=5 t=2 b=2))

			///text(7 100 "Men", place(w) color(gs0) size(5.5))
			///text(21 100 "Women", place(w) color(gs0) size(5.5))

			legend(off size(6) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "Questionnaire")
			lab(3 "Objective")
			);
#delimit cr
