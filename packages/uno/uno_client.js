//unoSome = {some: "asfasf"};
//GAMES.push('sdfsdf');
"use strict";

class Card {
	constructor(color, value) {
		this.color = color;
		this.value = value;
	}
}

const deck = function () {
	let cards = _.times(4, new Card('black', '+4'));
	cards.push(_.times(4, new Card('black', 'any')));
	_.forEach(['red', 'blue', 'green', 'yellow'], function (color) {
		cards.push(new Card(color, 0));
		_.forEach(_.range(1, 10), function (value) {
			cards.push(_.times(2, new Card(color, value)));
		});
		cards.push(_.times(2, new Card(color, '+2')));
		cards.push(_.times(2, new Card(color, 'skip')));
		cards.push(_.times(2, new Card(color, 'reverse')));
	});
	return cards;
};

startGame = function (game) {
	game.deck = _.shuffle(deck());
	_.forEach(game.players, function (player) {
		player.cards = _.times(7, game.deck.pop());
	});
	game.card = game.deck.pop();
	//TODO update game
};

playCard = function (card) {
	let userId = Meteor.userId();
	if (!userId) {
		throw new Meteor.Error("not-authorized");
	}
	let game; //TODO get game
	
};