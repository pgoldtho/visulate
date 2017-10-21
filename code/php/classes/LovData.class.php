<?php
class LOVData{

  private $name = "";
  private $data = array();
//  private $isDisplay;

  function __construct($dataName, $data){
     $this->name = $dataName;
//     $this->isDisplay = $isDisplay;
     $this->setData($data);
  }

  function setData($data){
     $this->data = $data;
  }

  function getCodeByValue($value){
     if ($value == "")
       return "";
     return @$this->data[$value];
  }

  function display(){
    $text = "\n<script language=\"javascript\">\n".
            " var ".$this->name." = [";
    $delim = " ";
    $i = 0;
    foreach($this->data as $k=>$v){
       $t = "";
       /*
       if ($this->isDisplay)
         $t = ", \"".$v[2]."\"";*/
       $text .= $delim."[$i, \"".$k."\", \"".$v."\"]\n";
       $delim = ",";
       ++$i;
    }
    $text .= "];\n</script>";
    return $text;
  }

  function getName(){
     return $this->name;
  }

}
?>