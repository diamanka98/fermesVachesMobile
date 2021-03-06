import 'package:ferme_vaches_mobile/controller/cart_controller.dart';
import 'package:ferme_vaches_mobile/data/repository/produit_repo.dart';
import 'package:ferme_vaches_mobile/model/cart_model.dart';
import 'package:ferme_vaches_mobile/model/produit_model.dart';
import 'package:ferme_vaches_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProduitController extends GetxController {
  final ProduitRepo produitRepo;

  ProduitController({required this.produitRepo});

  List<dynamic> _produitList = [];
  List<dynamic> get produitList => _produitList;
  late CartController _cart;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;

  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;

  Future<void> getProduitList() async {
    Response response = await produitRepo.getProduitList();
    if (response.statusCode == 200) {
      // print("Produits");
      _produitList = [];
      _produitList.addAll(Produits.fromJson(response.body).products);
      _isLoaded = true;
      update();
    } else {}
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar("Compteur produit", "Impossible de réduire plus!",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    } else {
      return quantity;
    }
  }

  void initProduit(ProductModel produit, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;

    exist = _cart.existInCart(produit);
    if (exist) {
      _inCartItems = _cart.getQuantity(produit);
    }
  }

  void addItem(ProductModel produit) {
    _cart.addItem(produit, _quantity);
    _quantity = 0;
    _inCartItems = _cart.getQuantity(produit);

    _cart.items.forEach((key, value) {});

    update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }
}
