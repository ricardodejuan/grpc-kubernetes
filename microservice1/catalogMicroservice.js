var _ = require('lodash');
var grpc = require('grpc');
var proto = grpc.load(__dirname + '/proto/local/LocalCatalogService.proto').proto;

var catalog = [
				{id: "1", title: "Band of Brothers", genres: ["Action", "Drama", "History"], rating: "9.5"}, 
				{id: "2", title: "Game of Thrones", genres: ["Adventure", "Drama", "Fantasy"], rating: "9.5"}, 
				{id: "3", title: "True Detective", genres: ["Crime", "Drama", "Mystery"], rating: "9.1"},
				{id: "4", title: "Breaking Bad", genres: ["Crime", "Drama", "Thriller"], rating: "9.5"},
				{id: "5", title: "Stranger Things", genres: ["Drama", "Fantasy", "Horror"], rating: "9.0"},
				{id: "6", title: "Narcos", genres: ["Biography", "Drama", "Crime"], rating: "8.9"}
			]

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