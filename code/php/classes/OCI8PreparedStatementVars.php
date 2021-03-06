<?
  require_once "creole/drivers/oracle/OCI8PreparedStatement.php";
  require_once "creole/util/Clob.php";
 /*
  example:
    proc in database
    ------------------------
    create or replace function testdate(x2 DATE) return DATE IS
     begin
       insert into tt values(x2);
       return SYSDATE;
     end testdate;
    -----------------------------
  Creole::registerDriver("oracle", Creole::getDriver("oracle"));
  $con = Creole::getConnection("oracle://hr:hr@localhost:1251/xe");
  $prepare = $con->prepareStatement("begin :var1 := HR.testdate(:var2); end;");
  $prepare->setTimestamp(2, time()-100000000);
  $prepare->setTimestamp(1, time());
  $prepare->executeUpdate();
  require_once "./classes/OCI8PreparedStatementVars.php";
  echo OCI8PreparedStatementVars::getVar($prepare, 1);
  $con->commit();
 */
 class OCI8PreparedStatementVars extends OCI8PreparedStatement
  {
     /*
      * Return variable from OCI8PreparedStatement.
      */
     static function getVar($prepare, $index)
     {
         return $prepare->boundInVars[$index];
     }
     
   }
?>