/*

https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2023&layergroup=States+%28and+equivalent%29

*/

ssc install shp2dta

global route "C:\Users\tmorg\Desktop\gap_year"

import delimited using "$route/data/school_latlons.csv", varn(1) clear

rename (lat lon) (_Y _X)

drop if team=="Alaska"

save "$route/data/school_coords.dta", replace



cd "$route/data/cb_2018_us_state_500k"

shp2dta using cb_2018_us_state_500k, data(data) coord(coords) replace

use coords, clear

merge m:1 _ID using data, keep(1 3) nogen

drop if inlist(STATEFP, "02", "15", "72", "60", "66", "69", "78")

append using "$route/data/school_coords.dta"

gen states = STATEFP!=""



twoway area _Y _X if states==1, cmiss(n) fi(25) col(gray) leg(off) ysc(off) yla(,nogrid) xla(,nogrid) xsc(off) graphr(fc(white)) || scatter _Y _X if states==0 & had2021==0 || scatter _Y _X if states==0 & had2021==1



/* NorCal Teams:
	Y San Jose State 
	Y California
	Y Stanford
	N UC Davis
	N Sacramento State	*/
	
/* Northeast Teams:
	Y New Hampshire
	Y Pittsburgh
	Y Penn State
	Y Temple
	Y LIU* (but no pre-2021 seasons, so yeet)
	Y Rutgers
	N Brockport
	N Cortland State
	N Cornell
	N Ithaca College
	N Springfield College
	N Rhode Island College
	N Brown
	N Southern Conn.
	N Yale
	N Bridgeport
	N Ursinus College
	N West Chester
	N Pennsylvania */
	
