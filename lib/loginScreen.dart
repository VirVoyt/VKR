//страница с входа
part of 'demo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final loginData = await AuthService.loadLoginData();
    if (loginData['rememberMe'] == true) {
      setState(() {
        _emailController.text = loginData['username'] ?? '';
        _passwordController.text = loginData['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.brightness_6),
                  onPressed: () {
                    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                    themeNotifier.toggleTheme();
                  },
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: SingleChildScrollView(
                  child: Container(
                    width:  MediaQuery.sizeOf(context).width -  MediaQuery.sizeOf(context).width/4,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSecondary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Вход",
                          style: TextStyle(
                            fontSize: 40,
                            decorationStyle: TextDecorationStyle.double,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            cursorColor: Theme.of(context).colorScheme.secondary,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              hintText: "Введите email",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            onSubmitted: (_) {
                              _emailFocusNode.unfocus();
                              FocusScope.of(context).requestFocus(_passwordFocusNode);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: true,
                            cursorColor: Theme.of(context).colorScheme.secondary,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              hintText: "Введите пароль",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            onSubmitted: (_) => _login(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text(
                              "Запомнить меня",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              "АВТОРИЗОВАТЬСЯ",
                              style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    try {
      final token = await apiService.login(email, password);

      if (_rememberMe) {
        await AuthService.saveLoginData(email, password);
      } else {
        await AuthService.clearLoginData();
      }

      Navigator.pushNamed(
        context,
        '/app',
        arguments: token['token'],
      );
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }
}