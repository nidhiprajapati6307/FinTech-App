// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../../../core/utils/app_colors.dart';
// import '../../../services/firebase_service.dart';
// import '../../../core/theme/app_theme.dart';
//
// class AccountBalanceCard extends ConsumerStatefulWidget {
//   const AccountBalanceCard({super.key});
//
//   @override
//   ConsumerState<AccountBalanceCard> createState() => _AccountBalanceCardState();
// }
//
// class _AccountBalanceCardState extends ConsumerState<AccountBalanceCard> {
//   double balance = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBalance();
//   }
//
//   Future<void> _loadBalance() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final data = await FirebaseService.getUserDocument(user.uid);
//       if (data != null) setState(() => balance = data['accountBalance'] ?? 0);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AppColors.primaryBlue,
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text('Account Balance', style: TextStyle(color: AppColors.white, fontSize: 16)),
//             const SizedBox(height: 8),
//             Text(
//               '\$${balance.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.borderRed),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }