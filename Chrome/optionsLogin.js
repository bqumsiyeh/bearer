$(document).ready(function() {
	Parse.initialize("YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj", "KPVpzyMz8gtxA16ZTe98z8jS7BDpwTIJznICYoaI");
});

$(function() {
	$('#login_btn').click(function () {

    	//have to do this to prevent race condition
		event.preventDefault();
    	
    	//set button to loading status
    	var btn = $(this)
    	btn.button('loading')

    	//logout first just in case
		//Parse.User.logOut();

		var username = document.getElementById("usernameTF").value;
	    var pw = document.getElementById("passwordTF").value;

	    Parse.User.logIn(username, pw, {

		  	success: function(user) {

		  		//reset loading button
	    		btn.button('reset')

		  		window.location.replace("options.html");
		  	},
		  	error: function(user, error) {

		  		//reset loading button
	    		btn.button('reset')

		  		alert("Error Logging In:  " + error.message);
		  	}

		});
  	});
});