Package.describe({
	name: 'dixit',
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
	api.use('ecmascript');
	api.use('erasaur:meteor-lodash');

	api.addFiles('dixit_common.js', ['server', 'client']);
	api.addFiles('dixit_server.js', 'server');
	api.addFiles('dixit_client.js', 'client');
	for (var i = 1; i <= 450; i++) { //TODO get from common?
		api.addAssets('img/' + i + '.jpg', 'client');
	}

	//TODO export
});

Package.onTest(function (api) {
	api.use('ecmascript');
	api.use('dixit');
	api.use('tinytest');

	//api.addFiles('dixit-tests.js');
});
