window.onload = function() {
	Parse.initialize("YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj", "KPVpzyMz8gtxA16ZTe98z8jS7BDpwTIJznICYoaI");
	//Parse.User.logOut();

  	redirectToLoginIfNeeded();
};

$(function() {
	$('#logout_btn').click(function () {
		Parse.User.logOut();
		window.location.replace("optionsLogin.html");
  	});
});

function redirectToLoginIfNeeded() {
	var currentUser = Parse.User.current();
	if (currentUser != null) {
	    document.getElementById("topMsg").innerHTML = "Welcome to Bearer";
	} else {
		window.location.replace("optionsLogin.html");
	}
} 