//TODO collections 2 ?
TraitorPlayers = new Mongo.Collection('traitorPlayers');

TraitorGames = new Mongo.Collection('traitorGames');

TraitorConstant = {
    MAX_MISSIONS: 5,
    MISSIONS_TO_WIN: 3,
    MIN_PLAYERS: 5,
    MAX_PLAYERS: 10,
    MAX_DISTRUST_LEVEL: 5,
    TRAITOR_DIVISOR: 3,
    PLAYERS_PER_ROUND: {
        5: [2, 3, 2, 3, 3],
        6: [2, 3, 4, 3, 4],
        7: [2, 3, 3, 4, 4],
        8: [3, 4, 4, 5, 5],
        9: [3, 4, 4, 5, 5],
        10: [3, 4, 4, 5, 5]
    },
    PLAYERS_PER_ROUND2: {
        5: {1: 2, 2: 3, 3: 2, 4: 3, 5: 3}
    }
};

TraitorGameState = {
    PLAYER_SELECTION: 1,
    MISSION_VOTING: 2,
    ON_MISSION: 3,
    VICTORY: 4,
    GAME_OVER: 5
};