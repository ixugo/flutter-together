import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends foundation.ChangeNotifier {
  // 首页切换
  int _appbarCurrentIndex = 0;
  get curIndex => _appbarCurrentIndex;
  setCurIndex(int x) {
    _appbarCurrentIndex = x;
    notifyListeners();
  }

  ScrollController sctrl = ScrollController();
  bool isHeader = false;
  setHeader(bool v) {
    if (isHeader != v) {
      isHeader = v;
      notifyListeners();
    }
  }

  // All the available products.
  List<Product> _availableProducts;

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id];
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  // Sales tax for the items in the cart
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost + shippingCost + tax;
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return [];
    }

    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}

enum Category {
  all,
  accessories,
  clothing,
  home,
}

class Product {
  const Product({
    @required this.category,
    @required this.id,
    @required this.isFeatured,
    @required this.name,
    @required this.price,
  })  : assert(category != null, 'category must not be null'),
        assert(id != null, 'id must not be null'),
        assert(isFeatured != null, 'isFeatured must not be null'),
        assert(name != null, 'name must not be null'),
        assert(price != null, 'price must not be null');

  final Category category;
  final int id;
  final bool isFeatured;
  final String name;
  final int price;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name (id=$id)';
}

class ProductsRepository {
  static const _allProducts = <Product>[
    Product(
      category: Category.accessories,
      id: 0,
      isFeatured: true,
      name: 'Vagabond sack',
      price: 120,
    ),
    Product(
      category: Category.accessories,
      id: 1,
      isFeatured: true,
      name: 'Stella sunglasses',
      price: 58,
    ),
    Product(
      category: Category.accessories,
      id: 2,
      isFeatured: false,
      name: 'Whitney belt',
      price: 35,
    ),
    Product(
      category: Category.accessories,
      id: 3,
      isFeatured: true,
      name: 'Garden strand',
      price: 98,
    ),
    Product(
      category: Category.accessories,
      id: 4,
      isFeatured: false,
      name: 'Strut earrings',
      price: 34,
    ),
    Product(
      category: Category.accessories,
      id: 5,
      isFeatured: false,
      name: 'Varsity socks',
      price: 12,
    ),
    Product(
      category: Category.accessories,
      id: 6,
      isFeatured: false,
      name: 'Weave keyring',
      price: 16,
    ),
    Product(
      category: Category.accessories,
      id: 7,
      isFeatured: true,
      name: 'Gatsby hat',
      price: 40,
    ),
    Product(
      category: Category.accessories,
      id: 8,
      isFeatured: true,
      name: 'Shrug bag',
      price: 198,
    ),
    Product(
      category: Category.home,
      id: 9,
      isFeatured: true,
      name: 'Gilt desk trio',
      price: 58,
    ),
    Product(
      category: Category.home,
      id: 10,
      isFeatured: false,
      name: 'Copper wire rack',
      price: 18,
    ),
    Product(
      category: Category.home,
      id: 11,
      isFeatured: false,
      name: 'Soothe ceramic set',
      price: 28,
    ),
    Product(
      category: Category.home,
      id: 12,
      isFeatured: false,
      name: 'Hurrahs tea set',
      price: 34,
    ),
    Product(
      category: Category.home,
      id: 13,
      isFeatured: true,
      name: 'Blue stone mug',
      price: 18,
    ),
    Product(
      category: Category.home,
      id: 14,
      isFeatured: true,
      name: 'Rainwater tray',
      price: 27,
    ),
    Product(
      category: Category.home,
      id: 15,
      isFeatured: true,
      name: 'Chambray napkins',
      price: 16,
    ),
    Product(
      category: Category.home,
      id: 16,
      isFeatured: true,
      name: 'Succulent planters',
      price: 16,
    ),
    Product(
      category: Category.home,
      id: 17,
      isFeatured: false,
      name: 'Quartet table',
      price: 175,
    ),
    Product(
      category: Category.home,
      id: 18,
      isFeatured: true,
      name: 'Kitchen quattro',
      price: 129,
    ),
    Product(
      category: Category.clothing,
      id: 19,
      isFeatured: false,
      name: 'Clay sweater',
      price: 48,
    ),
    Product(
      category: Category.clothing,
      id: 20,
      isFeatured: false,
      name: 'Sea tunic',
      price: 45,
    ),
    Product(
      category: Category.clothing,
      id: 21,
      isFeatured: false,
      name: 'Plaster tunic',
      price: 38,
    ),
    Product(
      category: Category.clothing,
      id: 22,
      isFeatured: false,
      name: 'White pinstripe shirt',
      price: 70,
    ),
    Product(
      category: Category.clothing,
      id: 23,
      isFeatured: false,
      name: 'Chambray shirt',
      price: 70,
    ),
    Product(
      category: Category.clothing,
      id: 24,
      isFeatured: true,
      name: 'Seabreeze sweater',
      price: 60,
    ),
    Product(
      category: Category.clothing,
      id: 25,
      isFeatured: false,
      name: 'Gentry jacket',
      price: 178,
    ),
    Product(
      category: Category.clothing,
      id: 26,
      isFeatured: false,
      name: 'Navy trousers',
      price: 74,
    ),
    Product(
      category: Category.clothing,
      id: 27,
      isFeatured: true,
      name: 'Walter henley (white)',
      price: 38,
    ),
    Product(
      category: Category.clothing,
      id: 28,
      isFeatured: true,
      name: 'Surf and perf shirt',
      price: 48,
    ),
    Product(
      category: Category.clothing,
      id: 29,
      isFeatured: true,
      name: 'Ginger scarf',
      price: 98,
    ),
    Product(
      category: Category.clothing,
      id: 30,
      isFeatured: true,
      name: 'Ramona crossover',
      price: 68,
    ),
    Product(
      category: Category.clothing,
      id: 31,
      isFeatured: false,
      name: 'Chambray shirt',
      price: 38,
    ),
    Product(
      category: Category.clothing,
      id: 32,
      isFeatured: false,
      name: 'Classic white collar',
      price: 58,
    ),
    Product(
      category: Category.clothing,
      id: 33,
      isFeatured: true,
      name: 'Cerise scallop tee',
      price: 42,
    ),
    Product(
      category: Category.clothing,
      id: 34,
      isFeatured: false,
      name: 'Shoulder rolls tee',
      price: 27,
    ),
    Product(
      category: Category.clothing,
      id: 35,
      isFeatured: false,
      name: 'Grey slouch tank',
      price: 24,
    ),
    Product(
      category: Category.clothing,
      id: 36,
      isFeatured: false,
      name: 'Sunshirt dress',
      price: 58,
    ),
    Product(
      category: Category.clothing,
      id: 37,
      isFeatured: true,
      name: 'Fine lines tee',
      price: 58,
    ),
  ];

  static List<Product> loadProducts(Category category) {
    if (category == Category.all) {
      return _allProducts;
    } else {
      return _allProducts.where((p) => p.category == category).toList();
    }
  }
}
