<?php

class TestMdl extends Mdl
{

  protected static $shared;

  // return the singleton. Access with TestMdl::shared();
  public static function shared()
  {
    if (!isset(self::$shared)) {
      self::$shared = new self();
    }
    return self::$shared;
  }
  
  public function __construct()
  {

    // set the name of this model
    $this->name = 'test';

    // parent constructor will calculate paths based on name
    parent::__construct();

  }

}

class TestCtl extends Ctl
{

  public function __construct()
  {

    parent::__construct();
    
    $this->response['model'] = 'test';
    
	if ($action = Req::val('a')) {
	  switch ($action) {
	    case 'create':
	      $this->response['action'] = 'create';
	      $this->create();
	      break;
	    case 'authenticate':
	      $this->response['action'] = 'authenticate';
	      $this->authenticate();
	      break;
	    case 'update':
	      $this->response['action'] = 'update';
	      $this->update();
	      break;
	    case 'logout':
	      $this->response['action'] = 'logout';
	      $this->logout();
	      break;
	    default:
	      $this->dearth();
	      break;
	  }

	} // ./action parameter was set

    else {
    
      $this->response['message'] = 'No Action Parameter';
    
    }

  }

  /**
    * checks for httpbody:
    * 'm=test&a=create&n=MyUsername&p=MyMassword&e=me@mydomain.com'
    * returns jsonString:
    * {"model":"test","action":"create","success":"true","message":"Record Created"}
    **/

  public function create()
  {

    // make sure a parameter is set for name
    if ($n = Req::val('n')) {

      $mdl = TestMdl::shared();
      
      // make sure record does not already exist
      if ($tst = $mdl->fetchAssocByName($n)) {
      
        $this->response['message'] = 'Name already exists.';
      
      } else {

          // make sure parameter is set for password
		  if ($p = Req::val('p')) {
	  
	        // make sure parameter is set for email
			if ($e = Req::val('e')) {
		
			  $assoc = array(
				'name' => $n,
				'password' => sha1($p),
				'email' => $e
			  );
					
			  $id = $mdl->insertAssoc($assoc);
		  
			  $this->response['id'] = strval($id);
			  $this->response['success'] = 'true';
			  $this->response['message'] = 'Account Created. Please Log In.';
		
			} // ./email was set
		
			else {
			  $this->response['message'] = 'Email parameter cannot be null';
			} // ./email not set
	  
		  }
	  
		  else {
			$this->response['message'] = 'Password parameter cannot be null';
		  } // ./password not set
      
      } // ./name already exists

    } // ./name is set
    
    else {
      $this->response['message'] = 'Name parameter cannot be null';
    } // ./name not set

  } // ./create

  /**
    * checks for httpbody:
    * 'm=test&a=authenticate&n=MyUsername&p=MyMassword'
    * returns jsonString:
    * {"model":"test","action":"authenticate","success":"true","message":"Authentication Successful","token":"a419195fc1a20fb1dc434d3babb0d606"}
    **/

  public function authenticate()
  {

    if ($n = Req::val('n')) {
      // name is set
      if ($p = Req::val('p')) {
        
        $mdl = TestMdl::shared();
        
        if ($assoc = $mdl->fetchAssocByName($n)) {
        
          if ( sha1($p) == $assoc['password'] ) {
          
            $this->response['success'] = 'true';
            $this->response['message'] = 'Authentication Successful';
            
            // also need to provide response with a token
            $tokenCtl = new TokenCtl();
            $this->response['token'] = $tokenCtl->createToken('test',$assoc['id']);
            
          } // ./password match
          
          else {
            $this->response['message'] = 'Password does not match';
          } // ./password did not match
        
        } // ./record for name was found
        
        else {
          $this->response['message'] = 'Name was not found';
        } // ./record for name was not found
        
      } // ./password set
      
      else {
        $this->response['message'] = 'Password was not set';
      } // ./password not set
      
    } // ./name was set
    
    else {
      $this->response['message'] = 'Name was not set';
    } // ./name was not set

  }

  public function dearth()
  {
    $this->response['message'] = 'Invalid action parameter';
  }

  public function update()
  {
    // make sure we have a token
    if ($t = Req::val('t')) {
      
      $tkn = TokenMdl::shared();
      
      if ($tkn_rec = $tkn->fetchAssocByName($t)) {
      
        $id = $tkn_rec['test_id'];
        
        $mdl = TestMdl::shared();
        
        $assoc = $mdl->fetchAssocById($id);
        
        // now we need to see if any parameters can be updated
        $updated = array();
        
        if ($p = Req::val('p')) {
          $assoc['password'] = sha1($p);
          array_push($updated, 'Password');
        }
      
        if ($e = Req::val('e')) {
          $assoc['email'] = $e;
          array_push($updated, 'Email');
        }
        
        $mdl->updateAssoc($assoc);
        
        $this->response['success'] = 'true';
        if (count($updated) > 1) {
          $this->response['message'] = implode(',', $updated).' Updated';
        } elseif (count($updated) == 1) {
          $this->response['message'] = $updated[0].' Updated';
        } else {
          $this->response['message'] = 'Nothing Updated';
        }
      
      } // ./token exists
      
      else {
      
        $this->response = 'Token has expired';
      
      } // ./token does not exist
      
    } // ./token is set
    
    else {
      $this->response['message'] = 'Auth token is required for this action';
    } // ./token not set
  }

  function logout()
  {

    // whatever the case our token value will be "false"
    $this->response['token'] = 'false';

    // make sure we have an id
    if ($i = Req::val('i')) {
    
		// make sure we have a token
		if ($t = Req::val('t')) {
	  
		  $tkn = TokenMdl::shared();
	  
		  // make sure token exists
		  if ($assoc = $tkn->fetchAssocByName($t)) {
		  
		    // make sure user_id matches user_id in token
		    if (intval($i) == $assoc['test_id']) {
		      $tkn->deleteAssoc($t);
              $this->response['success'] = 'true';
              $this->response['message'] = 'Logged Out';
		    } // ./id matches

		    else {
              $this->response['messsage'] = 'Unauthorized action';
		    } // .id did not match

		  } // ./token exists

          else {
          
          } // ./token does not exist
          			
		} // ./token is set
    
    } // ./id is set

    else {
    
    } // ./id not set

  }

}
