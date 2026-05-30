
import 'package:equatable/equatable.dart';
import 'package:takween/Features/posts/data/models/create_post_model.dart';

enum CreatePostStatus {
  initial,
  loading,
  draftCreated,
  uploadingDocs,
  docsUploaded,
  submitting,
  success,
  failure,
}

class CreateLandPostState extends Equatable {
  final CreatePostModel model;
  final CreatePostStatus status;
  final String? postId;
  final String? errorMessage;

  const CreateLandPostState({
    required this.model,
    this.status = CreatePostStatus.initial,
    this.postId,
    this.errorMessage,
  });

  CreateLandPostState copyWith({
    CreatePostModel? model,
    CreatePostStatus? status,
    String? postId,
    String? errorMessage,
  }) {
    return CreateLandPostState(
      model: model ?? this.model,
      status: status ?? this.status,
      postId: postId ?? this.postId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [model, status, postId, errorMessage];
}