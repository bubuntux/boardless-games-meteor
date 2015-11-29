"use strict";
Template.login.events({
	"click #enter": function (event) {
		event.preventDefault();
		var user = $('#user')[0].value;
		Meteor.loginWithFriendly(user, function (error) {
			if (error) {
				alert(error);
			}
		});
	}
});