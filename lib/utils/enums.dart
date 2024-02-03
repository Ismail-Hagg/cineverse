enum LogState { none, info, full }

enum Gender { male, female, undecided }

enum LoginMethod { google, email, phone, none }

enum AvatarType { local, online, none }

enum ChosenTheme { light, dark, system }

enum ApiType { rest, graphql }

enum FirebaseUserPaths {
  favorites,
  watchlist,
  chat,
  keeping,
  comments,
  notifications
}

enum FirebaseMainPaths { users, keeping, comments, other }

enum CommentState { read, update, upload, delete }

enum NotificationType {
  newEpisode,
  releaseDate,
  showEnded,
  followed,
  followerAction,
  comment,
  chatMessage
}

enum FilterChoice { movie, tv, none }

enum CommentOrder {
  replies,
  mostLikes,
  leastLikes,
  timeRecent,
  timeOld,
}

enum FieldType {
  loginEmail,
  loginPass,
  signupEmail,
  signupPass,
  signupUser,
  signupBirth
}
