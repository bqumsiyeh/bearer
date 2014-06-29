
 chrome.contextMenus.create({title: "Send with Bearer", contexts:["selection", "link", "page"], onclick: startSendContent});

function startSendContent(info)
{
 	var textToSend = getPreviewTextToPush(info);
 	
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

function getPreviewTextToPush(info) {
	var t = info.selectionText;
	if (t == null || t.length == 0)
		t = info.pageUrl;
	return t;
}

function createSentContentRecord (textToSend) {
	alert("a");
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
	    sendPush(textToSend, sentContent);
	  },
	  error: function(sentContent, error) {
	    alert('Failed to create new object, with error code: ' + error.description);
	  }
	});
}

function sendPush(textToSend, sentContent) {
	var currentUser = Parse.User.current();
	if (!currentUser)
		return;

	alert("about to send");
	var query = new Parse.Query(Parse.Installation);
	query.equalTo("objectId", currentUser["registeredDevice"]);
	Parse.Push.send({
	  where: query, // Set our Installation query
	  data: {
	    alert: textToSend,
	    sentContentId:sentContent.id,
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