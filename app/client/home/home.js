"use strict";
let _createGame = function (template) {
	let gameName = template.$('#gameName').val();
	Meteor.call('createGame', gameName, function (error, boardId) {
		if (error) {
			throw error;
		}
		Router.go('game', {id: boardId});
	});
};

Template.home.events({
	"click #create": function (event, template) {
		event.preventDefault();
		if (!Meteor.userId()) {
			template.$('#loginModal').modal('show');
			return;
		}
		_createGame(template);
	},

	"click #login": function (event, template) {
		event.preventDefault();
		var username = template.$('#username').val();
		Meteor.loginWithFriendly(username, function (error) {
			if (error) {
				alert(error);
				return;
			}
			template.$('#loginModal').modal('hide');
		});
	},

	"click #join": function (event, template) {
		if (!Meteor.userId()) {
			template.$('#loginModal').modal('show');
			event.preventDefault();
		}
	}
});