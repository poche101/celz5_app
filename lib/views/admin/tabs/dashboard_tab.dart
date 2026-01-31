import 'package:flutter/material.dart';
// Standard package: add "lucide_icons: ^1.1.0" to pubspec.yaml
import 'package:lucide_icons/lucide_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardTab extends StatefulWidget {
  final VoidCallback onCreateMeeting;
  const DashboardTab({super.key, required this.onCreateMeeting});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String selectedFilter = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(isMobile),
              const SizedBox(height: 32),

              // Responsive Stats Grid
              LayoutBuilder(builder: (context, statsConstraints) {
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _statCard(
                        "Total Members",
                        "12,840",
                        LucideIcons.users,
                        const Color(0xFF6366F1),
                        statsConstraints.maxWidth,
                        isMobile),
                    _statCard(
                        "Active Streams",
                        "3,102",
                        LucideIcons.playCircle, // Updated Icon
                        const Color(0xFFEF4444),
                        statsConstraints.maxWidth,
                        isMobile),
                    _statCard(
                        "Testimonies",
                        "14",
                        LucideIcons.heart,
                        const Color(0xFFF59E0B),
                        statsConstraints.maxWidth,
                        isMobile),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // Charts Section
              if (isMobile) ...[
                _buildAttendanceChart(),
                const SizedBox(height: 24),
                _buildGoalRadialGauge(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildAttendanceChart()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildGoalRadialGauge()),
                  ],
                ),

              const SizedBox(height: 32),

              // Actions Section
              if (isMobile) ...[
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildActivityCard(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildQuickActions()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildActivityCard()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Analytics Overview",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5),
            ),
            Text("Monitoring church engagement metrics",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        if (!isMobile) _buildFilterToggle(),
      ],
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: ['Daily', 'Weekly', 'Monthly'].map((f) {
          bool sel = selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4)
                      ]
                    : [],
              ),
              child: Text(f,
                  style: TextStyle(
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color,
      double totalWidth, bool isMobile) {
    // Precise width calculation to avoid overflow
    double cardWidth = isMobile ? totalWidth : (totalWidth - 40) / 3;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Attendance Trends",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Expanded(
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis:
                  CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0)),
              series: <ChartSeries>[
                SplineAreaSeries<_ChartData, String>(
                  dataSource: [
                    _ChartData('Mon', 2200),
                    _ChartData('Wed', 3800),
                    _ChartData('Fri', 3100),
                    _ChartData('Sun', 5100)
                  ],
                  xValueMapper: (data, _) => data.x,
                  yValueMapper: (data, _) => data.y,
                  gradient: LinearGradient(colors: [
                    const Color(0xFF6366F1).withOpacity(0.3),
                    const Color(0xFF6366F1).withOpacity(0.0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderColor: const Color(0xFF6366F1),
                  borderWidth: 3,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalRadialGauge() {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100)),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 20000,
            showLabels: false,
            showTicks: false,
            axisLineStyle: const AxisLineStyle(
                thickness: 0.15,
                cornerStyle: CornerStyle.bothCurve,
                color: Color(0xFFF1F5F9),
                thicknessUnit: GaugeSizeUnit.factor),
            pointers: const <GaugePointer>[
              RangePointer(
                  value: 12840,
                  width: 0.15,
                  sizeUnit: GaugeSizeUnit.factor,
                  cornerStyle: CornerStyle.bothCurve,
                  gradient: SweepGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFA855F7)]))
            ],
            annotations: const [
              GaugeAnnotation(
                  widget: Column(mainAxisSize: MainAxisSize.min, children: [
                Text("12.8k",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                Text("Members", style: TextStyle(color: Colors.grey))
              ]))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.8,
          children: [
            _actionTile("New Meeting", LucideIcons.video, Colors.blue,
                widget.onCreateMeeting),
            _actionTile("Live Stream", LucideIcons.radio, Colors.red, () {}),
            _actionTile("Post Update", LucideIcons.layout, Colors.green, () {}),
            _actionTile("Settings", LucideIcons.settings, Colors.grey, () {}),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(24)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(LucideIcons.shieldCheck, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text("System Secure",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 16),
          Text("All streams and databases are running optimally.",
              style: TextStyle(color: Colors.white60, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
