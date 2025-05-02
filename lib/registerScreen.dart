part of 'demo.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.background,
        body: Container(
            alignment: Alignment.center,
            child:
            Stack( children: [
              Align(alignment: const Alignment(0, 0),
                child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //текст вход
                     Text("Регистрация",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 40,
                            decorationStyle: TextDecorationStyle.double,
                            color:  Theme.of(context).colorScheme.background,
                        )
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical:25),
                      width: MediaQuery
                          .sizeOf(context)
                          .width / 2,
                      child: TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: const InputDecoration(
                          hintText: "Введите Имя пользователя",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    //первое поле ввода
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical:25),
                      width: MediaQuery
                          .sizeOf(context)
                          .width / 2,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: const InputDecoration(
                          hintText: "Введите email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    //второе поле ввода
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 45),
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode, // Привязываем FocusNode
                          decoration: const InputDecoration(
                            hintText: "Введите пароль",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                    ),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width / 2,
                        //действия кнопки авторизации
                        child: ElevatedButton(onPressed:  () async {

                          String username = _usernameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          _emailFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          // Проверка данных
                          if (email.isEmpty || password.isEmpty ||username.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
                            );
                            return;
                          }

                          try {
                            // Авторизация пользователя
                            await apiService.register(username, email, password);
                            print('User registered');

                            // уведомление о регистрации
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пользователь зарегистрирован')),
                            );

                            // Очистка TextField
                            _usernameController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                          } catch (e) {
                            print('Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                            ),
                            child: const Text("ЗАРЕГИСТРИРОВАТЬСЯ", style: TextStyle(fontSize: 15,color: Colors.white))
                        )
                    ),
                  ],
                ),),
              Align(alignment: const Alignment(0, 1),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/');
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Войти'),
                ),)
            ])
        ));
  }
  //очищение фокуса и контроллеров
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose(); // Очищаем контроллер
    dispose();
  }
}