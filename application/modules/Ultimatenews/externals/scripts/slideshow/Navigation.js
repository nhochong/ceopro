var navSlideShow;
document.addEvent('domready', function(){
	// cache the navigation elements
	var navs = $('news_pagination').getElements('a');

	// create a basic slideshow
	navSlideShow = new SlideShow('news_navigation-slideshow', {
		autoplay: true,
		delay: 5000,
		duration:1000,
		transition: 'fadeThroughBackground',
		selector: 'span',
		onShow: function(data){
			// update navigation elements' class depending upon the current slide
			navs[data.previous.index].removeClass('current');
			navs[data.next.index].addClass('current');
		}
	});

	navs.each(function(item, index){
		// click a nav item ...
		item.addEvent('click', function(event){
			event.stop();
			// pushLeft or pushRight, depending upon where
			// the slideshow already is, and where it's going
			var transition = (navSlideShow.index < index) ? 'fadeThroughBackground' : 'fadeThroughBackground';
			// call show method, index of the navigation element matches the slide index
			// on-the-fly transition option
			navSlideShow.show(index, {transition: transition});
		});
	});
	var list_middle = $$('.layout_main .layout_middle');
	var position = list_middle[0].getCoordinates();
    var slideWidth = position.width;
    $('news_navigation-slideshow').style.width = slideWidth + "px";
});