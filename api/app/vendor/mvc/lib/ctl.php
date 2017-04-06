<?php

abstract class Ctl
{

  protected $response;

  public function __construct()
  {
    $this->response = array('success' => 'false','message' => 'No Data');
  }

  public function response()
  {
    return $this->response;
  }

}