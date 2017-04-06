<?php

class Req
{

  public static function val($key)
  {

    // check for POST
    if (isset($_POST[$key])) {
    
      // we have POST, see if it has length
      if (strlen($_POST[$key]) > 0) {

        // POST parameter was not empty
        $value = $_POST[$key];
        unset($_POST[$key]);
        return $value;

      } else {
      
        // parameter was empty
        unset($_POST[$key]);
        return false;

      }
    
    }
    
    // no POST, so check for GET
    elseif (isset($_GET[$key])) {

      // we have GET, see if it has length
      if (strlen($_GET[$key]) > 0) {

        // GET parameter was not empty
        $value = $_GET[$key];
        unset($_GET[$key]);
        return $value;

      } else {
      
        // parameter was empty
        unset($_GET[$key]);
        return false;      

      }
    
    }
    
    // no POST or GET
    else {

      // paramaeter was not in request
      return false;

    }

  }
  
}
