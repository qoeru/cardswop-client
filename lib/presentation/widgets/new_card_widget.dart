import 'dart:typed_data';
import 'package:cardswop/presentation/bloc/cubit/adding_card/adding_card_cubit.dart';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class NewCardWidget extends StatefulWidget {
  const NewCardWidget({super.key});

  @override
  State<NewCardWidget> createState() => _NewCardWidgetState();
}

class _NewCardWidgetState extends State<NewCardWidget> {
  int currentStep = 0;
  Map<String, Uint8List> pictures = {};
  bool isVisibleTooBigImage = false;
  bool isVisibleMaxImages = false;

  void _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);

    if (pickedImage != null) {
      var pickedImageAsBytes = await pickedImage.readAsBytes();
      var lengthInMB = pickedImageAsBytes.lengthInBytes / 1024.0 / 1024.0;
      if (lengthInMB >= 2) {
        isVisibleTooBigImage = true;
        return;
      }
      pictures[pickedImage.name] = pickedImageAsBytes;
    }
    setState(() {});
  }

  Widget pictureTile(int index, String pictureName, Uint8List picture) {
    return Stack(alignment: Alignment.topRight, children: [
      SizedBox(
        child: Image.memory(
          picture,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
      IconButton(
          onPressed: () {
            setState(() {
              pictures.remove(pictureName);
            });
          },
          icon: const Icon(EvaIcons.trash2)),
    ]);
  }

  final sizeController = TextEditingController();

  bool isSeries = false;

  Widget seriesPicker() {
    return const Placeholder();
  }

  Widget otherCardsPicker() {
    return const Placeholder();
  }

  bool isDifferentVersions = false;

  Widget detailsWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isDifferentVersions,
                  onChanged: (value) {
                    setState(() {
                      isDifferentVersions = value!;
                    });
                  },
                ),
                const Text('У этой карточки есть другие версии'),
              ],
            ),
            if (isDifferentVersions) otherCardsPicker(),
            const Divider(),
            Row(
              children: [
                Checkbox(
                  value: isSeries,
                  onChanged: (value) {
                    setState(() {
                      isSeries = value!;
                    });
                  },
                ),
                const Text('Эта карточка является частью серии'),
              ],
            ),
            if (isSeries) seriesPicker(),
          ],
        ));
  }

  Widget sizeWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('63x88мм'),
            value: '63x88мм',
            groupValue: size,
            onChanged: (value) {
              setState(() {
                size = value!;
              });
            },
          ),
          RadioListTile(
            title: const Text('Другое'),
            value: sizeController.text,
            groupValue: size,
            onChanged: (value) {
              setState(() {
                size = value!;
              });
            },
          ),
          if (size != '63x88мм')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Form(
                key: formKeySize,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Ваш размер'),
                  validator: (value) {
                    if ((value == null || value.isEmpty) && size != '63x88мм') {
                      return 'Поле не должно быть пустым';
                    }
                    return null;
                  },
                  controller: sizeController,
                ),
              ),
            ),
        ],
      ),
    );
  }

  //TODO: ДОБАВИТЬ ПРОВЕРКУ НА ПНГ И ДЖПГ
  Widget cardDropZone() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(
              BorderSide(color: Theme.of(context).colorScheme.outline))),
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: pictures.length,
            // controller: _pageScrollController,
            // scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: pictureTile(
                  index,
                  pictures.keys.elementAt(index),
                  pictures.values.elementAt(index),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(EvaIcons.plus),
            onPressed: pictures.length >= 3
                ? null
                : () {
                    _pickImage();
                  },
          ),
        ],
      ),
    );
  }

  int limitedness = 0;

  List<String> material = ['Картон'];

  Widget materialWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: [
              FilterChip(
                  selected: material.contains('Картон'),
                  label: const Text('Картон'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Картон')
                          : material.remove('Картон');
                    });
                  }),
              FilterChip(
                  selected: material.contains('Ламинация'),
                  label: const Text('Ламинация'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Ламинация')
                          : material.remove('Ламинация');
                    });
                  }),
              FilterChip(
                  selected: material.contains('Пластик'),
                  label: const Text('Пластик'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Пластик')
                          : material.remove('Пластик');
                    });
                  }),
              FilterChip(
                  selected: material.contains('Голография'),
                  label: const Text('Голография'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Голография')
                          : material.remove('Голография');
                    });
                  }),
              FilterChip(
                  selected: material.contains('Спецэффекты'),
                  label: const Text('Спецэффекты'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Спецэффекты')
                          : material.remove('Спецэффекты');
                    });
                  }),
              FilterChip(
                  selected: material.contains('Другое'),
                  label: const Text('Другое'),
                  onSelected: (value) {
                    setState(() {
                      value
                          ? material.add('Другое')
                          : material.remove('Другое');
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }

  String size = '63x88мм';

  var formKeyGeneral = GlobalKey<FormState>(debugLabel: 'general');
  var formKeyDetails = GlobalKey<FormState>(debugLabel: 'details');
  var formKeySize = GlobalKey<FormState>(debugLabel: 'size');

  Widget limitednessWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('Регулярная'),
            value: 0,
            groupValue: limitedness,
            onChanged: (value) {
              setState(() {
                limitedness = value!;
              });
            },
          ),
          RadioListTile(
            title: const Text('Лимитированная'),
            value: 1,
            groupValue: limitedness,
            onChanged: (value) {
              setState(() {
                limitedness = value!;
              });
            },
          ),
          RadioListTile(
            title: const Text('Особенная'),
            value: 2,
            groupValue: limitedness,
            onChanged: (value) {
              setState(() {
                limitedness = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final exchangeValueController = TextEditingController();

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'main');

  String? defaultExchangeValue;

  Widget rulesColumn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 200,
      child: Column(
        children: [
          Text(
            'Правила',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text(
              'sdfhkdsjhkdsjhdsfjkhsdjkfhkjfdsahsdjkhadfjkshjksdfhjksadhasjkfhjkahkjlfadshjdsfkfhkjlfdahjkdsfhdsafjkladsk'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<AuthCubit>().state;
    if (state is LoggedIn) {
      if (state.user.defaultExchangeValue != null) {
        defaultExchangeValue = state.user.defaultExchangeValue;
      }
    }
    return BlocListener<AddingCardCubit, AddingCardState>(
      listener: (context, state) {
        if (state is AddingCardSuccess) {
          context.goNamed('card', pathParameters: {'cardId': state.card.id});
        }
      },
      child: Row(
        children: [
          rulesColumn(context),
          const VerticalDivider(),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: ResponsiveBreakpoints.of(context).isDesktop
                        ? 700
                        : (ResponsiveBreakpoints.of(context).isTablet
                            ? 500
                            : 350),
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(BorderSide(
                            color: Theme.of(context).colorScheme.outline))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stepper(
                          stepIconBuilder: (stepIndex, stepState) {
                            if (stepIndex == currentStep) {
                              return CircleAvatar(
                                // radius: 50,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  EvaIcons.editOutline,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              );
                            }
                            if (stepIndex < currentStep) {
                              return CircleAvatar(
                                // radius: 50,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  EvaIcons.checkmark,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              );
                            }
                            return null;
                          },
                          controlsBuilder: (context, details) {
                            return OverflowBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                if (currentStep != 6)
                                  ElevatedButton(
                                      onPressed:
                                          (currentStep == 1 && pictures.isEmpty)
                                              ? null
                                              : details.onStepContinue,
                                      child: const Text('Далее')),
                                if (currentStep == 6)
                                  ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      child: const Text('Завершить')),
                                const SizedBox(
                                  width: 8,
                                ),
                                TextButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text('Назад'))
                              ],
                            );
                          },
                          onStepCancel: currentStep == 0
                              ? null
                              : () {
                                  setState(() {
                                    currentStep--;
                                  });
                                },
                          onStepContinue: () {
                            if (currentStep == 0) {
                              if (formKeyGeneral.currentState!.validate()) {
                                setState(() {
                                  currentStep++;
                                });
                              } else {
                                return;
                              }
                            } else if (currentStep == 4) {
                              if (size != '63x88мм') {
                                if (formKeySize.currentState!.validate()) {
                                  setState(() {
                                    currentStep++;
                                  });
                                }
                              } else {
                                setState(() {
                                  currentStep++;
                                });
                              }
                            } else if (currentStep == 5) {
                              if (formKeyDetails.currentState!.validate()) {
                                setState(() {
                                  currentStep++;
                                });
                              }
                            } else if (currentStep == 6) {
                              context.read<AddingCardCubit>().createCard(
                                  pictures,
                                  nameController.text,
                                  exchangeValueController.text,
                                  size,
                                  false,
                                  descriptionController.text,
                                  limitedness,
                                  null,
                                  material,
                                  isDifferentVersions,
                                  null,
                                  context);
                            } else {
                              setState(() {
                                currentStep++;
                              });
                            }
                          },
                          currentStep: currentStep,
                          steps: [
                            Step(
                              title: const Text('Основное'),
                              content: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 16),
                                child: Form(
                                  key: formKeyGeneral,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Поле не должно быть пустым';
                                          }
                                          return null;
                                        },
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            label: Text('Название')),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      // const Divider(),
                                      TextFormField(
                                        maxLines: 6,
                                        minLines: 3,
                                        controller: descriptionController,
                                        decoration: const InputDecoration(
                                            hintText: 'Описание',
                                            helperText: 'Необязательно'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Step(
                              title: const Text('Картинки'),
                              content: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 16),
                                child: cardDropZone(),
                              ),
                            ),
                            Step(
                                title: const Text('Лимитированность'),
                                content: limitednessWidget(context)),
                            Step(
                                title: const Text('Материал'),
                                content: materialWidget()),
                            Step(
                                title: const Text('Размер'),
                                content: sizeWidget()),
                            Step(
                              title: const Text('Детали'),
                              content: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 16),
                                child: Form(
                                  key: formKeyDetails,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Поле не должно быть пустым';
                                          }
                                          return null;
                                        },
                                        controller: exchangeValueController,
                                        maxLines: 6,
                                        minLines: 3,
                                        decoration: const InputDecoration(
                                          hintText: 'Меняюсь на...',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      if (defaultExchangeValue != null)
                                        FilledButton(
                                            onPressed: () {
                                              exchangeValueController.text =
                                                  defaultExchangeValue!;
                                            },
                                            child: const Text(
                                                'Вставить значение по умолчанию')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Step(
                                title: const Text('Детали'),
                                content: detailsWidget()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
