"use strict";
Router.route('/', {
	name: 'home',
	layoutTemplate: 'layout',
	template: 'home'
});

Router.route('/join', {
	name: 'join',
	layoutTemplate: 'layout',
	template: 'join'
});