###
Router.configure
  layoutTemplate: 'appBody'
###

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'