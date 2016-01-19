Package.describe({
	name: 'blg-core',
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
	api.use('stevezhu:lodash');

	api.imply('ecmascript');
	api.imply('stevezhu:lodash');

	api.addFiles('blg-core.js');

	api.export('GAMES');
});

Package.onTest(function (api) {
	api.use('ecmascript');
	api.use('tinytest');
	api.use('blg-core');
	api.addFiles('blg-core-tests.js');
});
