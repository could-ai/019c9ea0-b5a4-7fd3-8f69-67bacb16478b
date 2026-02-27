import 'package:flutter/material.dart';
import 'package:couldai_user_app/widgets/stand_layout_painter.dart';

class ExhibitionStandScreen extends StatefulWidget {
  const ExhibitionStandScreen({super.key});

  @override
  State<ExhibitionStandScreen> createState() => _ExhibitionStandScreenState();
}

class _ExhibitionStandScreenState extends State<ExhibitionStandScreen> {
  bool _showLighting = true;
  bool _showDimensions = false;
  bool _is3D = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUXURY EXHIBITION STAND 15x15m'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showLighting ? Icons.lightbulb : Icons.lightbulb_outline),
            onPressed: () => setState(() => _showLighting = !_showLighting),
            tooltip: 'Toggle Lighting',
          ),
          IconButton(
            icon: Icon(_is3D ? Icons.view_quilt : Icons.view_in_ar),
            onPressed: () => setState(() => _is3D = !_is3D),
            tooltip: 'Toggle 3D View',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel: Controls & Details
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  _buildSectionTitle('DESIGN SPECIFICATIONS'),
                  _buildSpecItem('Dimensions', '15m x 15m (225m²)'),
                  _buildSpecItem('Max Height', '4.0m'),
                  _buildSpecItem('Style', 'Open-plan, Luxury, Minimalist'),
                  const Divider(height: 40),
                  _buildSectionTitle('MATERIALS PALETTE'),
                  _buildMaterialSwatch('Matte Black', Colors.black, 'Branding Walls & Frames'),
                  _buildMaterialSwatch('Travertine', const Color(0xFFE3DCCB), 'Central Plinths'),
                  _buildMaterialSwatch('Dark Oak', const Color(0xFF4A3728), 'Hospitality Counter'),
                  _buildMaterialSwatch('White Fabric', const Color(0xFFF0F0F0), 'Lounge Upholstery'),
                  const Divider(height: 40),
                  _buildSectionTitle('FEATURES'),
                  _buildFeatureItem(Icons.tv, 'LED Screen & Illuminated Logo'),
                  _buildFeatureItem(Icons.chair, 'VIP Lounge Area'),
                  _buildFeatureItem(Icons.inventory_2, 'Hidden Storage'),
                  _buildFeatureItem(Icons.wb_sunny, '3000K Warm Lighting'),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Show Dimensions'),
                    value: _showDimensions,
                    activeColor: Colors.black,
                    onChanged: (val) => setState(() => _showDimensions = val),
                  ),
                  SwitchListTile(
                    title: const Text('3D Perspective'),
                    value: _is3D,
                    activeColor: Colors.black,
                    onChanged: (val) => setState(() => _is3D = val),
                  ),
                ],
              ),
            ),
          ),
          // Right Panel: Visualization
          Expanded(
            flex: 7,
            child: Container(
              color: const Color(0xFFEEEEEE),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate a square size that fits
                    double size = constraints.maxWidth < constraints.maxHeight
                        ? constraints.maxWidth * 0.8
                        : constraints.maxHeight * 0.8;
                    
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: _is3D ? 1 : 0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutCubic,
                      builder: (context, value, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // Perspective
                            ..rotateX(0.9 * value) // Tilt back
                            ..rotateZ(0.2 * value), // Slight rotation
                          alignment: Alignment.center,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                  offset: Offset(0, 10 * value),
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: StandLayoutPainter(
                                showLighting: _showLighting,
                                showDimensions: _showDimensions,
                              ),
                              size: Size(size, size),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildMaterialSwatch(String name, Color color, String usage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(usage, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
