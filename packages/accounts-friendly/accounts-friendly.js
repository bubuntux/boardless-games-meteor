"use strict";
Meteor.loginWithFriendly = function (username, callback) {
	if (typeof username != 'string')
		return;

	username = _.capitalize(_.snakeCase(username));
	Accounts.callLoginMethod({
		methodName: 'createUser',
		methodArguments: [{
			username: username,
			email: username + '@blg.com',
			profile: {friendly: true},
			password: username
		}],
		userCallback: function (error) {
			if (error) {
				Accounts.callLoginMethod({
					methodArguments: [{
						user: {username: username},
						password: username
					}],
					userCallback: function (error) {
						if (error) {
							callback && callback(error);
						} else {
							callback && callback();
						}
					}
				});
			} else {
				callback && callback();
			}
		}
	});
};