Meteor.loginWithFriendly = function (selector, callback) {
	if (typeof selector != 'string')
		return;
	var index = selector.indexOf('@');
	if (index === -1)
		selector = {username: selector, email: selector + '@blg.com'};
	else
		selector = {username: selector.substring(0, index), email: selector};
	selector.profile = {friendly: true};

	Accounts.callLoginMethod({
		methodArguments: [{
			user: selector
		}],
		userCallback: function (error) {
			if (error) {
				callback && callback(error);
			} else {
				callback && callback();
			}
		}
	});
};