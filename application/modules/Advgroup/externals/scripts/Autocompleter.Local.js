/**
 * Autocompleter.Local
 *
 * http://digitarald.de/project/autocompleter/
 *
 * @version		1.1.2
 *
 * @license		MIT-style license
 * @author		Harald Kirschner <mail [at] digitarald.de>
 * @copyright	Author
 */

Autocompleter2.Local = new Class({

	Extends: Autocompleter2,

	options: {
		minLength: 0,
		delay: 200
	},

	initialize: function(element, tokens, options) {
		this.parent(element, options);
		this.tokens = tokens;
	},

	query: function() {
		this.update(this.filter());
	}

});