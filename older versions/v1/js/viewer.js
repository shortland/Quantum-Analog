$(window).ready(function()
{

    var fixmeTop = $('#info-bar').offset().top;

    $(window).scroll(function() 
    {
        var currentScroll = $(window).scrollTop(); 

        if (currentScroll >= fixmeTop)
        {           
            $('#info-bar').css({                      
                'position' : 'fixed',
                'top' : '0',
                'left' : '0',
                'border-top' : '0px',
                'border-left' : '0px',
                'border-right' : '0px'
            });
            $('#text').css({
                'padding-top' : '50px'
            }); 
        }
        else
        {                                  
            $('#info-bar').css({                      
                'position' : 'static',
                'border-top' : '1px solid black',
                'border-left' : '1px solid black',
                'border-right' : '1px solid black'
            });
            $('#text').css({
                'padding-top' : '-=40px'
            }); 
        }
    });

});