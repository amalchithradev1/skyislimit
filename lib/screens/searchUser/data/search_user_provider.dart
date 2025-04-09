import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../rest/rest_client_provider.dart';
import '../model/search_result_users_model.dart';

final searchUserProvider = ChangeNotifierProvider<SearchUserProvider>((ref) {
  return SearchUserProvider(ref);
});

class SearchUserProvider extends ChangeNotifier {
  SearchUserProvider(this._ref) : _restClient = _ref.read(restClientProvider) {}
  final Ref _ref;
  final RestClient _restClient;

  SearchGitUsers? _user;
  bool _loading = false;
  String? _error;

  SearchGitUsers? get user => _user;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> searchUser(String username) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _restClient.getUsersByUsername(username);
      _user = SearchGitUsers.fromJson(result);
    }on DioException catch (dioError) {
      _error = dioError.error.toString();
      _user = null;
    }  catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
