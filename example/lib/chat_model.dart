class ChatModel {
  ChatModel({
    this.content,
    this.isSender = false,
  });
  String? content;
  bool isSender;

  List<ChatModel> initContent() {
    return [
      ChatModel(content: 'Hi Cien', isSender: true),
      ChatModel(content: 'What’s your favorite sport?', isSender: true),
      ChatModel(
        content: 'I like football. I watch the games on TV all the time.',
      ),
      ChatModel(content: 'Who’s your favorite team?', isSender: true),
      ChatModel(content: 'The Manchester United.'),
      ChatModel(
        content: 'They’re really good this year, aren’t they?',
        isSender: true,
      ),
      ChatModel(content: 'Yes. Do you like them?'),
      ChatModel(content: 'Yes. Everyone around here does.', isSender: true),
      ChatModel(content: 'Do you think they’ll win the championship this year?'),
      ChatModel(content: 'Hmm...', isSender: true),
      ChatModel(content: 'It’s possible. They have some really good players.', isSender: true),
      ChatModel(content: 'Did you watch the game last night?'),
      ChatModel(content: 'A little, not the whole thing. I watched the second half though and I saw some ofthe highlights online.', isSender: true),
      ChatModel(content: 'It was a great game, wasn’t it?'),
      ChatModel(content: 'Yeah. Do you know who they’re playing tomorrow night?', isSender: true),
      ChatModel(content: 'I think they’re playing Chelsea.'),
      ChatModel(content: 'That’s going to be a tough game. Chelsea has a good team.', isSender: true),
    ];
  }
}
