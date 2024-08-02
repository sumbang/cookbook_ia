import 'package:equatable/equatable.dart';

class ResetRequest extends Equatable {

  final String username;

  const ResetRequest({
    required this.username,
  });

    @override
  List<Object?> get props => [
    username,
  ];


}