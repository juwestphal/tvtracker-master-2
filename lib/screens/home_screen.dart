import 'package:flutter/material.dart';
import 'movies_tab_screen.dart'; // Importa a tela de filmes
import 'series_tab_screen.dart'; // Importa a tela de séries
import 'profile_screen.dart'; // Importa a tela de perfil
import 'search_screen.dart'; // Importa a tela de pesquisa

// HomeScreen agora aceita um parâmetro `userId`
class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, this.userId = ''});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Agora podemos usar widget.userId para acessar o ID do usuário
  late final List<Widget> _screens = [
    const MoviesTabScreen(), // Tela de filmes
    const SeriesTabScreen(), // Tela de séries
    const SearchScreen(), // Tela de pesquisa
    ProfileScreen(userId: widget.userId), // Passa o userId para o perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice da aba selecionada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Séries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
      ),
    );
  }
}
