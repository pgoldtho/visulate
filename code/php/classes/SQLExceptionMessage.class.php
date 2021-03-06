<?php
class SQLExceptionMessage extends SQLException
{
      protected $code;
      protected $message;
      protected $exception;

      public function __construct($e)
      {
//     print $e;
           $this->exception = $e;
           // example:
           //20001: ORA-20001: Record was changed another user.
           //ORA-06512: at "RNTMGR.RNT_PROPERTIES_PKG", line 99
           //ORA-06512: at line 3
           $m = array();
           preg_match("/\d+: ORA(-\d+): (.+)/", $e->nativeError, $m);
           if (count($m) == 0)
           {
             $this->code = 0;
             $this->message = $e->nativeError;
           }
           else
           {
             $this->code = $m[1];
             $this->message = $m[2];
           }
      }
       /*
      public function getMessageError()
      {
         return $this->message;
      }

      public function getCodeError()
      {
         return $this->code;
      }
      */
}
?>