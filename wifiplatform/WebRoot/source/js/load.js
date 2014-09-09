$(function(){

	$(".load").click(function(){

		 $(".continer").load("cont.html");
	});
   

    //$('#nav li').click(function () {
  //      if($(this).find("ul").is(":hidden")){
  //          $(this).find("ul").slideDown('slow').parent().slibings().hide();
  //      }else{
  //          $(this).find("ul").slideUp('slow');  
   //     }
    //  })

    //     手风琴菜单
    $('#nav>li').click(function () {

        $(this).find('ul').slideDown('slow').parent().find('span img').addClass('ee');
        
        $(this).siblings().find('ul').slideUp('slow').parent().find('span img').removeClass('ee');
        var cur = $(this).index();
        $(this).attr("type",cur).siblings("li").removeAttr("type");
    });
      
      $(".nav_box").hover(function(){
         $("#nav>li").each(function(){
             var cindex = $(this).attr("type");
             //console.log(cindex)
              $("#nav li").eq(cindex).find("ul").slideDown('slow');

             if(cindex!=undefined){
               cindex=cindex;
               $("#nav>li").eq(cindex).find("ul").slideDown('slow');  
             }

          }); 
           
        
          $("#nav li i").css("float", "none");
          $(".nav_box").css("left", "0");
      },function(){
            $("#nav li i").css("float","right")
            $(".nav_box").css("left", -176);
            $('#nav li ul').slideUp('slow').parent().find('span img').removeClass('ee');

      })

      $('#nav li').click(function () {
          $(this).addClass('click').siblings().removeClass('click');
      })
      $('.s_box li span').click(function () {
          $(this).parent().parent().addClass('li_hover').siblings().removeClass('li_hover');
      })


    
$('#nav li a').click(function (e) {
   e.preventDefault()
    var hr = $(this).attr("href");
    //更改iframe链接
    upiframe(hr);
    return false;
})
  function upiframe(hr){
     $("#indexFrame").attr("src",hr);
  }
})