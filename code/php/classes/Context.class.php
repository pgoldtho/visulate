<?

class Context
{

   public static function readValue($name)
   {
      return @$_SESSION[$name];
   }

   public static function writeValue($name, $value)
   {
      $_SESSION[$name] = $value;
   }

   public static function getBusinessID()
   {
      return Context::readValue("BUSINESS_ID");
   }

   public static function setBusinessID($value)
   {
      return Context::writeValue("BUSINESS_ID", $value);
   }

   public static function getPropertyID()
   {
      return Context::readValue("PROPERTY_ID");
   }
   
   public static function setPropertyID($value)
   {
      return Context::writeValue("PROPERTY_ID", $value);
   }

   public static function setMobileDevice($value)
   {
      return Context::writeValue("MOBILE_DEVICE", $value);
   }
   
   public static function getMobileDevice()
   {
      return Context::readValue("MOBILE_DEVICE");
   }

   
   public static function setMenuTabState($value)
   {
   	  if (!is_array($value))
   	    $value = array();
      return Context::writeValue("MENU_TAB", serialize($value));
   }
   
   public static function getMenuTabState()
   {
   	  $x = unserialize(Context::readValue("MENU_TAB"));
   	  if (!is_array($x))
   	     $x = array();
      return $x;
   }
   
   public static function setMenuTabOption($item1, $item2)
   {
   	  $x = Context::getMenuTabState();
   	  $x[$item1] = $item2;
   	  Context::setMenuTabState($x);
   }
   
   
   public static function getMenuTabOption($item1)
   {
   	  $x = Context::getMenuTabState();
   	  return @$x[$item1];
   }

   public static function clearContext()
   {
      Context::setPropertyID("");
      Context::setBusinessID("");
      Context::setMenuTabState("");
   }
}

?>