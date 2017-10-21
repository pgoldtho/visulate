<?

   // get parametes {propertyID, year}
   
  require_once dirname(__FILE__)."/../classes/SmartyInit.class.php";
  require_once dirname(__FILE__).'/../classes/database/rnt_estimate.class.php';
  require_once dirname(__FILE__).'/../classes/UtlConvert.class.php';
  require_once dirname(__FILE__).'/../classes/SQLExceptionMessage.class.php';
  require_once dirname(__FILE__).'/../classes/database/rnt_business_units.class.php';
  require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
  require_once 'HTML/QuickForm.php';

  function getValue(&$param, $key, $convert = true){
  	foreach ($param as $k => $v) {
  		if (strtolower($v['PAYMENT_TYPE_NAME']) == $key){
  			if ($v['AMOUNT_NEED'] != ''){
  			   if ($convert)	 
  			      return UtlConvert::dbNumericToDisplay($v['AMOUNT_NEED']);
  			   else   
  			      return $v['AMOUNT_NEED'];   
  			}   
  			return 0;   
  		}
  	}
  	return 0;
  }
  
  function convert($value){
  	if (!$value)
  	   return '0.00';
  	return UtlConvert::dbNumericToDisplay($value);   
  	
  }
  
  $smarty = new SmartyInit();

  if (!$smarty->user->isLogin())
       exit;

  if (!$smarty->user->isManager() && !$smarty->user->isManagerOwner() && !$smarty->user->isOwner() && !$smarty->user->isBusinessOwner())
     exit;

  // set current user_id
  $smarty->user->set_database_user();
  $smarty->assign("role",  $smarty->user->getRole());

  // define variables
  $propertyID = @$_REQUEST["propertyID"];
  //$year = @$_REQUEST["year"];

  $dbEst = new RNTEstimate($smarty->connection);
  if (!$propertyID){
      echo "{}";
      exit;
  }

  $params = $dbEst->loadParams($propertyID);

  $p = array();
  $p[] = array('n' => 'MONTHLY_RENT', 'v' => UtlConvert::dbNumericToDisplay( 
	                                             /*round((floatval(getValue($params, 'rent', false)) +
	                                                    floatval(getValue($params, 'remaining rent', false)) +  
	                                                    floatval(getValue($params, 'late fee', false)) +  
	                                                    floatval(getValue($params, 'discounted rent', false)) 
	                                                    )) / 12, 2)*/
	                                             getValue($params, 'avg rent', false)
                                              )
               );  
  $p[] = array('n' => 'VACANCY_PCT', 'v' => 
        floatval(getValue($params, 'rent', false)) == 0.0 ? '0.0' :
                  UtlConvert::dbNumericToDisplay(
                         round( ( ((floatval(getValue($params, 'avg rent', false))*12) 
												          - floatval(getValue($params, 'rent', false)) 
																	- floatval(getvalue($params, 'section 8 rent', false)))/ 
                           (floatval(getValue($params, 'avg rent', false))*12)
                         ) * 100 , 2)
                  )
         );
  $p[] = array('n' => 'OTHER_INCOME', 'v' => 
		                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'late fee', false))
	                                 + floatval(getValue($params, 'recoverable', false))
		              	)); 
	
  $p[] = array('n' => 'PURCHASE_PRICE', 'v' => getValue($params, 'purchase price'));                 

  $p[] = array('n' => 'REPLACE_3YEARS', 'v' => 
  		                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'carpet', false))
	                                 + floatval(getValue($params, '3 year replacements', false))
		              	)); 

  $p[] = array('n' => 'REPLACE_5YEARS', 'v' => 
			                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, '5 year replacements', false))
	                                 + floatval(getValue($params, 'household appliances', false))	                                 
		              	)); 

  $p[] = array('n' => 'REPLACE_12YEARS', 'v' => 
	                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, '12 year replacements', false))
	                                 + floatval(getValue($params, 'capital improvements', false))
	              	)); 

	                
  $p[] = array('n' => 'MAINTENANCE', 'v' => 
		                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'carpet', false))
	                                 + floatval(getValue($params, 'cleaning and maintenance', false))
	                                 + floatval(getValue($params, 'lawn service', false))
	                                 + floatval(getValue($params, 'pest control', false))
	                                 + floatval(getValue($params, 'supplies', false))
	                                 + floatval(getValue($params, 'repairs', false))
	)); 
	
	                
  $p[] = array('n' => 'UTILITIES', 'v' => getValue($params, 'utilities'));                 
  $p[] = array('n' => 'PROPERTY_TAXES', 'v' => 
	                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'property tax', false))
	                                 + floatval(getValue($params, 'tangible tax', false))
	              	)); 

	             
  $p[] = array('n' => 'INSURANCE', 'v' => getValue($params, 'insurance'));
  $p[] = array('n' => 'MGT_FEES', 'v' => 
	                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'management fees', false))
	                                 + floatval(getValue($params, 'advertising', false))
	                                 + floatval(getValue($params, 'auto and travel', false))
	                                 + floatval(getValue($params, 'commissions', false))
	                                 + floatval(getValue($params, 'legal and other fees', false))
	                                 + floatval(getValue($params, 'phone service', false))
	                                 
	              	)); 

	/*
  $p[] = array('n' => 'DOWN_PAYMENT', 'v' => getValue($params, 'down payment'));
  */
  $p[] = array('n' => 'CLOSING_COSTS', 'v' => getValue($params, 'closing costs'));
  
  
  $loanList = $dbEst->getLOANS($propertyID);
  $a = array('LOAN1_AMOUNT', 'LOAN1_TYPE', 'LOAN1_TERM', 'LOAN1_RATE', 'LOAN2_AMOUNT', 'LOAN2_TYPE', 'LOAN2_TERM', 'LOAN2_RATE');
  $loanA = array();
  foreach ($a as $v)
    $loanA[$v] = '';
    
  $loanA['LOAN2_TYPE'] = 'Interest Only';    
  $loanA['LOAN1_TYPE'] = 'Interest Only';
  /*
  for($i=0; $i<2; $i++){
  	if (!array_key_exists($i, $loanList))
  	  break;
  	if ($i == 0){
  		$loanA['LOAN1_AMOUNT'] = UtlConvert::dbNumericToDisplay($loanList[$i]['LOAN_AMOUNT']);
  		$loanA['LOAN1_TERM'] = UtlConvert::dbNumericToDisplay($loanList[$i]['TERM']);
  		$loanA['LOAN1_RATE'] = UtlConvert::dbNumericToDisplay($loanList[$i]['INTEREST_RATE']);
  		$loanA['LOAN1_TYPE'] = 'Interest Only';
  		if ($loanList[$i]['INTEREST_RATE'] != '0')
  		  $loanA['LOAN1_TYPE'] = 'Amortizing';
  	}
  	if ($i == 1){
  		$loanA['LOAN2_AMOUNT'] = UtlConvert::dbNumericToDisplay($loanList[$i]['LOAN_AMOUNT']);
  		$loanA['LOAN2_TERM'] = UtlConvert::dbNumericToDisplay($loanList[$i]['TERM']);
  		$loanA['LOAN2_RATE'] = UtlConvert::dbNumericToDisplay($loanList[$i]['INTEREST_RATE']);
  		$loanA['LOAN2_TYPE'] = 'Interest Only';
  		if ($loanList[$i]['INTEREST_RATE'] != '0')
  		  $loanA['LOAN2_TYPE'] = 'Amortizing';
  	}
  }
  */
  if (count($loanList) > 0 )
     foreach($loanList[0] as $k=>$v)
        $loanA[$k] = $v;
  
  if ( $loanA['LOAN1_RATE'] != 0)
      $loanA['LOAN1_TYPE'] = 'Amortizing';   
 if ( $loanA['LOAN2_RATE'] != 0)
      $loanA['LOAN2_TYPE'] = 'Amortizing';   

  if ($loanA['LOAN1_RATE'] == '')
      $loanA['LOAN1_RATE'] = '8';
  
  if ($loanA['LOAN2_RATE'] == '')
      $loanA['LOAN2_RATE'] = '8';
      
 $p[] = array('n' => 'DOWN_PAYMENT', 'v' => 
	                             UtlConvert::dbNumericToDisplay(
	                                   floatval(getValue($params, 'purchase price', false))
	                                 - floatval($loanA['LOAN1_AMOUNT'])
	                                 - floatval($loanA['LOAN2_AMOUNT'])
	              	));       
   
  foreach($loanA as $k => $v){
  	if ($k == 'LOAN1_TYPE' || $k == 'LOAN2_TYPE')
  	   $p[] = array('n' => $k, 'v' => $v);
  	else   
       $p[] = array('n' => $k, 'v' => convert($v));
  }  
    
    
  $dlmt = "";
  $result = "{";
  foreach($p as $v){
     if ($v['n'] != 'LOAN1_TYPE' || $v['n'] != 'LOAN2_TYPE'){
        if ($v['v'] == '0')
           $v['v'] = '0.00'; 	 
     }      
  	 $result .= $dlmt."'".$v['n']."' : '".$v['v']."'\n";
  	 $dlmt = ", ";
  }
  $result .= '}';
  echo $result;
  $smarty->connection->close();
   
?>