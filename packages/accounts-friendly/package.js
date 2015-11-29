Package.describe({
	name: 'accounts-friendly',
	version: '0.0.1',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '', //TODO publish as separate project
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function (api) {
	api.versionsFrom('1.2.1');
	api.use('accounts-password'); //TODO use base
	api.use('erasaur:meteor-lodash'); //TODO remove
	api.addFiles('accounts-friendly.js', 'client');
});