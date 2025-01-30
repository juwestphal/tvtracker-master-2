import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/series.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';

class CommentsSeriesScreen extends StatefulWidget {
  final Series series;

  const CommentsSeriesScreen({super.key, required this.series});

  @override
  CommentsSeriesScreenState createState() => CommentsSeriesScreenState();
}

class CommentsSeriesScreenState extends State<CommentsSeriesScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> comments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    setState(() => isLoading = true);
    try {
      if (widget.series.id == null) {
        throw Exception('Series ID is null');
      }
      final fetchedComments =
          await APIService().fetchSeriesComments(widget.series.id!);
      if (!mounted) return;
      setState(() {
        comments = fetchedComments;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar comentários: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> addComment() async {
    final commentText = _commentController.text;
    if (commentText.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await APIService().createSeriesComment(widget.series.id!, commentText);
      _commentController.clear();
      setState(() {
        comments.add({
          'comment': commentText,
          'user': {'name': 'Você'}
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar comentário: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comentários',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Digite seu comentário...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: addComment,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Outros comentários',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final reviewerName =
                          comment['user']?['name'] ?? 'Anônimo';
                      final reviewerComment =
                          comment['comment'] ?? 'Comentário indisponível';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.person,
                                color: Colors.white70, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$reviewerName: $reviewerComment',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
