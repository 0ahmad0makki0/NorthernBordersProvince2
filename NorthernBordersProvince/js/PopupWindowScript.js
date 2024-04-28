// Get the modal
var modal = document.getElementById('myModal');

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

function ClosePopupWindow() {
    modal.style.display = "none";
}

// When the user clicks the button, open the modal
function ShowPopup(bClosable) {
    modal.style.display = "block";

    if (bClosable == '1') {
        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function (event) {
            if (event.target == modal) {
                ClosePopupWindow();
            }
        }
    }
}

// When the user clicks on <span> (x), close the modal
span.onclick = function () {
    ClosePopupWindow();
}