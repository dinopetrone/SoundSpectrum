<html>
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="resources/js/soundSpectrum/soundSpectrum-application.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" href="resources/css/styles.css" type="text/css" media="screen" title="no title" charset="utf-8"/>
		<title>Sound Spectrum</title>
	</head>
	<body>
		<button id="go">Go!</button>
		<div class="container">
		<?php 
			for ($i=0; $i < 50; $i++) { 
				echo '<div class="circle" id="dot'.$i.'"></div>'; 
			}
		?>
		</div>
	</body>
</html>