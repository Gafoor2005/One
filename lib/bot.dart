import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final discordServiceProvider = Provider((ref) => DiscordService());

class DiscordService {
  final String _baseUrl = 'https://discord.com/api/v10';
  final String _botToken = dotenv.env['BOT_TOKEN']!;
  final String _channelId = dotenv.env['CHANNEL_ID']!;
  Future<void> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl/channels/$_channelId/messages');
      final headers = {
        'Authorization': 'Bot $_botToken',
        'Content-Type': 'application/json'
      };
      final body = jsonEncode({'content': message});

      await http.post(url, headers: headers, body: body);
      // final response = await http.post(url, headers: headers, body: body);

      // if (response.statusCode == 200) {
      //   print('Message sent successfully!');
      // } else {
      //   print('Error sending message: ${response.statusCode}');
      //   // Handle errors appropriately
      // }
    } catch (e) {
      // hello
    }
  }
}
