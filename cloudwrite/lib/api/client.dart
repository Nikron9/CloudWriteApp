import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/pages/auth/auth_service.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLClient _client() {
    final HttpLink _httpLink = HttpLink(
      uri: 'http://10.0.2.2:8080/graphql',
    );

    final AuthLink _authLink = AuthLink(
      // ignore: undefined_identifier
      getToken: () async =>
          '${await ServiceResolver.get<AuthService>().getCurrentUser().then((value) => value != null ? value.token : "")}',
    );

    final Link _link = _authLink.concat(_httpLink);

    return GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
  }

  Future<QueryResult> _performQuery(String query,
      {Map<String, dynamic> variables}) async {
    QueryOptions options =
        QueryOptions(documentNode: gql(query), variables: variables);

    final result = await _client().query(options);

    return result;
  }

  Future<QueryResult> _performMutation(String query,
      {Map<String, dynamic> variables}) async {
    MutationOptions options =
        MutationOptions(documentNode: gql(query), variables: variables);

    final result = await _client().mutate(options);

    print(result);

    return result;
  }

  Future<QueryResult> signIn(String username, String password) async {
    return _performMutation("""mutation{
  signIn(password: "$password", username: "$username"){
    _id
    email
    password
    token
    username
  }
}""", variables: Map());
  }

  Future<QueryResult> signUp(
      String email, String username, String password) async {
    return _performMutation("""mutation{
  signUp(email: "$email", password: "$password", username: "$username"){
    _id
    email
    password
    token
    username
  }
}""", variables: Map());
  }

  Future<QueryResult> createNote(NoteEntity note) async {
    return _performMutation("""mutation{
  addNote(
  title: \"${note.title}\",
  content: \"${note.content}\",
  isPrivate: ${note.isPrivate}
  ){
    _id
    title
    content
    isPrivate
    isArchived
  }
}""", variables: Map());
  }

  Future<QueryResult> updateNote(NoteEntity note) async {
    return _performMutation("""mutation{
  updateNote(
  _id: \"${note.id}\",
  title: \"${note.title}\",
  content: \"${note.content}\",
  isPrivate: ${note.isPrivate},
  isArchived: ${note.isArchived}
  ){
    _id
    title
    content
    isPrivate
    isArchived
  }
}""", variables: Map());
  }

  Future<QueryResult> fetchNotes(
      String search, bool onlyMine, bool withArchived) async {
    return _performQuery("""query {
  notes(searchTerm:${search.isNotEmpty ? "\"$search\"" : "\"\""}, onlyMine:$onlyMine, withArchived:$withArchived) {
    _id
    content
    createdAt
    isArchived
    isPrivate
    title
    username
  }
}""", variables: Map());
  }
}
