import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
// import 'package:cardswop/globals.dart' as globals;

class StepTwoWidget extends StatelessWidget {
  const StepTwoWidget(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.usernameController,
      required this.formKey});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final GlobalKey<FormState> formKey;

  Widget textFormField(String label, TextEditingController editingController,
      BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не должно быть пустым';
        }
        return null;
      },
      controller: editingController,
      decoration: InputDecoration(label: Text(label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textFormField('Юзернейм', usernameController, context),
            const Divider(),
            textFormField('Email', emailController, context),
            const Divider(),
            PasswordField(passwordController: passwordController),
          ],
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не должно быть пустым';
        }
        return null;
      },
      obscureText: !showPassword,
      controller: widget.passwordController,
      decoration: InputDecoration(
          label: const Text('Пароль'),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: showPassword
                  ? const Icon(
                      EvaIcons.eyeOutline,
                      // size: 16,
                    )
                  : const Icon(
                      EvaIcons.eyeOff2Outline,
                      // size: ,
                    ))),
    );
  }
}

class RegWidget extends StatefulWidget {
  const RegWidget({super.key});

  @override
  State<RegWidget> createState() => _RegWidgetState();
}

class _RegWidgetState extends State<RegWidget> {
  Widget tile(TextEditingController cityController, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым';
                }
                return null;
              },
              controller: cityController,
              decoration: const InputDecoration(hintText: 'Ваш город'),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
                onPressed: cityControllers.length == 1
                    ? null
                    : () {
                        setState(() {
                          cityControllers.removeAt(index);
                          // cityControllers[index].text = '';
                        });
                      },
                icon: const Icon(EvaIcons.trash2Outline)),
          ),
        ],
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final List<TextEditingController> cityControllers = [TextEditingController()];

  final TextEditingController galleryLinkController = TextEditingController();
  final TextEditingController contactLinkController = TextEditingController();

  final TextEditingController exchangeValueController = TextEditingController();

  final formKeyOne = GlobalKey<FormState>(debugLabel: 'step one');
  final formKeyTwo = GlobalKey<FormState>(debugLabel: 'step two');
  final formKeyThree = GlobalKey<FormState>(debugLabel: 'step three');
  final formKeyFour = GlobalKey<FormState>(debugLabel: 'cities');

  int currentStep = 0;

  int mailExchange = 1;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.fromBorderSide(
                  BorderSide(color: Theme.of(context).colorScheme.outline))),
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Регистрация',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  FilledButton(
                      onPressed: () {
                        context.goNamed('login');
                      },
                      child: const Text('Вход')),
                ],
              ),
              const Divider(),
              Stepper(
                stepIconBuilder: (stepIndex, stepState) {
                  if (currentStep == stepIndex) {
                    return CircleAvatar(
                      // radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        EvaIcons.editOutline,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  } else if (stepIndex < currentStep) {
                    return CircleAvatar(
                      // radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        EvaIcons.checkmark,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  }
                  return null;
                },
                onStepTapped: null,
                controlsBuilder: (context, details) {
                  return OverflowBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      if (currentStep != 3)
                        ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Далее')),
                      if (currentStep == 3)
                        ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Создать аккаунт')),
                      const SizedBox(
                        width: 8,
                      ),
                      TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Назад'))
                    ],
                  );
                },
                currentStep: currentStep,
                type: StepperType.vertical,
                onStepContinue: () {
                  setState(() {
                    if (currentStep == 0 &&
                        formKeyOne.currentState!.validate()) {
                      setState(() {
                        currentStep++;
                      });
                    } else if (currentStep == 1 &&
                        formKeyTwo.currentState!.validate()) {
                      currentStep++;
                    } else if (currentStep == 2 &&
                        formKeyThree.currentState!.validate()) {
                      currentStep++;
                    } else if (currentStep == 3) {
                      List<String> cityTexts = List<String>.generate(
                          cityControllers.length,
                          (index) => cityControllers[index].text);

                      context.read<AuthCubit>().tryToRegister(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          cityTexts,
                          mailExchange,
                          contactLinkController.text,
                          galleryLinkController.text,
                          exchangeValueController.text);
                    }
                  });
                },
                onStepCancel: currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          currentStep--;
                        });
                      },
                steps: [
                  Step(
                      // STEP 1
                      title: const Text('Данные аккаунта'),
                      content: StepTwoWidget(
                        emailController: emailController,
                        passwordController: passwordController,
                        usernameController: usernameController,
                        formKey: formKeyOne,
                      )),
                  Step(
                      // STEP 2
                      title: const Text('Почта'),
                      content: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Form(
                            key: formKeyTwo,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Form(
                                  key: formKeyFour,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListView.builder(
                                        itemCount: cityControllers.length,
                                        shrinkWrap: true,
                                        itemBuilder: ((context, index) {
                                          return tile(
                                              cityControllers[index], index);
                                        }),
                                      ),
                                      IconButton(
                                          onPressed: cityControllers.length >= 5
                                              ? null
                                              : () {
                                                  if (formKeyFour.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      cityControllers.add(
                                                          TextEditingController());
                                                    });
                                                  }
                                                },
                                          icon: const Icon(EvaIcons.plus)),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  'Обмен почтой',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                DropdownButton(
                                    focusColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    isExpanded: true,
                                    // isDense: true,
                                    value: mailExchange,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 1, child: Text('Уточнять')),
                                      DropdownMenuItem(
                                          value: 0, child: Text('Да')),
                                      DropdownMenuItem(
                                          value: 2, child: Text('Нет')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        mailExchange = value!;
                                      });
                                    }),
                              ],
                            ),
                          ))),
                  Step(
                      // STEP 3
                      // Контакты
                      title: const Text('Контакты'),
                      content: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Form(
                            key: formKeyThree,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Поле не должно быть пустым';
                                    }
                                    return null;
                                  },
                                  controller: contactLinkController,
                                  decoration: const InputDecoration(
                                      hintText: 'Любой контакт',
                                      helperText: 'Ссылка'),
                                ),
                                const Divider(),
                                TextFormField(
                                  controller: galleryLinkController,
                                  decoration: const InputDecoration(
                                      hintText: 'Творческая галерея',
                                      helperText: 'Ссылка, необязательно'),
                                ),
                              ],
                            ),
                          ))),
                  Step(
                      title: const Text('Детали'),
                      content: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          minLines: 3,
                          maxLines: 6,
                          controller: exchangeValueController,
                          decoration: const InputDecoration(
                              hintText: 'Я обычно меняюсь на',
                              helperText: 'Необязательно'),
                        ),
                      ))
                ],
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoggedIn) {
                    context.goNamed('feed');
                  }
                },
                builder: (context, state) {
                  if (state is RegFailedEmailExist) {
                    return const Text('Аккаунт с данной почтой уже существует');
                  }
                  if (state is RegFailed) {
                    return const Text('Ошибка: некорректные данные');
                  }
                  if (state is RegFailedUsernameExists) {
                    return const Text('Аккаунт с данным именем уже существует');
                  }
                  if (state is RegFailedWeakPassword) {
                    return const Text('Слишком слабый пароль');
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
