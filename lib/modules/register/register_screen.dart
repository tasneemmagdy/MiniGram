import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/layout/app_layout_screen.dart';
import 'package:mini_gram/modules/register/cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart'; 

import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var passwordController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => MiniGramRegisterCubit(),
      child: BlocConsumer<MiniGramRegisterCubit, MiniGramRegisterStates>(
        listener: (context, state) {
          if (state is MiniGramCreateUserSuccessState) {
            navigateAndFinish(context, MiniGramLayout());
          }
        },
        builder: (context, state) {
          final s = S.of(context); 

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.registerTitle, 
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),                        ),
                        Text(
                          s.registerSubtitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w400,
      ),
      ),
                        
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.userName,
                            hintText: 'Ahmed',
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.nameValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.emailAddress,
                            hintText: 'example@domain.com',
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.emailValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.password,
                            hintText: '************',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                MiniGramRegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              icon: Icon(
                                MiniGramRegisterCubit.get(context).suffix,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.passwordValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText:
                              MiniGramRegisterCubit.get(context).isPassword,
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.phoneNumber,
                            hintText: '0123456789',
                            prefixIcon: const Icon(Icons.phone_android),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.phoneValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 30.0),
                        ConditionalBuilder(
                          condition: state is! MiniGramRegisterLoadingState,
                          builder: (context) => Center(
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    MiniGramRegisterCubit.get(context)
                                        .userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                child: Text(
                                  s.registerButton.toUpperCase(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, 
                                ),
                              ),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}