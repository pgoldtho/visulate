<?

  define("REQUEST_MENU_LEVEL1", "m1");
  define("REQUEST_MENU_LEVEL2", "m2");
  require_once dirname(__FILE__)."/config.php";

  class Menu {
     public $request_menu_level1 = REQUEST_MENU_LEVEL1;
     public $request_menu_level2 = REQUEST_MENU_LEVEL2;
     public $menu_data1;
     public $menu_data2;

     public $current_level1;
     public $current_level2;
     private $user;
     private $menu_data;

     // User - its user object.
     public function __construct($m1, $m2, $menu_data, $user)
     {
        $this->current_level1 = $m1;
        $this->current_level2 = $m2;
        $this->user = $user;
        $this->menu_data = $menu_data;
        $this->set_current();
     }

     public function getParam2()
     {
        return $this->request_menu_level2."=".$this->current_level2;
     }

     private function set_first_allowed($menu_data_level)
     {
          foreach($menu_data_level as $k=>$v)
              if (in_array($this->user->getRole(), $v["role"]))
                  return $k;
          return "";
     }
     
     private function set_current()
     {
         // menu level1 is not assign and menu level2 is not assign
         if (!$this->current_level1 && !$this->current_level2)
             // default menu
             $this->current_level1 = $this->set_first_allowed($this->menu_data);// "property";

         // define menu for level2 if defined menu level1
         if ($this->current_level1 && !$this->current_level2)
         {
               // try to read value from context
               if ($item_menu2 = Context::getMenuTabOption($this->current_level1))
                 $this->current_level2 = $item_menu2;
               else
                 $this->current_level2 = $this->set_first_allowed($this->menu_data[$this->current_level1]["items"]);
         }
         else
         // if defined item of menu for level 2 then define current menu for level 1
         if (!$this->current_level1 && $this->current_level2)
         {
                foreach($this->menu_data as $k=>$v)
                    if (in_array($this->user->getRole(), $v["role"]))
                    {
                        foreach($v["items"] as $k1=>$v1)
                           if (in_array($this->user->getRole(), $v1["role"]))
                               if ($k1 == $this->current_level2)
                               {
                                   // find menu 2 level
                                   $this->current_level1 = $k;
                                   break(2);
                               }
                    }

              // not found menu for level1 it is meaning that data from request is illegal
              if (!$this->current_level1)
              {
                   $this->current_level1 = $this->set_first_allowed($this->menu_data); //"property";
                   $this->current_level2 = $this->set_first_allowed($this->menu_data[$this->current_level1]["items"]); // key($this->menu_data[$this->current_level1]["items"]);
              }
          }
          
          // save data to context
          Context::setMenuTabOption($this->current_level1, $this->current_level2);
          
          // Initial array for smarty
          $this->menu_data1 = array();


          foreach($this->menu_data as $k=>$v)
          { 
              if (in_array($this->user->getRole(), $v["role"])){
                  $menu_items = array();
                  foreach($this->menu_data[$k]["items"] as $k1=>$v1){
                      if (in_array($this->user->getRole(), $v1["role"]))
                       $menu_items[$k1] = array("title" => $v1["title"], "href" => $v1["href"]);
                  }
                  $this->menu_data1[$k] = array("title" => $v["title"], "href" => $v["href"], "items" => $menu_items);
              }
          }
          $this->menu_data2 = array();
          foreach($this->menu_data[$this->current_level1]["items"] as $k=>$v)
          {
               if (in_array($this->user->getRole(), $v["role"]))
                  $this->menu_data2[$k] = array("title" => $v["title"], "href" => $v["href"]);
          }

     }    // -- private function set_current()

  } // -- class Menu {
?>