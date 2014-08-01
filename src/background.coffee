class EchoDlService

	@_sendMessage: (tabId, url, callback) ->
		console.log "Alright! lets go! #{tabId}"
		console.log url
		#send internal message in chrome
		chrome?.tabs?.sendMessage tabId, url: url, callback

	@_showAction: (tabId) ->
		console.log "Showing action on tab:#{tabId}"
		#set action visible chrome
		chrome?.pageAction?.show tabId

	@_hideAction: (tabId) ->
		console.log "Hiding action on tab:#{tabId}"
		#set action hidden chrome
		chrome?.pageAction?.hide tabId

	@_processRequest: (tabId, url) ->
		if url.search("loadDetailsSuccess") isnt -1
			[url, ...] = url.match /.+details.json/i
			if url?
				@_sendMessage tabId, url, (successful) =>
					if successful
						@_showAction tabId
					else
						@_hideAction tabId

	@captureRequest: ->
		#extract data from request
		if chrome?.webRequest? #google chrome
			(info) =>
				@_processRequest info.tabId, (info.url.toString())

#tell chrome what to do with the requests it hears
chrome?.webRequest?.onCompleted.addListener EchoDlService.captureRequest(), urls: ["*://*/ecp/api/*", "*://*/ess/client/api/*"]
