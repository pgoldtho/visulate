<!-- Copyright Visulate LLC 2007, 2008  All Rights Reserved Worldwide-->
function addCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';

	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}

	return x1 + x2;
}

function stripCommas(nStr)
{
  var re = /,/g;
  return nStr.replace(re, "") *1;
}

function stripCommas2(nStr1)
{
  var re = /,/g;
  var nStr = nStr1;
  return nStr.replace(re, "") *1;
}

function compute_value(form)
{
  var gross = 0;
  gross = floor(stripCommas(form.MONTHLY_RENT.value) * 12);
  form.prop_gross.value =  addCommas(gross);
  var other = stripCommas(form.OTHER_INCOME.value) * 1;
  var total_gross = gross + other;
 
  form.prop_total_gross.value =  addCommas(total_gross);
    vc = gross * form.VACANCY_PCT.value/100;
    form.prop_vc_act.value = addCommas(vc.toFixed(2));
 
  var i3 =  (stripCommas(form.REPLACE_3YEARS.value)*1)/3;
  var i5 =  (stripCommas(form.REPLACE_5YEARS.value)*1)/5;
  var i12 = (stripCommas(form.REPLACE_12YEARS.value)*1)/12;
  var itot =  i3 + i5 + i12;
  form.prop_impr.value = itot.toFixed(2);
 
  var noi = total_gross - vc
                  - stripCommas(form.prop_impr.value)
                  - stripCommas(form.MAINTENANCE.value)
                  - stripCommas(form.UTILITIES.value)
                  - stripCommas(form.PROPERTY_TAXES.value)
                  - stripCommas(form.INSURANCE.value)
                  - stripCommas(form.MGT_FEES.value);
  form.prop_noi.value = addCommas(noi.toFixed(2));
  var cap_rate = form.CAP_RATE.value   * 1;
  var cur_value = stripCommas(form.PURCHASE_PRICE.value) * 1;
  if (cur_value != 0) 
   {
    cap_rate = (noi * 100)/cur_value;
    form.CAP_RATE.value = cap_rate.toFixed(2);
   }
 
  if (cap_rate == 0)
      {cap_rate = 7.5;
       form.CAP_RATE.value = cap_rate;
      }
    cur_value = (noi * 100)/cap_rate;
    form.PURCHASE_PRICE.value = addCommas(cur_value.toFixed(0));
    
	if (document.calc.LOAN1_AMOUNT.value == ''){
         document.calc.LOAN1_AMOUNT.value = stripCommas(form.PURCHASE_PRICE.value) 
                                           - stripCommas(form.DOWN_PAYMENT.value);
	}

    document.calc.temps_AT.value = stripCommas(form.PROPERTY_TAXES.value);
    document.calc.temps_AI.value = stripCommas(form.INSURANCE.value);

    dosum();
    dosum2();
}

function floor(number)
{
  return Math.floor(number*Math.pow(10,2) + 0.5)/Math.pow(10,2);
}

function dosum()
{
  var ltyp = window.document.calc.LOAN1_TYPE.value;
  if (ltyp == 'Interest Only')
   {
    var payment = stripCommas(document.calc.LOAN1_AMOUNT.value) 
		              * stripCommas(document.calc.LOAN1_RATE.value) /1200;
    document.calc.temps_PI.value = payment.toFixed(2);
    document.calc.LOAN1_TERM.value = '';
    document.calc.LOAN1_TERM.disabled = true;
   }
  else
   {
    document.calc.LOAN1_TERM.disabled = false;
    if  (document.calc.LOAN1_TERM.value == '') {
        document.calc.LOAN1_TERM.value = 30;
     }
    var mi = stripCommas(document.calc.LOAN1_RATE.value) / 1200;
    var base = 1;
    var mbase = 1 + mi;
    for (i=0; i<stripCommas(document.calc.LOAN1_TERM.value) * 12; i++)
    {
      base = base * mbase
    }
    document.calc.temps_PI.value = floor(stripCommas(document.calc.LOAN1_AMOUNT.value) 
		                             * mi / ( 1 - (1/base)))
  }
  document.calc.temps_MT.value = floor(stripCommas(document.calc.temps_AT.value) / 12)
  document.calc.temps_MI.value = floor(stripCommas(document.calc.temps_AI.value) / 12)

  document.calc.temps_MP.value = floor((stripCommas(document.calc.temps_MI.value) * 1)
                          + (stripCommas(document.calc.temps_MT.value) * 1)
                          + (stripCommas(document.calc.temps_PI.value) * 1));
  cashflow();
}


function dosum2()
{
  var ltyp = document.calc.LOAN2_TYPE.value;
  if (ltyp == 'Interest Only')
   {
    var payment = stripCommas(document.calc.LOAN2_AMOUNT.value) 
		            * stripCommas(document.calc.LOAN2_RATE.value) /1200;
    document.calc.temps2_PI.value = payment.toFixed(2);
    document.calc.LOAN2_TERM.value = '';
    document.calc.LOAN2_TERM.disabled = true;
   }
  else
   {
    if  (document.calc.LOAN2_TERM.value == '') {
        document.calc.LOAN2_TERM.value = 30;
     }
    document.calc.LOAN2_TERM.disabled = false;
    var mi = stripCommas(document.calc.LOAN2_RATE.value) / 1200;
    var base = 1;
    var mbase = 1 + mi;
    for (i=0; i< (stripCommas(document.calc.LOAN2_TERM.value) * 1) * 12; i++)
    {
      base = base * mbase
    }
    document.calc.temps2_PI.value = floor(stripCommas(document.calc.LOAN2_AMOUNT.value) 
		                              * mi / ( 1 - (1/base)))
   }
 cashflow();

}

function cashflow()
{
  var m_noi = ((stripCommas(document.calc.prop_noi.value) * 1)/12);
  document.calc.cf_m_noi.value = Math.round(m_noi *12);
  document.calc.cf_a_noi.value = Math.round( m_noi * 12);

  var m_loan1 = document.calc.temps_PI.value * 1;
  var m_loan2 = document.calc.temps2_PI.value * 1;

  document.calc.cf_m_loan1.value = m_loan1;
  document.calc.cf_a_loan1.value = m_loan1 * 12;
  document.calc.cf_m_loan2.value = m_loan2;
  document.calc.cf_a_loan2.value = m_loan2 * 12;
  document.calc.cf_m_cf.value = floor(m_noi - m_loan1 - m_loan2);
  document.calc.cf_a_cf.value = floor((m_noi - m_loan1 - m_loan2) * 12);

  var dscr = (m_noi/(m_loan1 + m_loan2)).toFixed(2);;
  document.calc.dscr.value=dscr;
  var dscr_status = document.getElementById("dscr_status");
  if (dscr < 1.25)
   {dscr_status.innerHTML = '<img src="/images/warning.png" alt="Debt Service Coverage Ratio is less than 1.25"/>';}
  else
   {dscr_status.innerHTML = '&nbsp;';}
  
  document.calc.prop_cash_on_cash.value 
         = ((stripCommas(document.calc.cf_a_cf.value) * 1)
				   /(stripCommas(document.calc.DOWN_PAYMENT.value) +
					   stripCommas(document.calc.CLOSING_COSTS.value) )
					               * 100).toFixed(2) + '%';
  
}

