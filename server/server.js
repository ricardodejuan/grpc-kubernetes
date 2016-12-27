var http = require('http');
var router = require('./router');

var server = http.createServer( (request, response) => {

	response.writeHead(200, {
		"Content-Type": "application/json"
	});
	
	router(request, response);
});
server.listen(3000);