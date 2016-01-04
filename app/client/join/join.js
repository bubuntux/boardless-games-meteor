"use strict";
Template.join.helpers({
	canStartTheGame: function () {
		return Meteor.userId() === this._id;
	},
	canJoin: function () {
		return !_.find(this.players, function (player) {
			return player.id === Meteor.userId();
		});
	}
});

Template.join.events({
	'click #join': function (event) {
		event.preventDefault();
		Meteor.call('joinGame', this._id, function (error) {
			if (error) {
				throw error;
			}
		});
	},

	'click #start': function (event) {
		event.preventDefault();

	}
});