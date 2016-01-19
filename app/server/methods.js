"use strict";
Meteor.methods({
	'createGame': function (gameName) {
		check(gameName, String);
		if (!gameName) {
			throw new Meteor.Error("Invalid game");
		}

		let user = Meteor.user();
		if (!user) {
			throw new Meteor.Error("not-authorized");
		}

		let boardId = user._id;
		let board = {
			_id: boardId,
			name: user.username + "'s game", //TODO
			gameName: gameName,
			players: [{id: user._id, name: user.username}],
			minPlayers: GAME[gameName].minPlayers, //TODO ??
			maxPlayers: GAME[gameName].maxPlayers  //TODO ??
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
	},

	'joinGame': function (gameId) {
		check(gameId, String);
		let user = Meteor.user();
		if (!user) {
			throw new Meteor.Error("not-authorized");
		}
		let board = Boards.findOne({_id: gameId});
		if (!board) {
			throw new Meteor.Error('Game does not exist');
		}
		if (board.players.length >= board.maxPlayers) {
			throw new Meteor.Error('Game already full');
		}
		Boards.update({_id: gameId}, {
			$addToSet: {
				players: {
					id: user._id, name: user.username
				}
			}
		}, function (error) {
			if (error) {
				throw error;
			}
			Boards.remove(user._id);
		});
	},

	'startGame': function () {
		let gameId = Meteor.userId();
		if (!gameId) {
			throw new Meteor.Error("not-authorized");
		}
		let board = Boards.findOne({_id: gameId});
		if (!board) {
			throw new Meteor.Error('Game does not exist');
		}


		Boards.update(gameId, {$set: {started: true}});
	}
});
