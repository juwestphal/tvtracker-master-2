import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  List<dynamic> comments = [];
  List<dynamic> users = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchData() async {
    if (!mounted) return;

    bool hasError = false;
    dynamic error;

    // Indicate that data is being loaded
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Manually specified list of movie IDs
      final List<String> movieIds = [
        '67945b2fc695558af85211fe',
        '67945b3ac695558af8521200',
        '67945b45c695558af8521202',
        '67945b4dc695558af8521204',
        '67945b57c695558af8521206',
        '67945b64c695558af8521208',
        '67945b79c695558af852120c',
        '67945b82c695558af852120e',
        '67945b88c695558af8521210',
        '67945b99c695558af8521212',
        '67945ba6c695558af8521214',
        '67945bb0c695558af8521216',
        '67945bb7c695558af8521218',
        '67945bbec695558af852121a',
        '67945bc8c695558af852121c',
        '67945bcfc695558af852121e',
        '67945bdac695558af8521224',
        // Add more movie IDs as needed
      ];

      final allComments = <dynamic>[];

      // Loop through each manually specified movie ID and fetch its comments
      for (final movieId in movieIds) {
        if (movieId.isEmpty) {
          // Skip if the movie ID is invalid
          continue;
        }
        try {
          final movieComments = await APIService().fetchComments(movieId);

          // Ensure the comment fields are valid before adding them to the list
          for (var comment in movieComments) {
            if (comment['content'] != null && comment['user'] != null) {
              allComments.add(comment);
            }
          }
        } catch (e) {
          if (e.toString().contains('404')) {
            // Skip movies not found
            continue;
          } else {
            // Log or handle unexpected errors
            rethrow;
          }
        }
      }

      // Store the accumulated comments
      comments = allComments;

      // Fetch all users
      users = await APIService().fetchAllUsers();
    } catch (e) {
      // If any unexpected error occurs, set the error message
      hasError = true;
      error = e;
    }

    // Indicate that loading is done, handle errors if any
    if (!mounted) return;
    setState(() {
      isLoading = false;
      if (hasError) {
        errorMessage = 'Erro ao carregar dados: $error';
      }
    });
  }

  Future<void> deleteComment(String commentId) async {
    if (!mounted) return;

    try {
      await APIService().deleteComment('dummy_movie_id', commentId);
      await fetchData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir comentário: $e')),
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    if (!mounted) return;

    try {
      await APIService().deleteUserAccount(userId);
      // Update the local list, removing the user who was deleted
      setState(() {
        users.removeWhere((user) => user['_id'] == userId);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir usuário: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gerir Comentários',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: comments.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = comments[index];
                                    final content = comment['content'] ??
                                        'Comentário indisponível';
                                    final user = comment['user'] ??
                                        'Usuário desconhecido';
                                    final commentId = comment['_id'];
                                    return ListTile(
                                      title: Text(content),
                                      subtitle: Text(user),
                                      trailing: commentId != null
                                          ? IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  deleteComment(commentId),
                                            )
                                          : null,
                                    );
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Nenhum comentário encontrado.'),
                                ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gerir Usuários',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: users.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    final user = users[index];
                                    final userName =
                                        user['name'] ?? 'Nome não disponível';
                                    final userEmail =
                                        user['email'] ?? 'Email não disponível';
                                    final userId = user['_id'];
                                    return ListTile(
                                      title: Text(userName),
                                      subtitle: Text(userEmail),
                                      trailing: userId != null
                                          ? IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  deleteUser(userId),
                                            )
                                          : null,
                                    );
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Nenhum usuário encontrado.'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
