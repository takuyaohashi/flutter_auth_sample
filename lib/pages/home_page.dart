import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/authenticator.dart';
import '../l10n.dart';
import '../models/models.dart';
import '../pages/user_setting_page.dart';

class _ViewModel extends ChangeNotifier {
  _ViewModel({@required this.auth});
  final Authenticator auth;

  UserDoc _account;

  UserDoc get account => _account;

  @override
  void dispose() {
    super.dispose();
  }
}

class ChangeNameForm extends StatefulWidget {
  const ChangeNameForm(this.user, {Key key}) : super(key: key);

  final UserDoc user;
  @override
  _ChangeNameFormState createState() => _ChangeNameFormState();
}

class _ChangeNameFormState extends State<ChangeNameForm> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.user.entity.name);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller.text = widget.user.entity.name;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<AccountNotifier>(context, listen: false);
    return Column(
      children: <Widget>[
        TextField(
          controller: _controller,
        ),
        RaisedButton(
          child: Text('update'),
          onPressed: () async {
            await notify.updateName(_controller.text);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<AccountNotifier>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(notify.account.entity.updatedAt.toString()),
            accountName: Text(notify.account.entity.name),
          ),
          ListTile(
            title: Text('User Setting'),
            onTap: () => Navigator.of(context).popAndPushNamed(
              UserSettingPage.routeName,
              arguments: notify.account,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class HomePage extends StatelessWidget {
  const HomePage._({Key key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(
        auth: Provider.of<Authenticator>(context, listen: false),
      ),
      child: const HomePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<_ViewModel>(context);
    final notify = Provider.of<AccountNotifier>(context);
    print(notify.account.entity.name);
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('uid: ${notify.account.id}'),
            Text('name: ${notify.account.entity.name}'),
            RaisedButton(
              child: Text(L10n.of(context).logout),
              onPressed: model.auth.signOut,
            ),
            ChangeNameForm(notify.account),
          ],
        ),
      ),
    );
  }
}
