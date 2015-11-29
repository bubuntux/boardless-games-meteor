"use strict";
Template.login.events({
	"click #enter": function (event) {
		event.preventDefault();
		var user = $('#user')[0].value;
		Meteor.loginWithFriendly(user, function (error, result) {
			if (error) {
				console.log(error);
			} else {
				console.log(result);
			}
		});
	}

});