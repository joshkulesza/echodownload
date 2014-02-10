//listen for completed XHR
chrome.webRequest.onCompleted.addListener(function(info) {
	//check that request was for lecture meta
  	if(info.url.toString().search('loadDetailsSuccess') > -1){
		//extract the uuid from the request url
		var dl_regex = /^details.json/i
		var urlString  info.url.toString().firstMatch( dl_regex );
		if(urlString == null) return;
		//inform the content script and send uuid
	  	chrome.tabs.sendMessage(info.tabId, {url: urlString}, null);  
  }
},
{ urls: ["http://*/ecp/api/*", "http://*/ess/client/api/*"] });