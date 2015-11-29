"use strict";
Template.layout.events({
	"click .logout": function (event) {
		event.preventDefault();
		Meteor.logout();
	}
});