if (!window.initializeAdvAlbumJS) {
	var initializeAdvAlbumJS = true;

	var cmd_down = false;
	var ctrl_down = false;

	window.addEvent('keydown', function(e) {
		if (e.code == 224) {
			cmd_down = true;
		}
		if (e.code == 17) {
			ctrl_down = true;
		}
	});

	window.addEvent('keyup', function(e) {
		if (e.code == 224) {
			cmd_down = false;
		}
		if (e.code == 17) {
			ctrl_down = false;
		}
	});

	function photoPopupView(linkItem) {
		if (cmd_down || ctrl_down || !linkItem || !linkItem.href)
			return true;
		if (linkItem.href.indexOf('/photo/view/album_id/') == -1)
			return true;
		photoViewURL = linkItem.href.replace('/photo/view/album_id/', '/photo/popupview/album_id/');
		var widthscreen = window.getSize().x;
		TINY.box.show({
			iframe : photoViewURL,
			width : widthscreen,
			height : 1062,
			fixed : false,
			maskid : 'bluemask',
			maskopacity : 40,
			closejs : function() {
			}
		});
		return false;
	}

	function popupSlideshow(slideshowURL)
	{
		var widthscreen = window.getSize().x;
		if (widthscreen > 720)
			widthscreen = 720;

		TINY.box.show({
			iframe : slideshowURL,
			width : widthscreen,
			height : 572,
			fixed : false,
			maskid : 'bluemask',
			maskopacity : 40,
			closejs : function() {
			}
		});
		return false;
	}

	function popupMobileSlideshow(slideshowURL) {

		TINY.box.show({
			iframe : slideshowURL,
			fixed : false,
			maskid : 'bluemask',
			maskopacity : 40,
			closejs : function() {
			}
		});
		return false;
	}

	function featureSlideshow(slideshowURL) {
		TINY.box.show({
			iframe : slideshowURL,
			width : 1100,
			height : 505,
			fixed : false,
			maskid : 'bluemask',
			maskopacity : 40,
			closejs : function() {
			}
		});
		return false;
	}

	function addSmoothboxEvents() {
		$$('a.advalbum_smoothbox').each(function(el) {
			el.removeEvents('click').addEvent('click', function(event)
			{
				// remove click mobile version
				if (window.innerWidth < 1210 )
				{
					window.open( $(this).get('href'), '_self' );
					return false;
				}
				event.stop();
				Smoothbox.open(this);
				if (Smoothbox.instance) {
					Smoothbox.instance.addEvent('load', function(e)
					{
						if(window.parent.$('TB_window').getElement('iframe').contentDocument.getElements('.ynadvalbum_view_photo_popup').length) {
							Smoothbox.instance.content.setStyles({
								'margin-bottom' : -9,
								'margin-top' : 0,
								'height': 600
							});
							window.parent.$('TB_window').setStyle('border', 'none');
						} else {
							window.parent.$('TB_window').setStyle('height', '100px');	
						}
					});
				}
			});
		});
	}


	window.addEvent('load', function(e) {
		addSmoothboxEvents();
	});

	function setAlbumCover(photo_id, album_id) {

	}

	function disableEnterKey(e) {
		var key;
		//if the users browser is internet explorer
		if (window.event) {
			//store the key code (Key number) of the pressed key
			key = window.event.keyCode;
			//otherwise
		}
		else {
			//store the key code (Key number) of the pressed key
			key = e.which;
		}
		//if key 13 is pressed (the enter key)
		if (key == 13) {
			return false;
		}
		else {
			//continue as normal (allow the key press for keys other than "enter")
			return true;
		}
	}

	function openLocation(url) {
		window.open(url, '_blank');
	}

	(function($,$$){
		var events;
		var check = function(e){
			var target = $(e.target);
			var parents = target.getParents();
			events.each(function(item){
				var element = item.element;
				if (element != target && !parents.contains(element))
					item.fn.call(element, e);
			});
		};
		Element.Events.outerClick = {
			onAdd: function(fn){
				if(!events) {
					document.addEvent('click', check);
					events = [];
				}
				events.push({element: this, fn: fn});
			},
			onRemove: function(fn){
				events = events.filter(function(item){
					return item.element != this || item.fn != fn;
				}, this);
				if (!events.length) {
					document.removeEvent('click', check);
					events = null;
				}
			}
		};
	})(document.id,$$);

	function ynadvalbumOptions() {
		$$('.ynadvalbum-options-button-popup').addEvent('click', function() {
			var show = $$('.ynadvalbum_dropdown_items').getStyle('display');
			if(show=='none'){
				$$('.ynadvalbum_dropdown_items').setStyle('display', 'block');
			} else {
				$$('.ynadvalbum_dropdown_items').setStyle('display', 'none');
			}
		});
		$$('.ynadvalbum-options-button').removeEvents('click').addEvent('click', function (event) {
			var parent = this.getParent(),
				items = this.getSiblings('.ynadvalbum_dropdown_items');
			this.toggleClass('ynadvalbum_explained');
			parent.toggleClass('ynadvalbum_show');
			items.setStyle('display', items.getStyle('display') == 'block' ? 'none' : 'block');

			var popup = this.getParent('.ynadvalbum-options');
			window.setTimeout(function(){
				var layout_parent = popup.getParent('.ynadvalbum-grid-list') || popup.getParent('.photo-pinterest-view') || popup.getParent('.layout_middle');
			var y_position = popup.getPosition(layout_parent).y;
			var p_height = layout_parent.getHeight();
			var c_height = popup.getElement('.ynadvalbum_dropdown_items').getHeight();
			if (parent.hasClass('ynadvalbum_show')) {
				if (p_height - y_position < (c_height + 60)) {
					layout_parent.addClass('popup-padding-bottom');
					var margin_bottom = parseInt(layout_parent.getStyle('padding-bottom').replace(/\D+/g, ''));
					layout_parent.setStyle('padding-bottom', (margin_bottom + c_height + 60 + y_position - p_height) + 'px');
				}
			} else {
				layout_parent.setStyle('padding-bottom', '0');
			}
			}, 20);
		});

		$$('.ynadvalbum-options-button').addEvent('outerClick', function () {
			if (!this.hasClass('ynadvalbum_explained'))
				return;
			var popup = this.getParent('.ynadvalbum-options');
			var items = this.getSiblings('.ynadvalbum_dropdown_items');
			this.removeClass('ynadvalbum_explained');
			popup.removeClass('ynadvalbum_show');
			items.setStyle('display', 'none');
			var layout_parent = popup.getParent('.ynadvalbum-grid-list') || popup.getParent('.photo-pinterest-view') || popup.getParent('.layout_middle');
			layout_parent.setStyle('padding-bottom', '0');
		});
	}
}
