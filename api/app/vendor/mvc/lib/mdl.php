<?php

abstract class Mdl
{

  protected $name;
  
  protected $fields;
  
  protected $dir_path;

  // you must set the name in extended class before calling parent::__construct()
  public function __construct()
  {
    $this->dir_path = dirname(dirname(dirname(__DIR__))).DIRECTORY_SEPARATOR.'var'.DIRECTORY_SEPARATOR.$this->name.DIRECTORY_SEPARATOR;
    $this->id_path = $this->dir_path.'int'.DIRECTORY_SEPARATOR.'id';
  }

  /**
   * @return *int* next unused id
   */
  public function nextId()
  {
    $id = intval(file_get_contents($this->id_path)) + 1;
    file_put_contents($this->id_path, strval($id));
    return $id;
  }

  /**
   * @param  *int* id
   * @return *assoc* record for id
   *         false if record is not found
   */
  public function fetchAssocById($id)
  {

    $path = $this->dir_path.'row'.DIRECTORY_SEPARATOR.$id;

    if (file_exists($path)) {
      return unserialize(file_get_contents($path));
    } else {
      return false;
    }
  }

  /**
   * @param  *str* name value
   * @return *assoc* record for name
   *         false if record is not found
   */
  public function fetchAssocByName($name)
  {
    
    $idx_lines = explode( PHP_EOL, file_get_contents( $this->dir_path.'idx'.DIRECTORY_SEPARATOR.'id_name' ) );
    
    foreach ($idx_lines as $idx_line) {
      if (strlen($idx_line) > 0) {
        $idx_row = explode(',', $idx_line);
        if ($idx_row[1] == md5($name)) {
          return $this->fetchAssocById($idx_row[0]);
        }
      }
    }
    
    return false;

  }

  /**
   * @param  *assoc* to be inserted
   * @return *id* for record
   *         false if record was not created
   */
  public function insertAssoc($assoc)
  {
    $assoc['id'] = $this->nextId();
    $path = $this->dir_path.'row'.DIRECTORY_SEPARATOR.strval($assoc['id']);
    $csv = strval($assoc['id']).','.md5($assoc['name']).PHP_EOL;
    file_put_contents( $path, serialize($assoc) );
    file_put_contents( $this->dir_path.DIRECTORY_SEPARATOR.'idx'.DIRECTORY_SEPARATOR.'id_name', $csv, FILE_APPEND );
    return $assoc['id'];
  }

  /**
   * @param  *str* assoc_key
   * @param  *str* value to match
   * @return *array* of assocs
   * (array is empty if no records are found)
   */
  public function fetchAssocsByKeyAndValue($key,$value)
  {
    $assocs = array();
    $di = new DirectoryIterator($this->dir_path.'row');
    foreach ($di as $item) {
      $id = $item->getFilename();
      if (substr($fn, 0, 1) != '.') {
        $assoc = $this->fetchAssocById($id);
        if (isset($assoc[$key])) {
          if ($assoc[$key] == $value) {
            array_push($assocs, $assoc);
          }
        }
      }
    }
    return $assocs;
  }

  /**
   * @param  *assoc*
   * @return *void*
   */
  public function updateAssoc($assoc) {
    $path = $this->dir_path.'row'.DIRECTORY_SEPARATOR.strval($assoc['id']);
    file_put_contents( $path, serialize($assoc) );
  }

  public function deleteAssoc($name) {
  
    $assoc = $this->fetchAssocByName($name);
    $path = $this->dir_path.'row'.DIRECTORY_SEPARATOR.strval($assoc['id']);
    file_put_contents($path, '');
    
    // @TODO: implement updating of index

  }

}
