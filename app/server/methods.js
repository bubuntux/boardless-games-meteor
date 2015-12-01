"use strict";
Meteor.methods({
	'createGame': function (gameName) {
		check(gameName, String);
		if (!gameName) {
			throw new Meteor.Error("Invaid game");
		}

		let user = Meteor.user();
		if (!user) {
			throw new Meteor.Error("not-authorized");
		}

		let boardId = user._id;
		let board = {
			_id: boardId,
			name: user.username + "'s " + gameName + " game",
			gameName: gameName,
			players: [{id: user._id, name: user.username}],
			minPlayers: GAME[gameName].minPlayers,
			maxPlayers: GAME[gameName].maxPlayers
		};
		Boards.remove(boardId, function (error) {
			if (error) {
				throw error;
			}
		});
		Boards.insert(board, function (error) {
			if (error) {
				throw error;
			}
		});
		return boardId;
	}
});
