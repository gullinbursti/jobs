<?php header("access-control-allow-origin: *");

// db creds
define('DB_HOST', "external-db.s4086.gridserver.com");
define('DB_NAME', "db4086_modd");
define('DB_USER', "db4086_modd_usr");
define('DB_PASS', "f4zeHUga.age");


// make the connection
$db_conn = mysql_connect(DB_HOST, DB_USER, DB_PASS) or die("Could not connect to database");

// select the proper db
mysql_select_db(DB_NAME) or die("Could not select database");


// select all viewers more than 5 days old
$query = 'SELECT `id`, `username`, `email` FROM `users` WHERE `type` = "viewer" AND `email` != "" AND `added` > DATE_SUB(NOW(), INTERVAL 5 DAY) LIMIT 1;';
$result = mysql_query($query);

// loop thru
while ($user_obj = mysql_fetch_object($result)) {

	// change type to streamer
	$query = 'UPDATE `users` SET `type` = "streamer", `beta_code` = "590ef96252f888af5bc167c3" WHERE `id` = '. $user_obj->id .' LIMIT 1;';
	//$r = mysql_query($query);

	// send email
	//$to      = $user_obj->email;
	$to      = "matt.holcombe@gmail.com";
	$subject = "Welcome to MODD";
	$message = "Yo, Yo!\r\n\r\nYour account has been approved for beta :)\r\nUse this link for access: http://beta.modd.live/insights.html?c=590ef96252f888af5bc167c3\r\n\r\nCheers,\r\nJason & TeamMODD\r\n\r\nJason Festa\r\nCEO & Co-Founder\r\nMODD\r\n";
	$headers = 'From: MODD Feedback <feedback@modd.live>' . "\r\n" . 'Reply-To: feedback@modd.live' . "\r\n" . 'X-Mailer: PHP/' . phpversion();
        mail($to, $subject, $message, $headers);
}


// connection open
if ($db_conn) {

	// so close it!
	mysql_close($db_conn);
	$db_conn = null;
}

?>
