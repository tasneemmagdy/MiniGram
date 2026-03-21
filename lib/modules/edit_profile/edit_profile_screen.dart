import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/core/component/constant.dart';
import 'package:mini_gram/cubit/app_cubit/cubit.dart';
import 'package:mini_gram/cubit/app_cubit/states.dart';
import 'package:mini_gram/cubit/profile_cubit/cubit.dart';
import 'package:mini_gram/cubit/profile_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final profileCubit = ProfileCubit.get(context);
        final userModel = profileCubit.modell ?? UserCubit.get(context).modell;

        if (userModel == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        nameController.text = userModel.name ?? '';
        bioController.text = userModel.bio ?? '';
        emailController.text = userModel.email ?? '';
        phoneController.text = userModel.phone ?? '';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(s.editProfile),
            actions: [
              IconButton(
                onPressed: () {
                  var cubit = AppCubit.get(context);
                  if (cubit.locale.languageCode == 'en') {
                    cubit.changeLanguage('ar');
                  } else {
                    cubit.changeLanguage('en');
                  }
                },
                icon: const Icon(Icons.language),
              ),
              BlocBuilder<AppCubit, AppStates>(
                builder: (context, appState) {
                  final isDark = AppCubit.get(context).isDark;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.dark,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.appBarTheme.titleTextStyle?.color,
                        ),
                      ),
                      Switch(
                        value: isDark,
                        activeColor: colorScheme.primary,
                        onChanged: (_) {
                          AppCubit.get(context).changeAppMode(null);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (state is ProfileUserUpdateLoadingState ||
                    state is ProfileUserUpdateAllLoadingState)
                  LinearProgressIndicator(color: colorScheme.primary),

                const SizedBox(height: 20),

                // Cover + Profile Images
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Cover
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.surfaceVariant,
                        image: DecorationImage(
                          image: profileCubit.coverImage != null
                              ? FileImage(profileCubit.coverImage!) as ImageProvider
                              : (userModel.coverImage != null && userModel.coverImage!.isNotEmpty)
                                  ? NetworkImage(userModel.coverImage!)
                                  : const AssetImage('assets/images/default_cover.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => profileCubit.pickCoverImage(),
                          icon: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.camera_alt_outlined, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Profile avatar
                    Positioned(
                      bottom: -5,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: colorScheme.surfaceVariant,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: profileCubit.profileImage != null
                                  ? FileImage(profileCubit.profileImage!) as ImageProvider
                                  : (userModel.image != null && userModel.image!.isNotEmpty)
                                      ? NetworkImage(userModel.image!)
                                      : const AssetImage('assets/images/default_profile.png'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: colorScheme.primary,
                              child: IconButton(
                                onPressed: () => profileCubit.pickProfileImage(),
                                icon: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildFieldCard(context, s.name, nameController, Icons.person),
                _buildFieldCard(context, s.email, emailController, Icons.email),
                _buildFieldCard(context, s.bio, bioController, Icons.info_outline),
                _buildFieldCard(context, s.phone, phoneController, Icons.phone),

                const SizedBox(height: 10),

                Row(
                  children: [
                    // Update Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          profileCubit.updateProfile(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            bio: bioController.text,
                          );
                        },
                        icon: const Icon(Icons.save),
                        label: Text(
                          s.updateProfile,
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: () => signOut(context),
                      icon: const Icon(Icons.logout),
                      label: Text(s.logout),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldCard(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: defaultFormField(
        controller: controller,
        type: TextInputType.text,
        inputAction: TextInputAction.next,
        validate: (value) =>
            value == null || value.isEmpty ? '${s.pleaseEnter} $label' : null,
        lable: label,
        prefix: icon,
      ),
    );
  }
}