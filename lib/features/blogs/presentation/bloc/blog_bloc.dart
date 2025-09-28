import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/data/services/firebase_firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final firestoreService = FirestoreBlogService();
  BlogBloc() : super(BlogInitial()) {
    on<BlogsLoaded>(_onBlogsLoaded);
    on<NewBlogAdded>(_onNewBlogAdded);
    on<BlogUpdated>((event, emit) {});
    on<BlogDeleted>((event, emit) {});
  }
  @override
  void onChange(Change<BlogState> change) {
    super.onChange(change);
    print('auth bloc change - $change');
  }

  @override
  void onTransition(Transition<BlogEvent, BlogState> transition) {
    super.onTransition(transition);
    print("sud transition- $transition");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print("sud error- $error");
    print("sud stack trace- $stackTrace");
  }

  void _onBlogsLoaded(BlogsLoaded event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    try {
      await for (var blogs in firestoreService.getBlogsStream()) {
        emit(BlogLoadSuccess(blogs));
      }
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void _onNewBlogAdded(NewBlogAdded event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      await firestoreService.addTask(
        event.title,
        event.content,
        event.authorId,
        event.authorName,
        event.coverImageUrl,
        event.tags,
      );
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }
}
// import 'package:firebase_connection_flutter/models/task.dart';
// import 'package:firebase_connection_flutter/services/firestore_task_services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'task_event.dart';
// part 'task_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   final FirestoreTaskService firestoreService;

//   TaskBloc({required this.firestoreService}) : super(TaskInitial()) {
//     on<LoadTasks>(_onLoadTasks);
//     on<NewTaskAdded>(_onNewTaskAdded);
//     on<TaskCompleted>(_onTaskCompleted);
//     on<TaskDeleted>(_onTaskDeleted);
//   }

//   void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());

//     try {
//       await for (var tasks in firestoreService.getTasksStream(event.uid)) {
//         emit(TaskLoaded(tasks));
//       }
//     } catch (e) {
//       emit(TaskFailure(errorMessage: e.toString()));
//     }
//   }

//   void _onNewTaskAdded(NewTaskAdded event, Emitter<TaskState> emit) async {
//     try {
//       await firestoreService.addTask(event.name, event.uid);
//     } catch (e) {
//       emit(TaskFailure(errorMessage: e.toString()));
//     }
//   }

//   void _onTaskCompleted(TaskCompleted event, Emitter<TaskState> emit) async {
//     try {
//       await firestoreService.toggleTask(event.taskId, event.isCompleted);
//     } catch (e) {
//       emit(TaskFailure(errorMessage: e.toString()));
//     }
//   }

//   void _onTaskDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
//     try {
//       await firestoreService.deleteTask(event.taskId);
//     } catch (e) {
//       emit(TaskFailure(errorMessage: e.toString()));
//     }
//   }
// }
