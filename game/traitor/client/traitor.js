Template.traitorHtml.helpers({
    playersPerMission: function (mission) {
        return TraitorConstant.PLAYERS_PER_ROUND2[this.players.length][mission];
    }
});