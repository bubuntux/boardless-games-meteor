Package.describe({
	name: 'uno',
	version: '0.0.1',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function (api) {
	api.versionsFrom('1.2.1');

	api.use('blg-core');

	//api.addFiles('uno_client.js');

	['blue', 'green', 'red', 'yellow'].forEach(function (color) {
		for (var i = 0; i <= 9; i++) {
			api.addAssets('img/' + color + '/' + i + '.png', 'client');
		}
		api.addAssets('img/' + color + '/+2.png', 'client');
		api.addAssets('img/' + color + '/skip.png', 'client');
		api.addAssets('img/' + color + '/reverse.png', 'client');
	});
	api.addAssets('img/black/+4.png', 'client');
	api.addAssets('img/black/any.png', 'client');

	//api.export('unoSome');
});

/*
 Package.onTest(function (api) {
 api.use('ecmascript');
 api.use('tinytest');
 api.use('uno');
 api.addFiles('uno-tests.js');
 });
 */
