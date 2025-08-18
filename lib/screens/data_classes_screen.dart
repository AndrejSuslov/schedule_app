import 'package:flutter/material.dart';
import 'package:flutter_test_project/services/storage.dart';
import 'package:flutter_test_project/services/parser/parser.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassesListWidget extends StatefulWidget {
  const ClassesListWidget({Key? key}) : super(key: key);

  @override
  _ClassesListWidgetState createState() => _ClassesListWidgetState();
}

class _ClassesListWidgetState extends State<ClassesListWidget> {
  List<DataClasses> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClassesData();
  }

  Future<void> _loadClassesData() async {
    try {
      final data = await Storage().loadClassesData();
      setState(() {
        _classes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    }
  }

  void _pushToMainScreen(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen({'group': bloc.settings.group}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _pushToMainScreen(context),
        ),
        title: const Text(
          'Пары и преподаватели',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_classes.isEmpty) {
      return const Center(child: Text('Нет данных о предметах'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        return _ClassItemWidget(dataClass: _classes[index]);
      },
    );
  }
}

class _ClassItemWidget extends StatefulWidget {
  final DataClasses dataClass;

  const _ClassItemWidget({Key? key, required this.dataClass}) : super(key: key);

  @override
  __ClassItemWidgetState createState() => __ClassItemWidgetState();
}

class __ClassItemWidgetState extends State<_ClassItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          widget.dataClass.shortName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey[600],
        ),
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoField('Полное название:', widget.dataClass.fullName),
                const SizedBox(height: 12),
                _buildInfoField(
                    'Форма аттестации:', widget.dataClass.attestationForm),
                const SizedBox(height: 12),
                _buildInfoField('Преподаватели:', widget.dataClass.teachers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
