<?php
require_once("HTML/QuickForm/input.php");

class HTML_QuickForm_lov extends HTML_QuickForm_input
{
    var $exAttr;
    var $dataObj;

    function HTML_QuickForm_lov($elementName=null, $elementLabel=null, $attributes=null, $exAttr = null, $dataObj = null)
    {
        HTML_QuickForm_input::HTML_QuickForm_input($elementName, $elementLabel, $attributes);
        $this->dataObj = $dataObj;
        $this->exAttr = $exAttr;
        $this->_persistantFreeze = true;
        $this->setType('lov');
    } //end constructor

    function getAttr($name){
       return "$name=\"".@$this->_attributes[$name]."\" ";
    }

    function getExAttrVal($name){
       return "\"".@$this->exAttr[$name]."\"";
    }

    function getCode($value){
      return $this->dataObj->getCodeByValue($value);
    }

    function toHtml()
    {
        /*if ($this->_flagFrozen) {
            return $this->getFrozenHtml();
        } else {
            return $this->_getTabs() . '<input' . $this->_getAttrString($this->_attributes) . ' />';
        } */

        $image = "";
        /*
        $isDisplay = "false";
        if (@$this->exAttr["isDisplay"] && $this->exAttr["isDisplay"] == "true")
           $isDisplay = true;
          */
        if (!$this->_flagFrozen)
          $image = "<a href=\"javascript:void(0)\" onClick=\"showLov('".$this->_attributes["name"]."', '".@$this->exAttr["nameCode"]."', '', '".$this->dataObj->getName()."', false)\"><img src=\"".$this->exAttr["imagePath"]."\" border=\"0\"></a>";

        $sizeCode = @$this->exAttr["sizeCode"];
        //$sizeDisplay = @$this->exAttr["sizeDisplay"];

        if (!$sizeCode)
           $sizeCode = 20;
       // if (!$sizeDisplay)
       //    $sizeDisplay = 20;
        /*
        $display = "";
        if (@$this->exAttr["isDisplay"]){
          $display = "<input type=\"text\" disabled=\"disabled\" name=".$this->getExAttrVal("nameDisplay")." id=".$this->getExAttrVal("nameDisplay")." size=\"$sizeDisplay\"";
        } */

        if ($this->_flagFrozen)
           return $this->getCode(@$this->_attributes["value"]);
        return "<input type=\"hidden\" id=".$this->_attributes["name"]." ".$this->getAttr("name").$this->getAttr("value").">".
               "<input type=\"text\" size=\"$sizeCode\" readonly=\"readonly\" id=".$this->getExAttrVal("nameCode")." name=".$this->getExAttrVal("nameCode").
               " value=\"".$this->getCode(@$this->_attributes["value"])."\" style=\"background-color:#dddddd;color:#808080\">".$image;

    } //end func toHtml


    function setSize($size)
    {
        $this->updateAttributes(array('size'=>$size));
    }

    function setMaxlength($maxlength)
    {
        $this->updateAttributes(array('maxlength'=>$maxlength));
    }

} //end class HTML_QuickForm_lov
?>
