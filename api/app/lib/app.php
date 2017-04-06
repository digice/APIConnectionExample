<?php

/** the API requires two parameters:
  * 'm' = the model we are accessing
  * 'a' = the action we want the controller to take
  **/

class AppCtl extends Ctl
{

  protected $action;
  
  protected $model;

  public function __construct()
  {

    parent::__construct();
    
    // add your API models to the list of permitted models
    $permitted_models = array(
      'test' => 'TestCtl',
      'default' => 'DefaultCtl'
    );
    
    $this->model = 'default';

    if ($m = Req::val('m')) {
    
      // we have a model, make sure it is permitted
      if (isset($permitted_models[$m])) {
      
        // yes, the model is permitted
        $this->model = $m;
              
      }
    
    }

    $class = $permitted_models[$this->model];
    
    $ctl = new $class();
    
    header('Content-Type: application/json');
    
    echo json_encode($ctl->response());

  } // ./construct

}
