part of 'word_bloc.dart';

class WordEvent {}

class GetEvent extends WordEvent {
  final String categoryName;

  GetEvent({required this.categoryName});
}
