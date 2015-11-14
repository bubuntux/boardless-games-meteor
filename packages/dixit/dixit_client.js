/*
startGame = (game, players)->
  cards = _.shuffle(CARDS)

  for player in _.shuffle(players)
    player.points = 0
    player.cards = Array(CARDS_PER_PLAYER)
    i = 0
    player.cards[i++] = cards.pop() while i < CARDS_PER_PLAYER
  game.cards = cards
  game.turn = 0
*/
