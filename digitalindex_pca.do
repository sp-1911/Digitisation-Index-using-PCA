/*DIGITAL INDICES: COMPOSITE AND CATEGORY-WISE*/


/*data cleaning*/
/** renaming variables**/
rename Activemobilebroadbandsubscrip ac_mob_sub
rename Fixedtelephonesubscriptionspe fix_tele_sub
rename Fixedbroadbandbasketasaof fix_b_bas_perc_gni
rename Fixedbroadbandsubscriptionspe fix_b_s
rename Fixedbroadbandsubscriptions fix_b_s_10mbit
rename Fixedbroadbandsubscriptions2 fix_b_s_2_10mbit
rename K fix_b_s_256kbit_2mbit
rename Hasaccesstotheinternetag acc_internet
rename Householdswithacomputeratho hh_acc_comp
rename HouseholdswithInternetaccess hh_acc_internet
rename Individualsowningamobilephon ind_mob
rename IndividualsusingtheInternet ind_internet
rename ICT1Proportionoftotalbusin ict_emp_perc
rename ICT2ValueaddedintheICTse ict_valueadded
rename InternationalbandwidthperInte bandwidth_kbit_s
rename Madeadigitalinstoremerchant merch_pay
rename merch_pay merch_pay_abs
rename W merch_pay_perc
drop merch_pay_abs merch_pay_perc
rename Madeadigitalmerchantpayment merch_pay_abs
rename Madeadigitalonlinepaymentfo dig_pay_for_onpurch
rename Madeorreceivedadigitalpayme made_recd_digpay_oerc
rename Mobilecellularsubscriptionspe mob_sub_abs
rename Mobilebroadbandbasketasao mob_b_bas_gnipercc
rename Mobilecellularbasketasaof mob_cell_bas_gniperc
rename Mobiledataandvoicebaskethi data_voice_bas
rename Mobiledataandvoicebasketlo data_voice_bas_low
rename Mobilemoneyaccountage15 mobile_money_acc
drop MonthlyfixedbroadbandInternet MonthlymobilebroadbandInterne
drop Overallindex
rename Ownamobilephoneage15 mobile_own_perc
rename Ownsadebitorcreditcarda debitcard_own_perc
rename Populationcoveredbyamobilec pop_under_mob_network
rename Populationcoveredbyatleasta pop_under_atleast3g
rename AN pop_under_atleast4g
rename Proportionoftotalbusinesssec ictsector_emp_perc
rename ResearchandDevelopment rd
rename Totalfixedbroadbandsubscripti total_fix_b_s
rename AV mob_int_checkbalance
drop Useamobilephoneortheintern Usedadebitorcreditcarda Usedamobilephoneortheinter AW AX
drop ValueaddedintheICTsectoras
rename Accesstofinance acc_finance
rename Accountage15 acc_to_account_perc

/** factor test for PCA appropriateness**/
/*** Sub index 1: Digital Infrastructure Index***/
factortest ac_mob_sub fix_tele_sub fix_b_bas_perc_gni fix_b_s fix_b_s_10mbit fix_b_s_2_10mbit fix_b_s_256kbit_2mbit total_fix_b_s

pca ac_mob_sub fix_tele_sub fix_b_bas_perc_gni fix_b_s fix_b_s_10mbit fix_b_s_2_10mbit fix_b_s_256kbit_2mbit total_fix_b_s /*PCA*/
predict dig_infr1 dig_infr2 dig_ingr3
gen dig_ifr1n = (dig_infr1 + dig_infr2 + dig_ingr3)/3
            /*Generating normalised digital infrastructure index*/
egen min_dig_inf = min( dig_ifr1n)
egen max_dig_inf = max(dig_ifr1n)
gen norm_dig_inf = ( dig_ifr1n - min_dig_inf ) /( max_dig_inf - min_dig_inf )

egen country = group( Country )
xtset country Year
            /*Country-wise digital infrastructure graphs*/    
twoway (line norm_dig_inf Year, sort), by (Country)

            /*Ranking of countries on the digital payment index for the year 2022*/
egen norm_diginf_rank = mean(norm_dig_inf) if Year==2022

