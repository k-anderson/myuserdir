#!/usr/bin/php

<?php

array_shift($argv);

foreach($argv as $key => $value) {
    $param = explode("=", trim(str_replace(",", "", $value)));
    $$param[0] = $param[1]; 
    echo "$param[0] = $param[1]\n";
}

if(empty($username)) {
    echo "Please enter the username: ";
    $username = trim(fgets(STDIN));
}

if(empty($password)) {
    echo "Please enter the password: ";
    $password = trim(fgets(STDIN));
}

if(empty($realm)) {
    echo "Please enter the realm: ";
    $realm = trim(fgets(STDIN));
}

if(empty($nonce)) {
    echo "Please enter the nonce: ";
    $nonce = trim(fgets(STDIN));
}

if(empty($uri)) {
    echo "Please enter the uri: ";
    $uri = trim(fgets(STDIN));
}

if(empty($qop)) {
    echo "Please enter the qop: ";
    $qop = trim(fgets(STDIN));
}

if(empty($method)) {
    echo "Please enter the method: ";
    $method = strtoupper(trim(fgets(STDIN)));
}

$HA1 = md5("$username:$realm:$password");
$HA2 = md5("$method:$uri");

if ($qop == "auth") {

    if(empty($cnonce)) {
        echo "Please enter the client nonce: ";
        $cnonce = trim(fgets(STDIN));
    }

    if(empty($nc)) {
        echo "Please enter the nonce count: ";
        $nc = trim(fgets(STDIN));
    }

    echo "Response ($qop): " .md5("$HA1:$nonce:$nc:$cnonce:$qop:$HA2") ."\n";

} else {
    echo "Response (unknown): " .md5("$HA1:$nonce:$HA2") ."\n";
}
