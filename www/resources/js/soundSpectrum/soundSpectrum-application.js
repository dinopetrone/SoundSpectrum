var SounSpectrum = SounSpectrum || {};

SounSpectrum.Application = function() {
	var self = {};
	var soundPath = 'resources/mp3/song.mp3';
	var jsonPath = 'resources/json/json.txt';
	var audioElement;
	var jsonData;
	var soundInterval;
	var audioElement;
	var goBtn = $('#go');
	function __new__() {
	}

	function __init__() {
		loadJson();
		goBtn.hide();
		$('.container').hide();
		goBtn.bind("click", onGoPress);
	}

	function loadJson() {
		$.ajax({
			url : jsonPath,
			dataType : 'json',
			success : onjsonLoaded
		});
	}

	function onjsonLoaded(data) {
		jsonData = data;
		goBtn.show();
	}

	function onGoPress() {
		$('.container').show();
		goBtn.hide();
		startSound();
		startInterval();
	}

	function startSound() {
		audioElement = new Audio();
		audioElement.src = soundPath;
		audioElement.play();
	}

	function startInterval() {
		soundInterval = setInterval(intervalTick, 100);
	}

	function intervalTick() {
		var ms = Math.floor(audioElement.currentTime * 1000);
		if(ms < 0)
			return;
		ms = Math.round(ms / 100) * 100;
		ms += 100;
		var currentSpectrum = jsonData[ms];
		if(!currentSpectrum)
			return;
		animateDisplay(currentSpectrum);
		return;
		if(audioElement.currentTime > 5) {
			audioElement.pause();
			clearInterval(soundInterval);
		}
	}

	function animateDisplay(spectrum) {
		$('.circle').each(function(index) {
			var initScale = spectrum[index * 5];
			var scale = initScale;
			scale = Math.floor(scale * 2000);
			scale = -Math.max(0,scale);
			var easingFunction = '';
			this.style.webkitTransition = '-webkit-transform ' + 250 + "ms " + easingFunction;
			this.style.webkitTransform = "translate3d(0px, 0px, "+scale+"px)";
			/*
			var redShade = Math.max(0, initScale);
			redShade = Math.floor(redShade * 255);
			redShade = redShade.toString(16);
			this.style.background = "#" + redShade + "0000";
			*/
		})
		
	}

	__new__();
	__init__();

	return self;
}
$(function() {
	SounSpectrum.Application();
});
