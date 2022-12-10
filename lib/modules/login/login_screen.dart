import 'package:app_center_agent/modules/login/login_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = LoginStore(buildContext: context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login to AppCenter',
              style: context.theme.appBarTheme.titleTextStyle,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: store.formKey,
                child: TextFormField(
                  controller: store.controller,
                  validator: store.validate,
                  onSaved: store.onSaved,
                  decoration: InputDecoration(
                    hintText: 'App Center Auth Token',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: store.submit,
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color:
                            context.theme.inputDecorationTheme.suffixIconColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
