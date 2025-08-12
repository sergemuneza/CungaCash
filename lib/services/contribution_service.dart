import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cungacash/models/MarriageContribution.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/MarriageContribution.dart';

class ContributionService {
  final CollectionReference _contributions =
      FirebaseFirestore.instance.collection('pals_contributions');

  Future<void> submitContribution(MarriageContribution contribution) async {
    await _contributions.add(contribution.toMap());
  }

  Stream<List<MarriageContribution>> getUserContributions() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _contributions
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MarriageContribution.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<MarriageContribution>> getAllContributions() {
    return _contributions
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MarriageContribution.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
