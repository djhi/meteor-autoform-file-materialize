Package.describe({
  name: "gildaspk:autoform-file-materialize",
  summary: "File upload for AutoForm with Materialize",
  description: "File upload for AutoForm with Materialize",
  version: "0.0.1",
  git: "http://github.com/djhi/meteor-autoform-file-materialize.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'aldeed:autoform@4.2.2'
    ],
    'client');

  api.add_files('lib/client/autoform-file.html', 'client');
  api.add_files('lib/client/autoform-file.less', 'client');
  api.add_files('lib/client/autoform-file.coffee', 'client');
});
