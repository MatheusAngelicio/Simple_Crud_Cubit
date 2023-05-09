import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/edit_my_user_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/ui/widgets/custom_image.dart';
import '../model/my_user.dart';

class EditMyUserScreen extends StatelessWidget {
  const EditMyUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // verifico se passou algum parametro
    final userToEdit = ModalRoute.of(context)?.settings.arguments as MyUser?;

    return BlocProvider(
      // quando eu crio o blocProvider, eu falo qual usuario estou usando no cubit
      create: (context) => EditMyUserCubit(userToEdit),
      child: Scaffold(
        appBar: AppBar(
          title: Text(userToEdit != null ? 'Edit user' : 'Create user'),
          actions: [
            Builder(
              builder: (context) {
                return Visibility(
                  // se Estou editando, entao posso ver o botoa de apagar
                  // se nao posso ver
                  visible: userToEdit != null,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<EditMyUserCubit>().deleteMyUser();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<EditMyUserCubit, EditMyUserState>(
          listener: (context, state) {
            if (state.isDone) {
              // ou seja, quando terminar de salvar/editar o usuario
              // vou voltar uma tela (Tela que mostra os usuarios)
              Navigator.of(context).pop();
            }
          },
          // aqui é como se fosse o observe
          builder: (_, state) {
            return Stack(
              children: [
                _MyUserSection(
                  user: userToEdit,
                  pickedImage: state.pickedimage,
                  isSaving: state.isLoading,
                ),
                if (state.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MyUserSection extends StatefulWidget {
  final MyUser? user;
  final File? pickedImage;
  final bool isSaving;

  const _MyUserSection({
    this.user,
    this.pickedImage,
    required this.isSaving,
  });

  @override
  _MyUserSectionState createState() => _MyUserSectionState();
}

class _MyUserSectionState extends State<_MyUserSection> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    // se eu passar user, quer dizer que vou editar o usuario
    // entao se tiver user, irei mostrar as propriedades
    _nameController.text = widget.user?.name ?? '';
    _lastNameController.text = widget.user?.lastName ?? '';
    _ageController.text = widget.user?.age.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fazer com que o singleChildScrollView ocupe a tela inteira
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    // primeiro buscar o cubit
                    final editCubit = context.read<EditMyUserCubit>();
                    // depois escolher uma imagem da galeria
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    // se a imagem nao for nula, entao vou guarda-la no cubit
                    if (pickedImage != null) {
                      editCubit.setImage(File(pickedImage.path));
                    }
                  },
                  child: Center(
                    //ClipOval para deixar a imagem como um circulo
                    child: ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CustomImage(
                            imageFile: widget.pickedImage,
                            imageUrl: widget.user?.image),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(height: 8),
                // Se estou salvando, quero que o botao nao faça nada
                ElevatedButton(
                  onPressed: widget.isSaving
                      ? null
                      : () {
                          // aqui eu chamo saveMyUserCubit para salvar
                          context.read<EditMyUserCubit>().saveMyUser(
                              _nameController.text,
                              _lastNameController.text,
                              int.tryParse(_ageController.text) ?? 0);
                        },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
