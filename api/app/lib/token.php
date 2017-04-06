<?php

class TokenMdl extends Mdl
{

  protected static $shared;

  public static function shared()
  {
    if (!isset(self::$shared)) {
      self::$shared = new self();
    }
    return self::$shared;
  }
  
  public function __construct()
  {
    $this->name = 'token';
    parent::__construct();
  }
}

class TokenCtl
{

  public function __construct()
  {
  
  }

  public function createToken($model,$id)
  {

    $mdl = TokenMdl::shared();

    $token = md5(date('U').$model.$id);

    $assoc = array(
      'name' => $token,
      $model.'_id' => $id
    );

    $token_id = $mdl->insertAssoc($assoc);

    return $token;

  }

  public function deleteToken($name)
  {
    $mdl = TokenMdl::shared();
    $mdl->deleteAssoc($name);
  }

}