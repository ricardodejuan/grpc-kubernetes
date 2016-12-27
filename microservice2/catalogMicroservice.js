var _ = require('lodash');
var async = require('async');
var http = require('http');
var grpc = require('grpc');
var proto = grpc.load('../proto/imdb/imdbservice.proto').proto;

const IMDBURL = "http://imdb.wemakesites.net/api/search?q=";
const API_KEY = "d1b79452-6051-4873-b029-98dbc072f8c0";

var mapData = (call, data, callback) => {
	data.data.results.titles.map( (t) => call.write({element: t, source: "IMDB"}))
	callback();
}

var request = (keyword, callback) => {

	http.get(IMDBURL + keyword + "&api_key=" + API_KEY, (res) => {
		let rawData = '';
  		res.on('data', (chunk) => rawData += chunk);
  		res.on('end', () => {
			let parsedData = JSON.parse(rawData);
			callback(null, parsedData);
		});
	})
}

var catalogByKeyword = (call) => {
	var keyword = call.request.keyword;

	async.waterfall([
		_.partial(request, keyword),
		_.partial(mapData, call),
	], (err, result) => {
		call.end();
	});
}

var getServer = () => {
	var server = new grpc.Server();
	server.addProtoService(proto.IMDBService.service, {
		catalogByKeyword: catalogByKeyword
	});

	return server;
}


var routeServer = getServer();
routeServer.bind('0.0.0.0:50052', grpc.ServerCredentials.createInsecure());
routeServer.start();