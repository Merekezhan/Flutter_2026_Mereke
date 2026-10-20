sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  const Upcoming(this.remaining);

  final Duration remaining;
}

class Started extends Countdown {
  const Started(this.elapsed);

  final Duration elapsed;
}

class Ended extends Countdown {
  const Ended();
}

Countdown countdownFor(DateTime? date, DateTime now) {
  if (date == null) return const Ended();

  final difference = date.difference(now);

  if (difference > Duration.zero) {
    return Upcoming(difference);
  }

  if (difference.inHours > -24) {
    return Started(now.difference(date));
  }

  return const Ended();
}

String countdownText(Countdown countdown) => switch (countdown) {
  Upcoming(:final remaining) =>
    'Ready in ${remaining.inDays}d ${remaining.inHours % 24}h',
  Started(:final elapsed) => 'Ready since ${elapsed.inHours}h ago',
  Ended() => 'Batch ended',
};
