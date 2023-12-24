//trim input 
$('input[type=text]').blur(function () {
    $(this).val($.trim($(this).val()));
});

//allow only nuber in field
$(".number-only").on("keydown", function (event) {
    // Ignore controls such as backspace
    var arr = [8, 9, 16, 17, 20, 32];
    // Allow letters
    for (var i = 48; i <= 57; i++) {
        arr.push(i);
    }
    for (var i = 96; i <= 105; i++) {
        arr.push(i);
    }

    if (jQuery.inArray(event.which, arr) === -1) {
        event.preventDefault();
    }
});

$(".number-only").on("input", function () {
    var regexp = /[^0-9]/;
    if ($(this).val().match(regexp)) {
        $(this).val($(this).val().replace(regexp, ''));
    }
});
//

//price

$(".price").on("input", function () {
    var inputVal = $(this).val();
    var regex = /^\d+(\.\d{0,2})?$/;
    if (!regex.test(inputVal)) {
        $(this).val("");
    }
});

$('.currdate').datepicker({
    orientation: "bottom left",
    todayHighlight: true,
    format: "dd/mm/yyyy",
    startDate: new Date()

});

//$(".number-only-price").on('input', function (event) {
//    // replace non-numeric characters with an empty string
//    $(this).val($(this).val().replace(/^\d+(\.\d{1,2})?$/g, ''));

//alpha only

$(".alpha-only").on("keydown", function (event) {
    // Ignore controls such as backspace
    var arr = [8, 9, 16, 17, 20, 32, 35, 36, 37, 38, 39, 40, 45, 46];
    // Allow letters
    for (var i = 65; i <= 90; i++) {
        arr.push(i);
    }
    if (jQuery.inArray(event.which, arr) === -1) {
        event.preventDefault();
    }
});

$(".alpha-only").on("input", function () {
    var regexp = /[^A-Za-z_\s]/;
    if ($(this).val().match(regexp)) {
        $(this).val($(this).val().replace(regexp, ''));
    }
});

//Open new window by given url
function OpenNewWindow(url) {
    window.open(url, '_blank', 'width=600,height=600resizable=1,scrollbars=1,menubar=1');
}

function printPage() {
    $('#PrintTemplateId').hide();
    window.print();
}

//Common methods to scroll to a particular position on a web page.
function ScrollToPosition($element){

    $('html, body').animate({
        scrollTop: $element.offset().top
    }, 2000, function () {
        $(".loader").hide();
    });

}


function QueryStringToData(queryString) {

    var dataToSend = {};

    // Parse the query string and populate the data object
    var keyValuePairs = queryString.split("&");
    for (var i = 0; i < keyValuePairs.length; i++) {
        var pair = keyValuePairs[i].split("=");
        var key = decodeURIComponent(pair[0]);
        var value = decodeURIComponent(pair[1]);
        dataToSend[key] = value;
    }

    return dataToSend
}


//Create javascript function that get the query string from url
function GetQueryStringFromUrl(urlString) {

    var queryString = "";
    var questionMarkIndex = urlString.indexOf("?");
    if (questionMarkIndex !== -1) {
        queryString = urlString.substring(questionMarkIndex + 1);
    }
    return queryString;
}

function RemoveQueryStringFromUrl(urlString) {
    var queryString = "";
        var questionMarkIndex = urlString.indexOf("?");
        if (questionMarkIndex !== -1) {
            queryString = urlString.slice(0, questionMarkIndex);
        }
        return queryString;
}

//generate javascript code that handle null values
function IsNotNull(value) {

    let result = false;

    if (value === null || value === undefined) {
        result = false;
    }
    else {
        result = true;
    }

    return result;
}



