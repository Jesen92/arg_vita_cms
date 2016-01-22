

$(document).ready(function() {
    $('.js--msr-icon').click(function () {
        var div = $('.js--msr-gall');



        if (div.hasClass('col-xs-6 col-md-2')) {
            div.removeClass('col-xs-6 col-md-2');
            div.addClass('col-xs-6 col-md-3');
        } else {
            div.removeClass('col-xs-6 col-md-3');
            div.addClass('col-xs-6 col-md-2');

        }


    });

});
