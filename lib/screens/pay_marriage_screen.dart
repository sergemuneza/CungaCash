
import 'package:cungacash/models/MarriageContribution.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/MarriageContribution.dart';
import '../services/contribution_service.dart';

class PayMarriageScreen extends StatefulWidget {
  const PayMarriageScreen({Key? key}) : super(key: key);

  @override
  State<PayMarriageScreen> createState() => _PayMarriageScreenState();
}

class _PayMarriageScreenState extends State<PayMarriageScreen> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ContributionService _service = ContributionService();

  Future<void> _launchMoMoCode() async {
    const momoCode = 'tel:*182*8*1*576109#'; 
    if (await canLaunchUrl(Uri.parse(momoCode))) {
      await launchUrl(Uri.parse(momoCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open MoMo Code')),
      );
    }
  }

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      final contribution = MarriageContribution(
        userId: FirebaseAuth.instance.currentUser!.uid,
        amount: double.parse(_amountController.text),
        referenceCode: _referenceController.text,
        date: DateTime.now(),
      );

      await _service.submitContribution(contribution);
      _amountController.clear();
      _referenceController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contribution Submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PALS-MARRIAGE')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.payment),
              label: Text('Pay via MTN MoMo'),
              onPressed: _launchMoMoCode,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (RWF)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter amount' : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                      labelText: 'MoMo Reference Code',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Enter reference code'
                        : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitPayment,
                    child: Text('Submit Payment'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text('Your Payment History', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            StreamBuilder<List<MarriageContribution>>(
              stream: _service.getUserContributions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final contributions = snapshot.data!;

                if (contributions.isEmpty) return Text('No contributions yet');

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: contributions.length,
                  itemBuilder: (context, index) {
                    final item = contributions[index];
                    return Card(
                      child: ListTile(
                        title: Text('Amount: ${item.amount} Rwf'),
                        subtitle: Text(
                          'Ref: ${item.referenceCode}\nDate: ${item.date.toLocal().toString().split('.')[0]}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
