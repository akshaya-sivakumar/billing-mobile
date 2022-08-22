import 'package:billing/bloc/branch_bloc/branch_bloc.dart';
import 'package:billing/bloc/login_bloc/login_bloc.dart';
import 'package:billing/bloc/signup_bloc/signup_bloc.dart';
import 'package:billing/screens/admin/admin_panel.dart';
import 'package:billing/screens/admin/branches.dart';
import 'package:billing/screens/admin/new_item_create.dart';
import 'package:billing/screens/admin/users.dart';
import 'package:billing/screens/dashboard.dart';
import 'package:billing/screens/login.dart';
import 'package:billing/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  if (settings.name == LoginScreen.routeName) {
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginScreen(),
            ));
  } else if (settings.name == Signup.routeName) {
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => SignupBloc(),
              child: Signup(),
            ));
  } else if (settings.name == Dashboard.routeName) {
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => SignupBloc(),
              child: Dashboard(),
            ));
  } else if (settings.name == NewItemCreatePage.routeName) {
    return MaterialPageRoute(builder: (_) => const NewItemCreatePage());
  } else if (settings.name == AdminPanel.routeName) {
    return MaterialPageRoute(builder: (_) => const AdminPanel());
  } else if (settings.name == Branches.routeName) {
    return MaterialPageRoute(builder: (_) => const Branches());
  } else if (settings.name == Users.routeName) {
    return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => BranchBloc(),
                ),
                BlocProvider(
                  create: (context) => SignupBloc(),
                ),
              ],
              child: const Users(),
            ));
  } else {
    return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error PAge"),
      ),
      body: const Center(
        child: Text('Page Not Found'),
      ),
    );
  });
}
