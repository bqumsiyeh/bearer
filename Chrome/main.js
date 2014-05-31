
chrome.contextMenus.create({title: "Send with Bearer", contexts:["selection", "link", "page"], onclick: startSendContent});

function startSendContent(info)
{
 	
 	alert(info);
 	return;
 	var textToSend = info.selectionText;
 	
 	Parse.initialize("YBCBJjWoVxlTNYuuIVQkFbzNe1qNg9t063HNYSvj", "KPVpzyMz8gtxA16ZTe98z8jS7BDpwTIJznICYoaI");

 	//make sure we have a valid user with parse first
 	var currentUser = Parse.User.current();
 	if (currentUser == null) {
 		alert ("Woops! Please sign into Bearer first!");
  		chrome.tabs.create({ url: "optionsLogin.html" });
 	}
 	else {
 		createSentContentRecord(textToSend);
 	}

 	
}

function createSentContentRecord (textToSend) {

	var currentUser = Parse.User.current();
	if (!currentUser)
		return;

	//first create the record in Parse
 	var SentContent = Parse.Object.extend("SentContent");
	var newSentContent = new SentContent();
	 
	newSentContent.set("route", "SMS");
	newSentContent.set("type", "TEXT");
	newSentContent.set("text", textToSend);
	newSentContent.set("user", currentUser);
	 
	newSentContent.save(null, {
	  success: function(sentContent) {
	 	//now we can send the push!
	    sendPush(textToSend);
	  },
	  error: function(sentContent, error) {
	    alert('Failed to create new object, with error code: ' + error.description);
	  }
	});
}

function sendPush(textToSend) {
	var currentUser = Parse.User.current();
	if (!currentUser)
		return;

	var query = new Parse.Query(Parse.Installation);
	query.equalTo("user", currentUser);
	Parse.Push.send({
	  where: query, // Set our Installation query
	  data: {
	    alert: textToSend,
	    sound: "default"
	  }
	}, {
	  success: function() {
	 	alert("Sent!");
	  },
	  error: function(error) {
	    // Handle error
	    alert("Error sending push notification :(");
	  }
	});
}