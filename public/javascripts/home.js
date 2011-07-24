Home = {
  
  animationSpeed : 500,
  
  fadingSpeed : function(){
    return this.animationSpeed / 2   // return a hardcoded number here if preferred
  },
  
  handlerOffset : function(handler){
    var nav = $('#home nav li').first()
    var firstNavLink = $('#home nav li').first()
    var handlerLeftBorder = firstNavLink.position().left
    return handlerLeftBorder
  },
  
  animateToLink : function(link){
    var handler = $('#slider-handle')
    var elem = $(link)
    var clicked = elem.attr('href').replace('#', '')
    var handlerOffset = this.handlerOffset(handler)
    var x = (elem.outerWidth() / 2) + elem.position().left - handlerOffset
    handler.animate({ left: x }, Home.animationSpeed);
  },
  
  linkClassesExcept : function(linkClass){
    return $.grep('forget_servers run_anything see_everything trust_and_manage'.split(' '), function(klass){
      return klass != linkClass
    })
  },
  
  setEvents : function(){
    $('#home nav a').click( function(e){
      var clicked = $(this).attr('href').replace('#', '')
      var otherLinksSelector = $.map(Home.linkClassesExcept(clicked), function(item){ return '#' + item }).join(', ')

      $(otherLinksSelector).filter(':visible').fadeOut(Home.fadingSpeed(), function(){
        $('#' + clicked).fadeIn(Home.fadingSpeed())
      })
      
      $('nav li').removeClass('active')
      $(this).closest('li').addClass('active')
      Home.animateToLink(this)
      return false
    })
    $(window).resize(Home.setAnimationVbles)
  },
  
}

$(function(){
  Home.setEvents()
})
window.onload = function(){  $("a[href='#forget_servers']").click() }
