Template.layout.onRendered ->
  new WOW().init()
  new IScroll('#scroller', #TODO ui element
    mouseWheel: true
    click: true
    snap: 'li') # TODO check?