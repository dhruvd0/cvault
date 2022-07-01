class NotificationInitial extends NotificationState {
  NotificationInitial() : super(currentToken: '');
}

class NotificationState {
  final String currentToken;
  NotificationState({
    required this.currentToken,
  });

  NotificationState copyWith({
    String? currentToken,
  }) {
    return NotificationState(
      currentToken: currentToken ?? this.currentToken,
    );
  }
}
