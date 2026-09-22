import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// MODEL PRODUK
// ============================================================
class Product {
  final String name;
  final String subtitle;
  final int price;
  final String imageUrl;
  int quantity;
  int likes;
  bool isLoved;
  bool isSelected;

  Product({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.likes,
    this.quantity = 1,
    this.isLoved = false,
    this.isSelected = false,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ===================== DATA PRODUK =====================
  final List<Product> products = [
    Product(
      name: 'Wireless Headphone',
      subtitle: 'Sony WH-CH520',
      price: 350000,
      likes: 12,
      imageUrl:
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=400&fit=crop',
    ),
    Product(
      name: 'Laptop ASUS Vivobook',
      subtitle: 'ASUS',
      price: 7500000,
      likes: 8,
      imageUrl:
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=400&fit=crop',
    ),
    Product(
      name: 'Wireless Mouse',
      subtitle: 'Logitech M330',
      price: 250000,
      likes: 5,
      imageUrl:
      'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300&h=400&fit=crop',
    ),
  ];

  // ===================== STATE LAIN =====================
  int selectedNavIndex = 0;
  String? popupProductName;
  int _popupToken = 0;

  // Total harga seluruh produk (harga x quantity)
  int get totalPrice =>
      products.fold(0, (sum, p) => sum + (p.price * p.quantity));

  // Total seluruh kuantitas unit produk
  int get totalQuantity =>
      products.fold(0, (sum, p) => sum + p.quantity);

  String _formatRupiah(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  void _toggleSelect(Product product) {
    setState(() {
      for (var p in products) {
        if (p != product) {
          p.isSelected = false;
        }
      }
      product.isSelected = !product.isSelected;
    });
  }

  void _toggleLove(Product product) {
    setState(() {
      product.isLoved = !product.isLoved;
      product.likes += product.isLoved ? 1 : -1;
    });
  }

  void _showPopup(String productName) {
    setState(() {
      popupProductName = productName;
    });
    final myToken = ++_popupToken;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && myToken == _popupToken) {
        setState(() {
          popupProductName = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,

        // ===================== APP BAR =====================
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'My Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Belanja lebih mudah setiap hari',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),

        // ===================== BODY =====================
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < products.length; i++)
                            Expanded(child: _buildProductCard(products[i])),
                        ],
                      ),
                    ),
                  ),
                  _buildCheckoutBar(),
                ],
              ),

              if (popupProductName != null)
                Positioned(
                  top: 8,
                  left: 16,
                  right: 16,
                  child: _buildPopupBanner(popupProductName!),
                ),
            ],
          ),
        ),

        // ===================== BOTTOM NAV =====================
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildNavItem(index: 0, icon: Icons.home, label: 'Beranda'),
                _buildNavItem(index: 1, icon: Icons.grid_view, label: 'Kategori'),
                _buildNavItem(
                  index: 2,
                  icon: Icons.shopping_cart_outlined,
                  label: 'Keranjang',
                  badge: 1,
                ),
                _buildNavItem(index: 3, icon: Icons.person_outline, label: 'Akun'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // KARTU PRODUK
  // ============================================================
  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: product.isSelected ? Colors.blue : Colors.grey.shade300,
          width: product.isSelected ? 2 : 1,
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleSelect(product),
        onDoubleTap: () => _toggleLove(product),
        onLongPress: () => _showPopup(product.name),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        product.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRupiah(product.price),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.isLoved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isLoved ? Colors.red : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.likes}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      _buildQuantityStepper(product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(Product product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepperButton(
          icon: Icons.remove,
          background: Colors.grey.shade200,
          iconColor: Colors.black87,
          onTap: () {
            setState(() {
              if (product.quantity > 1) {
                product.quantity--;
              }
            });
          },
        ),
        SizedBox(
          width: 24,
          child: Text(
            '${product.quantity}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        _stepperButton(
          icon: Icons.add,
          background: Colors.blue,
          iconColor: Colors.white,
          onTap: () {
            setState(() {
              product.quantity++;
            });
          },
        ),
      ],
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required Color background,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: iconColor),
      ),
    );
  }

  // ============================================================
  // BAR TOTAL + CHECKOUT
  // ============================================================
  Widget _buildCheckoutBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total ($totalQuantity produk)', // Menggunakan totalQuantity
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
              Text(
                _formatRupiah(totalPrice),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // POPUP BANNER
  // ============================================================
  Widget _buildPopupBanner(String productName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Produk dipilih!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '$productName telah dipilih.',
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                popupProductName = null;
              });
            },
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAV ITEM
  // ============================================================
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    int? badge,
  }) {
    final isSelected = selectedNavIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedNavIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$badge',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}