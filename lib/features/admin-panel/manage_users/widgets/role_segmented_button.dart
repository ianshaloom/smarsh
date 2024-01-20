import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_entities.dart';
import '../services/manage_users_mixin.dart';

class SelectRole extends StatefulWidget {
  final CloudUser user;
  const SelectRole({super.key, required this.user});

  @override
  State<SelectRole> createState() => _SelectRoleState();
}

enum Roles { admin, manager, supervisor, user }

class _SelectRoleState extends State<SelectRole> with ManageUsersMixin {
  late Roles rolesView;

  @override
  void initState() {
    rolesView = _getRole(widget.user.role);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Roles>(
      showSelectedIcon: false,
      segments: const <ButtonSegment<Roles>>[
        ButtonSegment<Roles>(
          value: Roles.admin,
          label: Text('Admin', style: TextStyle(fontSize: 11)),
          // icon: Icon(Icons.Roles_view_day),
        ),
        ButtonSegment<Roles>(
          value: Roles.supervisor,
          label: Text('Supervisor', style: TextStyle(fontSize: 11)),
          // icon: Icon(Icons.Roles_view_month),
        ),
        ButtonSegment<Roles>(
          value: Roles.user,
          label: Text('User', style: TextStyle(fontSize: 11)),
          // icon: Icon(Icons.Roles_today),
        ),
      ],
      selected: <Roles>{rolesView},
      onSelectionChanged: (Set<Roles> newSelection) async {
        await updateUserPrivileges(
          context: context,
          userId: widget.user.userId,
          role: _getRoleString(newSelection.first),
        );
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          rolesView = newSelection.first;
        });
      },
    );
  }

  Roles _getRole(String user) {
    switch (user) {
      case 'admin':
        return Roles.admin;
      case 'manager':
        return Roles.manager;
      case 'supervisor':
        return Roles.supervisor;
      case 'user':
        return Roles.user;
      default:
        return Roles.user;
    }
  }

  // return role in  String format from Roles enum
  String _getRoleString(Roles role) {
    switch (role) {
      case Roles.admin:
        return 'admin';
      case Roles.manager:
        return 'manager';
      case Roles.supervisor:
        return 'supervisor';
      case Roles.user:
        return 'user';
      default:
        return 'user';
    }
  }
}
