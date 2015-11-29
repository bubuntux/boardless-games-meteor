"use strict";
Router.route('/', {
	name: 'home',
	layoutTemplate: 'layout',
	template: 'home',
	onBeforeAction: function () {
		if (!Meteor.userId()) {
			this.render('login');
			return;
		}
		this.next();
	}
});