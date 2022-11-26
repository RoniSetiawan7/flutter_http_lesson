import 'package:flutter/material.dart';
import 'package:http_lesson/products/models/product.dart';
import 'package:http_lesson/products/screens/product_detail_screen.dart';
import 'package:http_lesson/products/services/product_services.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<List<Product>>? _productListScreen;

  @override
  void initState() {
    super.initState();
    _productListScreen = ProductServices.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of Products'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: FutureBuilder<List<Product>>(
              future: _productListScreen,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product>? product = snapshot.data!;
                  if (product.isEmpty) {
                    return const Text('No Data Found');
                  } else {
                    return ListView.builder(
                      itemCount: product.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Text(
                                product[index].title,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Text(
                              'Stock : ${product[index].stock.toString()}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            leading: Image.network(
                              product[index].thumbnail ?? '',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            trailing: Builder(builder: (context) {
                              if (product[index].discountPercentage != null) {
                                return Wrap(
                                  children: [
                                    Text(
                                      '${product[index].discountPercentage}%',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                          '\$ ${product[index].price.toString()}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '\$ ${(product[index].price - (product[index].price * product[index].discountPercentage!) / 100).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Text(
                                  '\$ ${product[index].price.toString()}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                );
                              }
                            }),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    product: product[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
