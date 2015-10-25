Template.layout.onRendered ->
  new WOW().init()
  scroller = $('#scroller') #TODO ui element
  if scroller?.length isnt 0
    new IScroll(scroller,
      mouseWheel: true
      click: true
      snap: 'li') # TODO check?