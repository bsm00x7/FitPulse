import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/nutrition_service.dart';
import 'controller/nutrition_controller.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  _processBarcode(barcode.rawValue!);
                }
              }
            },
          ),
          Container(
            alignment: Alignment.center,
            child: CustomPaint(
              painter: ScannerOverlay(),
              size: MediaQuery.of(context).size,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Point the camera at a barcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processBarcode(String barcode) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final controller = context.read<NutritionController>();
      final foodProduct = await controller.searchFoodByBarcode(barcode);

      if (foodProduct != null && mounted) {
        await cameraController.stop();
        _showFoodDetails(foodProduct);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found in database')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showFoodDetails(FoodProduct food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) {
        MealType selectedMealType = MealType.breakfast;
        double servingMultiplier = 1.0;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nutrition Info
                  _buildNutritionRow('Calories', '${(food.calories * servingMultiplier).toInt()} kcal'),
                  _buildNutritionRow('Protein', '${(food.protein * servingMultiplier).toInt()}g'),
                  _buildNutritionRow('Carbs', '${(food.carbs * servingMultiplier).toInt()}g'),
                  _buildNutritionRow('Fats', '${(food.fats * servingMultiplier).toInt()}g'),
                  const SizedBox(height: 20),

                  // Serving size slider
                  Text('Serving Size: ${(food.servingSize * servingMultiplier).toInt()}g'),
                  Slider(
                    value: servingMultiplier,
                    min: 0.5,
                    max: 3.0,
                    divisions: 10,
                    label: '${(servingMultiplier * 100).toInt()}%',
                    onChanged: (value) {
                      setModalState(() {
                        servingMultiplier = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Meal Type Dropdown
                  DropdownButtonFormField<MealType>(
                    value: selectedMealType,
                    decoration: const InputDecoration(
                      labelText: 'Meal Type',
                      border: OutlineInputBorder(),
                    ),
                    items: MealType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          selectedMealType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _addMeal(food, selectedMealType, servingMultiplier);
                        if (mounted) {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add to Meals'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      cameraController.start();
      setState(() {
        _isProcessing = false;
      });
    });
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _addMeal(FoodProduct food, MealType mealType, double servingMultiplier) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final meal = Meal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: food.name,
        mealType: mealType,
        calories: food.calories * servingMultiplier,
        protein: food.protein * servingMultiplier,
        carbs: food.carbs * servingMultiplier,
        fats: food.fats * servingMultiplier,
        fiber: food.fiber * servingMultiplier,
        servingSize: '${(food.servingSize * servingMultiplier).toInt()}g',
        timestamp: DateTime.now(),
        barcode: food.barcode,
        imageUrl: food.imageUrl,
      );

      await context.read<NutritionController>().addMeal(meal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding meal: $e')),
        );
      }
    }
  }
}

// Scanner overlay painter
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.7,
      height: size.width * 0.5,
    );

    canvas.drawRect(scanArea, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
