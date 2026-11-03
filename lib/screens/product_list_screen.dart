
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {

  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.getProducts();
  }

  // Gọi lại API để lấy sản phẩm mới
  Future<void> reloadProducts() async {
    final newFuture = ApiService.getProducts();

    setState(() {
      futureProducts = newFuture;
    });

    try {
      await newFuture;
    } catch (_) {
      // FutureBuilder sẽ hiển thị thông báo lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: futureProducts,

          builder: (context, snapshot) {

            // LOADING
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              );
            }

            // ERROR
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Không thể tải dữ liệu sản phẩm',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: reloadProducts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            // DATA
            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(
                child: Text('Không có sản phẩm'),
              );
            }

            // Lấy sản phẩm đầu tiên
            final Product product = products.first;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [

                      // BACK BUTTON
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),

                      // TITLE
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Product detail',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // REFRESH BUTTON
                      IconButton(
                        tooltip: 'Refresh product',
                        onPressed: reloadProducts,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.blue,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),

                // PRODUCT DETAIL
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: reloadProducts,

                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // PRODUCT IMAGE
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),

                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(16),

                              child: Container(
                                width: double.infinity,
                                height: 245,
                                color: const Color(0xFFFF4B32),

                                child: Image.network(
                                  product.imgURL,
                                  width: double.infinity,
                                  height: 245,
                                  fit: BoxFit.contain,

                                  loadingBuilder:
                                      (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    }

                                    return const Center(
                                      child:
                                          CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  },

                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons
                                            .image_not_supported,
                                        size: 55,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // PRODUCT NAME
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // PRODUCT PRICE
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFFC62828),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // PRODUCT DESCRIPTION
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF5F5F5),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.des,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
