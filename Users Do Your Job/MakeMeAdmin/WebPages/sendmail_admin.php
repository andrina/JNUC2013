<?php
$to = "support@yourcompany.com";
$email = $_REQUEST['email'] ;
$name = $_REQUEST['name'] ;
$phone = $_REQUEST['phone'] ;
$subject = "Admin Access Request from: $name";
$description = $_REQUEST['description'] ;
$MachineName = $_REQUEST['MachineName'] ;
$body = "From: $name \n\n Email: $email \n\n Extension: $phone \n\n Request: $description \n\n Machine: $MachineName";
$sent = mail($to, $subject, $body, 'From: SelfServiceRequest@yourcompany.com','-f SelfServiceRequest@yourcompany.com') ;
if($sent)
{echo "<script language=javascript>window.location = 'granted.html';</script>";}
else
{echo "<script language=javascript>window.location = 'granted.html';</script>";}
?>