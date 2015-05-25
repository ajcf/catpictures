$(function () {

    ////// Event Listeners ////////

    $(".category-options").click(function (event) {
        var selectedCategory = event.target;
        var categoryName = selectedCategory.textContent.trim();

        $(".category-options").removeClass("active");
        $(selectedCategory).addClass("active");
        $(selectedCategory).find(".category-spinner").show();

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
            $(event.target).find(".category-spinner").show();
            updateCatPhoto("random");
        }
    });

    $("#report-image").click(function () {
        if (confirm("Are you sure? Please only report inappropriate photos.")) {
            reportCatPhoto();
            updateCatPhoto("random");
        }
    });

    ////// Utility Methods ////////

    function updateCatPhoto (category) {
        $(".alert-message").hide();

        $.get("/category/" + category, function (data) {
            $("#cat_photo_holder").html(data);
        }).fail(function () {
            showMessage("No Image Found", "error");
        }).always(function () {
            $(".category-spinner").hide();
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