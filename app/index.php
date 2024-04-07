<?php
require './../vendor/autoload.php';
$person = new \App\Person("Nandan", "Pandey");

echo "<h3>$person->first_name</h3>";