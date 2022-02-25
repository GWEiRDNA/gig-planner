import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';

class ConnectionParameters
{
  String hostname;
  int port;
  String database;
  String username;
  String password;
  ConnectionParameters(this.hostname, this.port, this.database, this.username, this.password);
}

Future<PostgreSQLConnection> connectToDatabase(ConnectionParameters params) async
{
  PostgreSQLConnection connection = PostgreSQLConnection(params.hostname, params.port, params.database, username: params.username, password: params.password);
  await connection.open();
  return connection;
}

Future<List<Map<String, Map<String, dynamic>>>> executeQuery(var connection, String query, Map<String, dynamic> queryArgs) async
{
  for (final queryArgsName in queryArgs.keys) {
    query = query.replaceAll(queryArgsName, queryArgs[queryArgsName].toString());
  }
  return connection.mappedResultsQuery(query);
}
