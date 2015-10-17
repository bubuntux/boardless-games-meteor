@LoveLetters = new Mongo.Collection('love_letters')

@LoveLettersCards =
  Guard:
    value: 1
    amount: 5
    shortDesc: "Guess a player's hand"
    longDesc: "Name a non-Guard card and choose another player. If that player has that card he or she is out of the round"
  Priest:
    value: 2
    amount: 2
    shortDesc: "Look at a hand"
    longDesc: "Loog at another player's hand"
  Baron:
    value: 3
    amount: 2
    shortDesc: "Compare hands; lower hand is out"
    longDesc: "You and another player secretly compare hands. The player with the lower value is out of the round"
  Handmaid:
    value: 4
    amount: 2
    shortDesc: "Protection until your next turn"
    longDesc: "Until your next turn, ignore all effects from other player's cards"
  Prince:
    value: 5
    amount: 2
    shortDesc: "One player discards his or her hand"
    longDesc: "Choose any player (including yourself) to discard his or her hand and draw a new card"
  King:
    value: 6
    amount: 1
    shortDesc: "Trade hands"
    longDesc: "Trade hands with another player of your choice"
  Countess:
    value: 7
    amount: 1
    shortDesc: "Discard if caught with King or Prince"
    longDesc: "If you have this card and the King or Prince in your hand, you must discard this card"
  Princess:
    value: 8
    amount: 1
    shortDesc: "Lose if discarded"
    longDesc: "If you discard this card, you are out of the round"

_allCards = ->
  cards = []
  for cardName, card of LoveLettersCards
    _.times(card.amount, -> cards.push(card))
  cards

@LoveLettersDescription =
  name: 'Love Letters'
  minPlayers: 2
  maxPlayers: 4
  initGame: (gameKey, players) ->
    remainCards = _.shuffle _allCards()
    discarded = remainCards.shift()
    order = 0
    for player in players
      player.order = order++
      player.cards = [remainCards.shift()]
      player.protected = false
      player.victories = 0
    LoveLetters.upsert gameKey,
      $set:
        _id: gameKey
        players: players
        remainCards: remainCards
        discarded: discarded
        playedCards: []
  data: (gameKey) ->
    LoveLetters.findOne(gameKey)

Meteor.methods
  love_letters_play: (gameKey, card, otherPlayer, guessCard) ->
    game = LoveLetters.findOne gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    player = _.find game.players, (p) -> p.cards?.length is 2
    if player.id isnt Meteor.userId()
      throw new Meteor.Error "not your turn buddy"


# check if card is valid
#