/*** Composite Digital Index***/
pca acc_finance acc_to_account_perc ac_mob_sub fix_b_bas_perc_gni fix_b_s fix_b_s_10mbit fix_b_s_2_10mbit fix_b_s_256kbit_2mbit acc_internet hh_acc_comp hh_acc_internet ICT ict_emp_percict_valueadded ind_mob ind_internet Industryactivity bandwidth_kbit_s merch_pay_abs dig_pay_for_onpurch made_recd_digpay_oerc mob_sub_abs mob_b_bas_gnipercc mob_cell_bas_gniperc data_voice_bas data_voice_bas_low mobile_money_acc mobile_own_perc debitcard_own_perc pop_under_mob_network pop_under_atleast3g pop_under_atleast4g ictsector_emp_perc rd Skills total_fix_b_s mob_int_checkbalance
predict digind1 digind2 digind3 digind4 digind5 digind6 digind7 digind8 digind9 digind10 digind11
gen digind1n = ( digind1 + digind3 + digind4 + digind5 + digind6 +digind8 +digind9 + digind10 +digind11)/11
           
		   /*Generating normalised composite digital index*/
egen min_digind = min( digind1n)
egen max_digind = max(digind1n)
gen norm_digind = ( digind1n - min_digind ) /( max_digind - min_digind )
          /*Plotting country-wise composite digital index*/
twoway (line norm_digind Year, sort), by (Country)

            /*Ranking of countries on the composite digital index for the year 2022*/
bysort country: egen cond_digindv4 = mean(norm_digind) if Year==2022

export excel using "C:\Users\somya\OneDrive\Desktop\ranking_conf.xls", firstrow(variables)

/*** Sub Index 2: Digital Adoption Index***/
factortest acc_internet hh_acc_comp hh_acc_internet ICT ict_emp_perc ict_valueadded ind_mob ind_internet ictsector_emp_perc rd Skills
pca acc_internet hh_acc_comp hh_acc_internet ICT ict_emp_perc ict_valueadded ind_mob ind_internet ictsector_emp_perc rd Skills
predict dig_adop1 dig_adop2 dig_adop3 dig_adop4
 
             /*Generating normalised digital adoption index*/
egen min_digadop = min( digadop1n)
egen max_digadop = max( digadop1n)
gen norm_digadop = ( digadop1n - min_digadop ) /( max_digadop - min_digadop )
          /*Plotting country-wise digital adoption index*/
twoway (line norm_digadop Year, sort), by (Country)

            /*Ranking of countries on the digital adoption index for the year 2022*/
egen normdigadop_rank = mean(norm_digadop) if Year==2022


/*** Sub Index 3: Digital Innovation Index***/

factortest Industryactivity bandwidth_kbit_s rd Skills
pca Industryactivity bandwidth_kbit_s rd Skills
predict diginn1 diginn2
gen diginn1n= ( diginn1 +diginn2)/2

             /*Generating normalised digital innovation index*/
egen min_diginn = min( diginn1n)
egen max_diginn = max( diginn1n)
gen norm_diginn = ( diginn1n - min_diginn ) /( max_diginn - min_diginn )

          /*Plotting country-wise digital adoption index*/
twoway (line norm_diginn Year, sort), by (Country)

            /*Ranking of countries on the digital adoption index for the year 2022*/
egen normdiginn_rank = mean(norm_diginn) if Year==2022


/*** Sub Index 4: Digital Payment Index***/
factortest merch_pay_abs made_recd_digpay_oerc mob_sub_abs mob_b_bas_gnipercc mob_cell_bas_gniperc data_voice_bas data_voice_bas_low mobile_money_acc mobile_own_perc debitcard_own_perc pop_under_mob_network pop_under_atleast3g pop_under_atleast4g mob_int_checkbalance
pca merch_pay_abs made_recd_digpay_oerc mob_sub_abs mob_b_bas_gnipercc mob_cell_bas_gniperc data_voice_bas data_voice_bas_low mobile_money_acc mobile_own_perc debitcard_own_perc pop_under_mob_network pop_under_atleast3g pop_under_atleast4g mob_int_checkbalance
predict digpay1 digpay2 digpay3 digpay4 digpay5
gen digpay1n = ( digpay1+ digpay2 +digpay3+ digpay4 +digpay5)/5

             /*Generating normalised digital payment index*/
egen min_digpay = min( digpay1n)
egen max_digpay = max( digpay1n)
gen norm_digpay = ( digpay1n - min_digpay ) /( max_digpay - min_digpay )

          /*Plotting country-wise digital payment index*/
twoway (line norm_digpay Year, sort), by (Country)

            /*Ranking of countries on the digital payment index for the year 2022*/
egen normdigpay_rank = mean(norm_digpay) if Year==2022


    
