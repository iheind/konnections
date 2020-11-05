import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    Key key,
    @required this.builder,
    this.userProvidersBuilder,
  }) : super(key: key);

  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  final List<SingleChildWidget> Function(BuildContext, User)
  userProvidersBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: userProvidersBuilder != null
                ? userProvidersBuilder(context, user)
                : [],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
