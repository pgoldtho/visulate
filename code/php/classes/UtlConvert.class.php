<?php
class UtlConvert
{
    const ErrorDateMsg = "Date should be correct and have the format MM/DD/YYYY.";
    /*
       Convert date from format
       $strdate  - YYYY-MM-DD HH24:MI:SS
       to format
       return for example: 04/23/2007
    */
    public static function dbDateToDisplay($strdate)
    {
        if (!$strdate)
           return "";
        $m = array();
        preg_match("/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/i", $strdate, $m);
        if (count($m) == 0)
          return FALSE;
        return $m[2]."/".$m[3]."/".$m[1];
    }

    /*   Convert date from format
         $strdate - 04/23/2007
         to format
         return YYYY-MM-DD HH24:MI:SS
    */
    public static function displayToDBDate($strdate)
    {
         if (!$strdate)
            return "";
         $m = array();
         // regular expression for date format: MM/DD/RRRR
         preg_match("/^(\d\d?)\\/(\d\d?)\\/(\d{4})$/i", $strdate, $m);
         if (count($m) == 0)
            return FALSE;
         list(, $month, $day, $year) = $m;

         $lo_day = 1;
         $hi_day = -1;
         if (in_array($month, array(1,3,5,7,8,10,12)))
         {
             $hi_day = 31;
         } elseif (in_array($month, array(4,6,9,11)))
         {
             $hi_day = 30;
         } elseif ($month == 2) {
             $hi_day = 28;
             if (($year%4 == 0) && ($year%100 != 0)) {
                 $hi_day = 29;
             } elseif ($year%400 == 0) {
                 $hi_day = 29;
             }
         }

         $result = FALSE;
         if (($day >= $lo_day) && ($day <= $hi_day)) {
             $day = str_pad($day, 2, '0', STR_PAD_LEFT);
             $month = str_pad($month, 2, '0', STR_PAD_LEFT);
             $result = $year."-".$month."-".$day." 00:00:00";
         }

         return $result;
    }

    /*
         $strdate - 12 January, 2007 or 12January2007 or 12 January,2007
         return FALSE if validate failed, otherwise string for date
    */
    public static function validateDisplayDate($strdate)
    {
        if ($strdate == "")
           return $strdate;
        $dbDateString = UtlConvert::displayToDBDate($strdate);
        if ($dbDateString === FALSE)
           return FALSE;
        return UtlConvert::dbDateToDisplay($dbDateString);
    }

    /*Convert from db numeric string format to display*/
    public static function dbNumericToDisplay($value, $precision = 2)
    {
         if ($value == "") return "";
         $value = str_replace(",", ".", $value);
         if ($precision > 0 )
            $value = number_format($value, $precision, '.', ','); //spritf("%01.2f", $value);////
         return $value;
    }

    /*Convert from display numeric string format to db format*/
    public static function DisplayNumericToDB($value)
    {
         return /*str_replace(".", ",", */str_replace(",", "", $value)/*)*/;
    }

}

/*---------------For HTML_QuickForm -----------------*/
/*Rule for validate date in display date format*/
function validateDate($rule, $value, $var3)
{
     $v = UtlConvert::validateDisplayDate($value);

     if (empty($v) || $v===FALSE)
        return FALSE;
     return TRUE;
}

/*Rule for validate numeric*/
function validateNumeric($rule, $value, $var3)
{
  return preg_match("/(^-?\d*([,\.]?\d)*$)|(^-?\d+$)|(^-?[\.,]\d+$)/", $value);
}

/*Rule for validate integer*/
function validateInteger($rule, $value, $var3)
{
  return preg_match("/^-?\d*$/", $value);
}

function getYearFromDisplayDate($strdate)
{
    $m = array();
    // regular expression for date format: MM/DD/RRRR
    preg_match("/^(\d\d?)\\/(\d\d?)\\/(\d{4})$/i", $strdate, $m);
    return $m[3];
}

function getIntFromDisplayDate($strdate)
{
    $m = array();
    // regular expression for date format: MM/DD/RRRR
    preg_match("/^(\d\d?)\\/(\d\d?)\\/(\d{4})$/i", $strdate, $m);
    return ($m[3]*100+$m[1])*100+$m[2];
}
/*----------------------------------------------------*/
?>