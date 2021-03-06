<?php
    require_once dirname(__FILE__)."/classes/SmartyInit.class.php";
    require_once dirname(__FILE__)."/classes/UtlConvert.class.php";
    require_once dirname(__FILE__)."/classes/SQLExceptionMessage.class.php";
    require_once 'HTML/QuickForm/Renderer/ArraySmarty.php';
    require_once "HTML/QuickForm.php";
    $smarty = new SmartyInit('http');

    $name =  htmlentities($_POST['name'], ENT_QUOTES);
    $email=$_POST['email'];
    $message = htmlentities($_POST['message'], ENT_QUOTES);
    $url =  htmlentities($_POST['url'], ENT_QUOTES);
    $phone =  htmlentities($_POST['phone'], ENT_QUOTES);
    $formSubject =  htmlentities($_POST['subject'], ENT_QUOTES);
    $contactType = htmlentities($_POST['contactType'], ENT_QUOTES);
    $honeyPot = htmlentities($_POST['honeypot'], ENT_QUOTES);


    // Validate input
    $errorMessage = "";

    if (!preg_match("/^[a-zA-Z ]*$/",$name)) {
        $errorMessage = "Invalid name (only letters and spaces are allowed). ";
    }
        
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
         $errorMessage .= "Invalid email format. ";
    }

    if (strlen($phone) < 10 ) {
         $errorMessage .= "Phone number too short. ";
    }

    if ((strlen($formSubject) + strlen($message)) < 20) {
         $errorMessage .= "Message too short. ";
    }

   if (strlen($honeyPot) > 0){
     $errorMessage .= "You appear to be using a SPAM Bot to post messages. ";
   }


    if (strlen($errorMessage) > 0){
        print '<p style="width: 400px;
                     border: 1px solid #D8D8D8;
                     padding: 5px;
                     border-radius: 5px;
                     font-family: Arial;
                     font-size: 11px;
                     text-transform: uppercase;
                     background-color: rgb(255, 249, 242);
                     color: rgb(211, 0, 0);
                     text-align: center;">Message Failed.  Please correct the following errors and try again</p>';
       print '<p>'.$errorMessage.'</p>';
       if (strlen($url)> 10){
       print '<a href="' . $url . '">Return to Page</a>';
       }
    }
    else {

    $to = "sales@visulate.com";
    $subject = $contactType . " - " . $formSubject;
    $message = $message . "\r\n Email: " . $email
                        . "\r\n Name: "  . $name
                        . "\r\n Phone: " . $phone
                        . "\r\n Sent From: " . $url;
                       


    $headers = "From:" . $email . "\r\n";
    $headers .= "Content-type: text/plain; charset=UTF-8" . "\r\n";

    if(@mail($to,$subject,$message,$headers))
    {
      print '<p style="width: 400px;
                     border: 1px solid #D8D8D8;
                     padding: 10px;
                     border-radius: 5px;
                     font-family: Arial;
                     font-size: 11px;
                     text-transform: uppercase;
                     background-color: rgb(236, 255, 216);
                     color: green;
                     margin-top: 30px;
                     text-align: center;">Message Sent</p>';
      print '<a href="' . $url . '">Return to Page</a>'; }
    else{
      print '<p style="width: 400px;
                     border: 1px solid #D8D8D8;
                     padding: 5px;
                     border-radius: 5px;
                     font-family: Arial;
                     font-size: 11px;
                     text-transform: uppercase;
                     background-color: rgb(255, 249, 242);
                     color: rgb(211, 0, 0);
                     text-align: center;">Message Failed</p>';

      print '<a href="mailto:sales@visulate.com?Subject='. $subject . '">
            Try again. </a>';
      print '<a href="' . $url . '"> Return to Page</a>';

     }
   }
?>
