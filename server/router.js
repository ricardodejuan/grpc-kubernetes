var url = require('url');
var _ = require('lodash');

var grpc = require('grpc');
var protoCatalog = rpc.load(__dirname + '/proto/local/localcatalogservice.proto').proto;
var protoIMDB = rpc.load(__dirname + '/proto/imdb/imdbservice.proto').proto;

var localClient = new protoCatalog.LocalCatalogService('microservice1:50051', grpc.credentials.createInsecure());
var imdbClient = new protoIMDB.IMDBService('microservice2:50052', grpc.credentials.createInsecure());

var getLocalCatalogByGenre = (request, response) => {
	var genres = [];
	var query = url.parse(request.url).query;

	if (query)
		genres = query.split("=")[1].split("-");

	var call = localClient.localCatalogByGenre( (error, catalog) => {
		if (error) {
			response.end(JSON.stringify(error));
		} else {
			response.end(JSON.stringify(catalog));
		}
	});

	genres.forEach( (g) => call.write({genre: g}) );
	call.end();
}

var getIMDBCatalogByKeyword = (request, response) => {
	var keyword;
	var query = url.parse(request.url).query;
	var data = [];

	if (query)
		keyword = query.split("=")[1];

	var call = imdbClient.catalogByKeyword({keyword: keyword});

	call.on('data', (req) => data.push(req.element) );

	call.on('end', () => response.end(JSON.stringify({IMDB: data})));
}

var router = (req, res) => {
	var url_parts = url.parse(req.url);

	switch(url_parts.pathname) {
		case '/localCatalogByGenre':
			getLocalCatalogByGenre(req, res);
			break;
		case '/imdbCatalogByKeyword':
			getIMDBCatalogByKeyword(req, res);
			break;
		default:
			res.end(JSON.stringify({"data": "404 Not Found"}));
	}
}

module.exports = router;