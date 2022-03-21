/* A function to allow clients to send HTTP POST requests.
	Because world.Export() doesn't support POST yet.
*/
world
	proc
		/* Send an HTTP POST request to [url] with [data].
		*/
		HttpPost(url, data)
			src << output(list2params(list(url, json_encode(data))), "http_post_browser.browser:post")