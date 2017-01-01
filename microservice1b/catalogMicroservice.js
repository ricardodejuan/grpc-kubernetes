var _ = require('lodash');
var fs = require('fs');
var grpc = require('grpc');
var proto = grpc.load(__dirname + '/proto/local/LocalCatalogService.proto').proto;

var catalog = []

fs.readFile(__dirname + '/catalog/catalog.json', 'utf8', (err, data) => {
	if (!err) {
		catalog = JSON.parse(data).catalog;
	}
})

var localCatalogByGenre = (call, callback) => {
	var aux = [];

	call.on('data', (req) => {
		_.filter(catalog, {'genres': [req.genre]})
		.forEach( (e) => { if (aux.indexOf(e) < 0) aux.push(e)});
	});

	call.on('end', function() {
		callback(null, {products: aux});
	});
}

var getServer = () => {
	var server = new grpc.Server();
	server.addProtoService(proto.LocalCatalogService.service, {
		localCatalogByGenre: localCatalogByGenre
	});

	return server;
}


var routeServer = getServer();
routeServer.bind('0.0.0.0:50051', grpc.ServerCredentials.createInsecure());
routeServer.start();