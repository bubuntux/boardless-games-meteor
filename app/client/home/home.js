"use strict";
let _createGame = function (template) {
	let gameName = template.$('#gameName').val();
	Meteor.call('createGame', gameName, function (error, boardId) {
		if (error) {
			throw error;
		}
		Router.go('join');
	});
};

Template.home.events({
	"click #create": function (event, template) {
		event.preventDefault();
		if (!Meteor.userId()) {
			template.$('#createGameModal').modal('show');
			return;
		}
		_createGame(template);
	},

	"click #loginAndCreate": function (event, template) {
		event.preventDefault();
		var username = template.$('#username').val();
		Meteor.loginWithFriendly(username, function (error) {
			if (error) {
				alert(error);
				return;
			}
			_createGame(template);
		});
	}
});