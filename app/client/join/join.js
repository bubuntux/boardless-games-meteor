"use strict";
Template.join.helpers({
	canStartTheGame: function () {
		return Meteor.userId() === this._id &&
			this.players.length >= this.minPlayers && this.players.length <= this.maxPlayers;
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
				alert(error);
			}
		});
	},

	'click #start': function (event) {
		event.preventDefault();
		Meteor.call('startGame', function (error) {
			if (error) {
				alert(error);
			}
		});
	}
});