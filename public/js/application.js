$(function () {

    ////// Event Listeners ////////
    $(".category-options").click(function (event) {
        var selectedCategory = event.target;
        var categoryName = selectedCategory.textContent.trim();

        $(".category-options").removeClass("active");
        $(selectedCategory).addClass("active");
        $(selectedCategory).find(".loading-spinner").show();

        updateCatPhoto(categoryName);
    });

    $("#favorite-image").click(function () {
        favoriteCatPhoto();
    });

    $("#reload").click(function (event) {
        var category = $(".category-options.active");
        if (category.length > 0) {
            $(category).click();
        } else {
            $(event.target).find(".loading-spinner").show();
            updateCatPhoto("random");
        }
    });

    // trigger popover when "share" button is clicked
    $('#share-image').popover({
        content: function () { 
            return $("#cat_photo").data('local-url'); 
        }
    });

    // prevents share popover from lingering when user is no longer interested
    // while allowing it to stick around long enough for users to copy/paste url
    $("body").click(function (event) {
        if ($(event.target).closest("#share-image").length == 0 && 
            $(event.target).closest(".popover").length == 0)
        {
            $("#share-image").popover('hide');
        }
    });

    $("#report-image").click(function () {
        if (confirm("Are you sure? Please only report inappropriate photos.")) {
            reportCatPhoto();
            updateCatPhoto("random");
        }
    });

    $("#random-image").click(function (event) {
        $(".category-options").removeClass("active");
        $(event.target).find(".loading-spinner").show();
        updateCatPhoto("random");
    });

    ////// Utility Methods ////////

    function updateCatPhoto (category) {
        $(".alert-message").hide();

        $.get("/category/" + category, function (data) {
            $("#cat_photo_holder").html(data);
        }).fail(function () {
            showMessage("No Image Found", "error");
        }).always(function () {
            $(".loading-spinner").hide();
        });
    }

    function favoriteCatPhoto () {
        $(".alert-message").hide();

        var photo_id = $("#cat_photo").data("image-id");
        $.get("/favorite/" + photo_id, function () {
            showMessage("Added to Favorites!", "success");
        });
    }

    function reportCatPhoto () {
        var photo_id = $("#cat_photo").data("image-id");
        $.get("/report/" + photo_id, function () {
            showMessage("Image will no longer be displayed.", "success");
        });
    }

    function showMessage (message, type) {
        // never show two alert messages at once!
        $(".alert-message").hide();

        $("#" + type + "-message").text(message);
        $("#" + type + "-message").show().delay(5000).slideUp();
    }

});