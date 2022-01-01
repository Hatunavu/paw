import 'dart:async';

import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/features/home/bloc/post_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final UserRepository _userRepository;

  PostCubit(
    this._userRepository,
  ) : super(PostStateInitial());

  Future<void> getPost() async {
    try {
      if (!((state is PostStateSuccess) &&
          (state as PostStateSuccess).hasReachedEnd)) {
        if (state is PostStateInitial) {
          List posts;
          await _userRepository.getPosts().then((value) {
            posts = value.map((post) => Post.fromDoc(post)).toList();
            emit(PostStateSuccess(
                posts: posts, hasReachedEnd: false, docs: value));
          });
        } else if (state is PostStateSuccess) {
          List posts;
          List docs;
          final currentState = state as PostStateSuccess;
          await _userRepository.getNextPost(currentState.docs).then((value) {
            docs = value;
            posts = value.map((post) => Post.fromDoc(post)).toList();
          });
          if (posts.isEmpty) {
            emit(currentState.cloneWith(hasReachedEnd: true));
          } else {
            emit(PostStateSuccess(
                posts: currentState.posts + posts,
                hasReachedEnd: false,
                docs: currentState.docs + docs));
          }
        }
      } else {}
    } catch (e) {
      emit(PostStateFailure());
    }
  }
}

// class PostBloc {
//   UserRepository _userRepository;
//   List documentList;
//   BehaviorSubject<List> postController;
//   BehaviorSubject<bool> showIndicatorController;

//   PostBloc() {
//     _userRepository = UserRepositoryImplement();
//     showIndicatorController = BehaviorSubject<bool>();
//     postController = BehaviorSubject<List>();
//   }

//   Stream get getShowIndicatorStream => showIndicatorController.stream;
//   Stream<List> get postStream => postController.stream;

//   Future getPost() async {
//     try {
//       documentList = await _userRepository.getPost();
//       postController.sink.add(documentList);
//       try {
//         if (documentList.length == 0) {
//           postController.sink.addError('No data');
//         }
//       } catch (e) {}
//     } on SocketException {
//       postController.sink.addError(const SocketException('No internet'));
//     } catch (e) {
//       postController.sink.addError(e);
//     }
//   }

//   getNextPost() async {
//     try {
//       final List newdocumentList =
//           await _userRepository.getNextPost(documentList);
//       documentList.addAll(newdocumentList);
//       postController.sink.add(documentList);
//       if (newdocumentList.length == 0) {
//         showIndicatorController.sink.add(false);
//       }
//       try {
//         if (documentList.length == 0) {
//           postController.sink.addError('No data');
//           showIndicatorController.sink.add(false);
//         }
//       } catch (e) {
//         showIndicatorController.sink.add(false);
//       }
//     } on SocketException {
//       postController.sink.addError('No internet');
//       showIndicatorController.sink.add(false);
//     } catch (e) {
//       showIndicatorController.sink.add(false);
//       postController.sink.addError(e);
//     }
//   }

//   updateIndicator() {
//     showIndicatorController.sink.add(true);
//   }

//   void dispose() {
//     postController.close();
//     showIndicatorController.close();
//   }
// }
