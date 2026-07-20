import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/finance_provider.dart';
import 'models/transaction.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FinanceProvider()..fetchTransactions(),
      child: const LunaFinanceApp(),
    ),
  );
}

class LunaFinanceApp extends StatelessWidget {
  const LunaFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LunaFinance Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.indigo, Colors.deepPurple]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Saldo', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(provider.totalBalance),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Pemasukan', provider.totalIncome, Colors.greenAccent),
                      _buildSummaryItem('Pengeluaran', provider.totalExpense, Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Riwayat Terakhir', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final tx = provider.transactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.type == 'income' ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(tx.type == 'income' ? Icons.arrow_upward : Icons.arrow_downward, 
                                 color: tx.type == 'income' ? Colors.green : Colors.red),
                    ),
                    title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${tx.category} • ${DateFormat.yMMMd().format(tx.date)}'),
                    trailing: Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(tx.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: tx.type == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                    onLongPress: () => provider.removeTransaction(tx.id!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
        label: const Text('Tambah Transaksi'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(amount),
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'expense';
  String _category = 'Umum';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Keterangan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                DropdownMenuItem(value: 'expense', child: Text('Pengeluaran')),
              ],
              onChanged: (val) => setState(() => _type = val!),
              decoration: const InputDecoration(labelText: 'Tipe', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _category,
              items: ['Umum', 'Makanan', 'Transport', 'Hiburan', 'Kesehatan', 'Gaji', 'Belanja']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final provider = Provider.of<FinanceProvider>(context, listen: false);
                  provider.addTransaction(Transaction(
                    description: _descController.text,
                    amount: double.parse(_amountController.text),
                    type: _type,
                    category: _category,
                    date: DateTime.now(),
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _filter = 'Day';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final now = DateTime.now();
    
    List<Transaction> filteredTxs = [];
    String periodTitle = '';

    if (_filter == 'Day') {
      filteredTxs = provider.filterByDay(now);
      periodTitle = 'Hari Ini';
    } else if (_filter == 'Month') {
      filteredTxs = provider.filterByMonth(now);
      periodTitle = 'Bulan Ini';
    } else {
      filteredTxs = provider.filterByYear(now);
      periodTitle = 'Tahun Ini';
    }

    double periodIncome = filteredTxs.where((tx) => tx.type == 'income').fold(0, (sum, tx) => sum + tx.amount);
    double periodExpense = filteredTxs.where((tx) => tx.type == 'expense').fold(0, (sum, tx) => sum + tx.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Keuangan')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Day', label: Text('Harian')),
                ButtonSegment(value: 'Month', label: Text('Bulanan')),
                ButtonSegment(value: 'Year', label: Text('Tahunan')),
              ],
              selected: {_filter},
              onSelectionChanged: (val) => setState(() => _filter = val.first),
            ),
            const SizedBox(height: 30),
            Text(periodTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReportTile('Pemasukan', periodIncome, Colors.green),
                _buildReportTile('Pengeluaran', periodExpense, Colors.red),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Distribusi Pengeluaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: _getChartSections(filteredTxs),
                  centerSpaceRadius: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTile(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(amount),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections(List<Transaction> txs) {
    Map<String, double> catData = {};
    for (var tx in txs) {
      if (tx.type == 'expense') {
        catData[tx.category] = (catData[tx.category] ?? 0) + tx.amount;
      }
    }

    int i = 0;
    final colors = [Colors.indigo, Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.orange, Colors.blue];
    
    return catData.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: e.key,
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}
