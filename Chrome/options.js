window.onload = function() {
	Parse.initialize("YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj", "KPVpzyMz8gtxA16ZTe98z8jS7BDpwTIJznICYoaI");
	//Parse.User.logOut();

  	var currentUser = Parse.User.current();

	if (currentUser == null) {
		//user not logged in yet, redirect to login page.
		window.location.replace("optionsLogin.html");
		return;
	}


	document.getElementById("topMsg").innerHTML = "Welcome to Bearer";
	document.getElementById("username").innerHTML = "Logged in as <strong>" + currentUser.get("email") + "</strong>";
	var deviceTable = document.getElementById('deviceTable');
	deviceTable.style.visibility='hidden';
	var contentTable = document.getElementById('contentTable');
	contentTable.style.visibility='hidden';

	 $("#spinner1").show();
	 $("#spinner2").show();

	//show the registered device
	var device = currentUser.get("registeredDevice");
	device.fetch({
	  success: function(installation) {

	  	//stop the spinner 
	  	$("#spinner1").hide();

	  	document.getElementById('container1').style.display='block';

	  	//unhide the table
	  	deviceTable.style.visibility='visible';

	  	document.getElementById("deviceTitle").innerHTML = "Registered Device";

	  	//set the table row
	    var name = installation.get("deviceName");
	    var type = "iOS"; //installation.get("deviceType");
	    var tableRef = deviceTable.getElementsByTagName('tbody')[0];
		var newRow   = tableRef.insertRow(tableRef.rows.length);
		var newCell  = newRow.insertCell(0);
		var newText  = document.createTextNode(name);
		var newCell2  = newRow.insertCell(1);
		var newText2  = document.createTextNode(type);
		newCell.appendChild(newText);
		newCell2.appendChild(newText2);

	  },
	  error: function(error) {
	  	$("#spinner1").hide();
	  	document.getElementById('tableContainer1').style.display='none';
	  	document.getElementById("deviceTitle").innerHTML = "Can't find a registered device.  Download the iOS app HERE! and login to register your device!";
	  }
	});

	//show the sent content
	var SentContent = Parse.Object.extend("SentContent");
	var query = new Parse.Query(SentContent);
	query.equalTo("user", currentUser);
	query.limit(5);
	query.descending("createdAt");
	query.find({
		success: function(results) {

			//hide the spinner
			$("#spinner2").hide();

			contentTable.style.visibility='visible';

			for (var i = 0; i < results.length; i++) { 
		    	var object = results[i];

		      	var text = "\"" + object.get("text") + "\"";
		      	// if (text.length > 72)
		      	// 	text = text.substring(0,69) + "...";

		      	var date = object.createdAt;
		      	var dateStr = moment(date).fromNow(true) + " ago";

			    var tableRef = contentTable.getElementsByTagName('tbody')[0];
				var newRow   = tableRef.insertRow(tableRef.rows.length);
				var newCell  = newRow.insertCell(0);
				var newText  = document.createTextNode(text);
				var newCell2  = newRow.insertCell(1);
				var newText2  = document.createTextNode(dateStr);
				newCell.appendChild(newText);
				newCell2.appendChild(newText2);
		    }
	  	},
	  	error: function(error) {
	  		$("#spinner2").hide();
	    	alert("Error: " + error.code + " " + error.message);
	  	}
	});
};

$(function() {
	$('#logout_btn').click(function () {
		Parse.User.logOut();
		window.location.replace("optionsLogin.html");
  	});
});