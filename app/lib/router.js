"use strict";
Router.route('/', {
	name: 'home',
	layoutTemplate: 'layout',
	template: 'home',
	data: function () {
		return Boards.find({}); //TODO subscribe?
	}
});

Router.route('/game/:id', function () {
	let board = Boards.findOne({_id: this.params.id}); //TODO wait on??
	if (!board || !Meteor.userId()) {
		console.log("redirecting");
		this.redirect('home');
		return;
	}

	if (board.started) {
		this.render('game', {
			data: board //TODO
		});
		return;
	}

	this.render('join', {
		data: board //TODO
	});
}, {
	name: 'game',
	layoutTemplate: 'layout'
});