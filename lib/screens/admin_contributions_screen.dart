import 'package:cungacash/models/MarriageContribution.dart';
import 'package:flutter/material.dart';
import '../services/contribution_service.dart';
import '../models/MarriageContribution.dart';

class AdminContributionsScreen extends StatelessWidget {
  final ContributionService _service = ContributionService();

  AdminContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Marriage Contributions')),
      body: StreamBuilder<List<MarriageContribution>>(
        stream: _service.getAllContributions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final allContributions = snapshot.data!;
          if (allContributions.isEmpty) return Center(child: Text('No contributions recorded.'));

          return ListView.builder(
            itemCount: allContributions.length,
            itemBuilder: (context, index) {
              final contribution = allContributions[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text('Amount: ${contribution.amount} Rwf'),
                subtitle: Text(
                  'User ID: ${contribution.userId}\n'
                  'Ref: ${contribution.referenceCode}\n'
                  'Date: ${contribution.date.toLocal().toString().split(".")[0]}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
