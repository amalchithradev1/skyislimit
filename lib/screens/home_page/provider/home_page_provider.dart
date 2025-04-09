import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../rest/rest_client_provider.dart';
import '../model/user_repos_model.dart';

final homePageProvider = ChangeNotifierProvider<UserReposProvider>((ref) {
  return UserReposProvider(ref);
});

class UserReposProvider extends ChangeNotifier {
  UserReposProvider(this._ref) : _restClient = _ref.read(restClientProvider) {}
  final Ref _ref;
  final RestClient _restClient;

  List<UserRepositories>? _userRepos;
  bool _loading = false;
  String? _error;

  List<UserRepositories>? get userRepos => _userRepos;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> getUserRepos(String username) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _restClient.getUsersRepositories(username);
      if (result is List) {
        _userRepos = result.map((data) {
          try {
            return UserRepositories.fromJson(data);
          } catch (e) {
            return null;
          }
        }).whereType<UserRepositories>().toList();

      }
    } on DioException catch (dioError) {
      _error = dioError.error.toString();
      _userRepos = null;
    }catch (e) {
      print("Outer catch error: $e");
      _error = e.toString();
      _userRepos = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
