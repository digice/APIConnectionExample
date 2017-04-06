<?php

/** mvc autoloader **/

$lib = __DIR__.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR;

$di = new DirectoryIterator($lib);

foreach ($di as $item) {

  $fn = $item->getFilename();
  
  if (substr($fn, 0, 1) != '.') {
    require_once($lib.$fn);
  }
  
}
