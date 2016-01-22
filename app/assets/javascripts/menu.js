/**
 * Created by Jesenovic on 20/11/15.
 */


$(document).ready(function() {
    $('.js--msr-icon').click(function () {
        var icon = $('.js--msr-icon i');
        var nav = $('.js--msr a');



        if (icon.hasClass('ion-navicon-round')) {
            icon.addClass('ion-close-round');
            nav.addClass('menu-slide-right');
            icon.removeClass('ion-navicon-round');
            nav.removeClass('menu-slide-left');
        } else {
            icon.addClass('ion-navicon-round');
            nav.addClass('menu-slide-left');
            nav.removeClass('menu-slide-right');
            icon.removeClass('ion-close-round');
        }


    });

});
