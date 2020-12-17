import 'package:expense_tracker/src/models/transactions.dart';
import 'package:expense_tracker/src/widgets/transactionitem.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset('assets/images/waiting.png'),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
              // return Card(
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 120,
              //         padding: EdgeInsets.all(10),
              //         margin:
              //             EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //         decoration: BoxDecoration(
              //             border: Border.all(
              //           color: Theme.of(context).primaryColor,
              //           width: 2,
              //         )),
              //         child: Center(
              //           child: Text(
              //             '${transactions[index].amount}/-',
              //             // tx.amount.toString(),
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             transactions[index].title,
              //             style: Theme.of(context).textTheme.headline6,
              //           ),
              //           SizedBox(
              //             height: 7,
              //           ),
              //           Text(
              //             DateFormat.yMMMMEEEEd()
              //                 .format(transactions[index].date),
              //             style: TextStyle(
              //               color: Colors.grey,
              //               fontSize: 12,
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // );
            },
          );
  }
}

