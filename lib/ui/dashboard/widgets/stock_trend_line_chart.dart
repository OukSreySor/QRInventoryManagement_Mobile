import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/report.dart';
import '../../../services/dio_client.dart';

class StockTrendLineChart extends StatefulWidget {


  const StockTrendLineChart({super.key});

  @override
  State<StockTrendLineChart> createState() => _StockTrendLineChartState();
}

class _StockTrendLineChartState extends State<StockTrendLineChart> {
  late Future<List<StockTrend>> _futureTrends;

  @override
  void initState() {
    super.initState();
    _futureTrends = _fetchStockTrends();
  }

  Future<List<StockTrend>> _fetchStockTrends() async {
  try {
    final response = await DioClient.dio.get('/Transaction/summary');

    final data = response.data;
    final trends = data['stockTrends'] as List<dynamic>;

    return trends.map((json) => StockTrend.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to load trends');
  }
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StockTrend>>(
      future: _futureTrends,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No trend data available.'));
        }

        final trends = snapshot.data!;
        
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Stock Trend Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Date'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (trends.length / 6).floorToDouble().clamp(1, 5),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < trends.length) {
                            final date = trends[index].date;
                            return Text(
                              date,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Stock Quantity',
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2, // Control spacing, e.g., every 1 units
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(trends.length, (i) => FlSpot(i.toDouble(), trends[i].stockIn.toDouble())),
                      isCurved: false,
                      color: Colors.green,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
      
                    ),
                    LineChartBarData(
                      spots: List.generate(trends.length, (i) => FlSpot(i.toDouble(), trends[i].stockOut.toDouble())),
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LegendDot(color: Colors.green, label: 'Stock In'),
              SizedBox(width: 16),
              LegendDot(color: Colors.red, label: 'Stock Out'),
            ],
          ),
        ],
      );
      }
    );
  
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
