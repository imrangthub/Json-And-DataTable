// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.

//= require jquery-2.2.0.min
//= require jquery.isloading
//= require vendor/jquery/jquery.dataTables.min
//= require vendor/bootstrap/dataTables.bootstrap.min
//= require vendor/bootstrap/bootstrap.min
//= require vendor/bootstrap/bootstrap-growl.min
//= require vendor/step/jquery-ui.min


if (typeof jQuery !== 'undefined') {
    (function($) {
        $('#spinner').ajaxStart(function() {
            $(this).fadeIn();
        }).ajaxStop(function() {
            $(this).fadeOut();
        });
    })(jQuery);
}

function showMsg(type, icon, title, msg){
    $.growl(false, {
        allow_dismiss: true,
        animate: {
            enter: 'animated bounceIn',
            exit: 'animated bounceOut'
        },
        delay:1000,
        offset: 5,
        command: 'closeAll'
    });
    $.growl({
            icon: icon,
            title:title ,
            message: msg
        },
        {
            type:type,
            placement:{
                from:'top',
                align:'right'
            }
        });
}

function showSuccessMsg(msg){
    showMsg("success","glyphicon glyphicon-ok","<strong> Success</strong><br/>", msg);
}
function showErrorMsg(msg){
    showMsg("danger","glyphicon glyphicon-remove", "<strong> Error</strong><br/>", msg);
}
function showInfoMsg(msg){
    showMsg("info","glyphicon glyphicon-info-sign","<strong> Info</strong><br/>", msg);
}



function showLoading(div){
    $(div).isLoading({
        'text': "Processing...",
        'class': "icon-refresh",
        'position': "overlay"
    });
}
function hideLoading(div){
    $(div).isLoading( "hide" );
}

function clearForm(form) {
    $(':input', form).each(function () {
        var type = this.type;
        var tag = this.tagName.toLowerCase(); // normalize case
        // password inputs, and textareas
        if (type == 'text' || type == 'password' || type == 'hidden' || tag == 'textarea' || type == 'email' || type == 'tel' || type == 'number') {
            this.value = "";
        }

        // checkboxes and radios need to have their checked state cleared
        else if (type == 'checkbox' || type == 'radio')
            this.checked = false;

        // select elements need to have their 'selectedIndex' property set to -1
        else if (tag == 'select') {
            this.value = "";
        }

    });
}
