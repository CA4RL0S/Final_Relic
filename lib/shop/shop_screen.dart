import 'package:flutter/material.dart';
import 'package:darkness_dungeon/shop/shop_data.dart';
import 'package:darkness_dungeon/shop/shop_item.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/shop/paypal_service.dart';
import 'dart:math' as math;

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  final PlayerInventory inventory = PlayerInventory();
  late TabController _tabController;
  late AnimationController _coinAnimationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // OPTIMIZADO: Animación de monedas limitada a pocos ciclos
    _coinAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Repetir solo 2 veces (4 segundos total) y luego detener
    _coinAnimationController.repeat(reverse: true);
    Future.delayed(Duration(seconds: 4), () {
      if (mounted && _coinAnimationController.isAnimating) {
        _coinAnimationController.stop();
      }
    });

    _loadInventory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _coinAnimationController.stop();
    _coinAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadInventory() async {
    await inventory.loadInventory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f1624),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.amber,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Procesando...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Normal',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildRealMoneyTab(),
                          _buildCoinsTab(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6a11cb),
            Color(0xFF2575fc),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2575fc).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, color: Colors.amber, size: 28),
                      SizedBox(width: 8),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.amber, Colors.white, Colors.amber],
                        ).createShader(bounds),
                        child: Text(
                          'TIENDA',
                          style: TextStyle(
                            fontFamily: 'Normal',
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCoinsDisplay(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(
                fontFamily: 'Normal',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 4),
                      Text('DINERO REAL'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, size: 20),
                      SizedBox(width: 4),
                      Text('ITEMS'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCoinsDisplay() {
    return AnimatedBuilder(
      animation: _coinAnimationController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(right: 8),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD700),
                Color(0xFFFFAA00),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Transform.rotate(
                angle: math.sin(_coinAnimationController.value * 2 * math.pi) *
                    0.1,
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '${inventory.coins}',
                style: TextStyle(
                  fontFamily: 'Normal',
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tab de compras con dinero real
  Widget _buildRealMoneyTab() {
    final items = ShopData.getRealMoneyItems();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e).withOpacity(0.5),
            Color(0xFF0f1624),
          ],
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildShopItemCard(items[index], index);
        },
      ),
    );
  }

  // Tab de compras con monedas del juego
  Widget _buildCoinsTab() {
    final items = ShopData.getCoinShopItems();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e).withOpacity(0.5),
            Color(0xFF0f1624),
          ],
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildShopItemCard(items[index], index);
        },
      ),
    );
  }

  Widget _buildShopItemCard(ShopItem item, int index) {
    final bool isMoneyPurchase = item.priceInMoney > 0;
    final bool isPermanentUpgrade = _isPermanentUpgrade(item.type);
    final bool alreadyOwned =
        isPermanentUpgrade && inventory.hasPermanentUpgrade(item.id);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: alreadyOwned
                ? [
                    Color(0xFF2d4a2b),
                    Color(0xFF1a2f19),
                  ]
                : isMoneyPurchase
                    ? [
                        Color(0xFF1e3a5f),
                        Color(0xFF0f1f3a),
                      ]
                    : [
                        Color(0xFF4a1e5f),
                        Color(0xFF2d0f3a),
                      ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: alreadyOwned
                ? Colors.green
                : isMoneyPurchase
                    ? Color(0xFF4CAF50).withOpacity(0.5)
                    : Color(0xFFAB47BC).withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: alreadyOwned
                  ? Colors.green.withOpacity(0.3)
                  : isMoneyPurchase
                      ? Colors.blue.withOpacity(0.3)
                      : Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: alreadyOwned ? null : () => _handlePurchase(item),
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Badge superior
                  if (alreadyOwned)
                    _buildOwnedBadge()
                  else if (isMoneyPurchase)
                    _buildPremiumBadge()
                  else
                    _buildRarityBadge(item.type),

                  SizedBox(height: 8),

                  // Imagen del item con efecto especial
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/${item.imagePath}',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality
                                    .none, // Pixel-perfect upscaling
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white38,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (!alreadyOwned)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.transparent,
                                      (isMoneyPurchase
                                              ? Colors.blue
                                              : Colors.purple)
                                          .withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Nombre del item
                  Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6),

                  // Descripción
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Normal',
                        fontSize: 11,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Botón de compra mejorado
                  if (!alreadyOwned)
                    _buildPurchaseButton(item, isMoneyPurchase)
                  else
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.green,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 19),
                            SizedBox(width: 6),
                            Text(
                              'EQUIPADO',
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: 'Normal',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[800]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.white, size: 15),
          SizedBox(width: 4),
          Text(
            'COMPRADO',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Normal',
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.black87, size: 15),
          SizedBox(width: 4),
          Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Normal',
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRarityBadge(ShopItemType type) {
    String label;
    Color color1;
    Color color2;

    if (type == ShopItemType.weaponUpgrade ||
        type == ShopItemType.healthUpgrade ||
        type == ShopItemType.speedUpgrade ||
        type == ShopItemType.staminaUpgrade) {
      label = 'ÉPICO';
      color1 = Color(0xFFAB47BC);
      color2 = Color(0xFF7B1FA2);
    } else if (type == ShopItemType.specialPack) {
      label = 'LEGENDARIO';
      color1 = Color(0xFFFF6B35);
      color2 = Color(0xFFE63946);
    } else {
      label = 'COMÚN';
      color1 = Color(0xFF607D8B);
      color2 = Color(0xFF455A64);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Normal',
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(ShopItem item, bool isMoneyPurchase) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMoneyPurchase
              ? [Color(0xFF4CAF50), Color(0xFF2E7D32)]
              : [Color(0xFFFFD700), Color(0xFFFFA000)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (isMoneyPurchase ? Colors.green : Colors.amber)
                .withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handlePurchase(item),
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isMoneyPurchase ? Icons.shopping_cart : Icons.monetization_on,
                  color: isMoneyPurchase ? Colors.white : Colors.black87,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  isMoneyPurchase
                      ? '\$${PayPalService.convertMxnToUsd(item.priceInMoney).toStringAsFixed(2)} USD'
                      : '${item.priceInCoins}',
                  style: TextStyle(
                    fontFamily: 'Normal',
                    fontSize: 15,
                    color: isMoneyPurchase ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    shadows: isMoneyPurchase
                        ? [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isPermanentUpgrade(ShopItemType type) {
    return type == ShopItemType.weaponUpgrade ||
        type == ShopItemType.speedUpgrade ||
        type == ShopItemType.staminaUpgrade ||
        type == ShopItemType.healthUpgrade;
  }

  Future<void> _handlePurchase(ShopItem item) async {
    if (item.priceInMoney > 0) {
      // Compra con dinero real
      await _handleRealMoneyPurchase(item);
    } else {
      // Compra con monedas del juego
      await _handleCoinPurchase(item);
    }
  }

  Future<void> _handleRealMoneyPurchase(ShopItem item) async {
    // Mostrar diálogo de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green.withOpacity(0.5), width: 2),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.green[700]!],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_cart, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Confirmar Compra',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.amber,
                        fontFamily: 'Normal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0070BA),
                            Color(0xFF003087)
                          ], // Colores de PayPal
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '\$${PayPalService.convertMxnToUsd(item.priceInMoney).toStringAsFixed(2)} USD',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Normal',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '(~\$${item.priceInMoney.toStringAsFixed(0)} MXN)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Normal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                '¿Deseas continuar con esta compra?',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Normal',
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Normal',
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Comprar',
              style: TextStyle(
                fontFamily: 'Normal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      // MODO PRUEBA: Simular compra (descomenta esto para pruebas sin PayPal)
      /*
      final success = await PayPalService.simulatePurchase(
        itemId: item.id,
        amount: item.priceInMoney,
      );
      
      if (success) {
        await _processSuccessfulPurchase(item);
        _showSuccessDialog('¡Compra exitosa!', 'Has comprado ${item.name}');
      } else {
        _showErrorDialog('Error en la compra', 'Por favor intenta de nuevo');
      }
      setState(() => _isLoading = false);
      */

      // MODO REAL: Usar flujo de PayPal
      setState(() => _isLoading = false);

      // Convertir de MXN a USD para PayPal
      final amountInUsd = PayPalService.convertMxnToUsd(item.priceInMoney);

      PayPalService.processPayment(
        context: context,
        itemName: item.name,
        amount: amountInUsd,
        itemId: item.id,
        onSuccess: () async {
          // Procesar la compra exitosa
          await _processSuccessfulPurchase(item);
          await _loadInventory(); // Recargar inventario

          _showSuccessDialog(
            '¡Compra exitosa!',
            'Has comprado ${item.name} exitosamente',
          );
        },
        onError: (error) {
          _showErrorDialog(
            'Error en el pago',
            'No se pudo procesar el pago con PayPal.\nError: $error',
          );
        },
        onCancel: () {
          _showInfoDialog(
            'Pago cancelado',
            'Has cancelado la compra de ${item.name}',
          );
        },
      );
    } catch (e) {
      _showErrorDialog('Error', 'Ocurrió un error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCoinPurchase(ShopItem item) async {
    // Verificar si tiene suficientes monedas
    if (inventory.coins < item.priceInCoins) {
      _showErrorDialog(
        'Monedas insuficientes',
        'Necesitas ${item.priceInCoins} monedas. Tienes ${inventory.coins}.',
      );
      return;
    }

    // Verificar si ya tiene el upgrade permanente
    if (_isPermanentUpgrade(item.type) &&
        inventory.hasPermanentUpgrade(item.id)) {
      _showErrorDialog(
        'Ya comprado',
        'Ya tienes esta mejora permanente.',
      );
      return;
    }

    // Confirmar compra
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.amber.withOpacity(0.5), width: 2),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag, color: Colors.black87, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Confirmar Compra',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.amber,
                        fontFamily: 'Normal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.monetization_on,
                              color: Colors.black87, size: 20),
                          SizedBox(width: 6),
                          Text(
                            '${item.priceInCoins}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Normal',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tu saldo: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Normal',
                              fontSize: 12,
                            ),
                          ),
                          Icon(Icons.monetization_on,
                              color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${inventory.coins}',
                            style: TextStyle(
                              color: Colors.amber,
                              fontFamily: 'Normal',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                '¿Deseas continuar con esta compra?',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Normal',
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Normal',
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Comprar',
              style: TextStyle(
                fontFamily: 'Normal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Gastar monedas
    final success = await inventory.spendCoins(item.priceInCoins);

    if (success) {
      await _processSuccessfulPurchase(item);
      setState(() {});

      _showSuccessDialog(
        '¡Compra exitosa!',
        'Has comprado ${item.name}',
      );
    }
  }

  Future<void> _processSuccessfulPurchase(ShopItem item) async {
    switch (item.type) {
      case ShopItemType.coinsPack:
        await inventory.addCoins(item.quantity ?? 0);
        break;

      case ShopItemType.potion:
      case ShopItemType.key:
      case ShopItemType.bomb:
      case ShopItemType.invincibility:
        await inventory.addConsumableItem(item.id, 1);
        break;

      case ShopItemType.weaponUpgrade:
      case ShopItemType.speedUpgrade:
      case ShopItemType.staminaUpgrade:
      case ShopItemType.healthUpgrade:
        await inventory.addPermanentUpgrade(item.id);
        break;

      case ShopItemType.specialPack:
        await _processSpecialPack(item.id);
        break;
    }
  }

  Future<void> _processSpecialPack(String packId) async {
    switch (packId) {
      case 'pack_starter':
        await inventory.addCoins(200);
        await inventory.addConsumableItem('potion_medium', 3);
        await inventory.addConsumableItem('key_single', 1);
        break;

      case 'pack_warrior':
        await inventory.addCoins(500);
        await inventory.addPermanentUpgrade('weapon_upgrade_1');
        await inventory.addConsumableItem('potion_large', 5);
        break;

      case 'pack_legendary':
        await inventory.addCoins(1500);
        await inventory.addPermanentUpgrade('weapon_upgrade_2');
        await inventory.addPermanentUpgrade('speed_upgrade_1');
        await inventory.addPermanentUpgrade('stamina_upgrade_2');
        await inventory.addPermanentUpgrade('health_upgrade_2');
        await inventory.addConsumableItem('potion_large', 10);
        break;
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green.withOpacity(0.5), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.green[700]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Normal',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '¡Genial!',
                    style: TextStyle(
                      fontFamily: 'Normal',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withOpacity(0.5), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red[700]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Normal',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Entendido',
                    style: TextStyle(
                      fontFamily: 'Normal',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue[700]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Normal',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Entendido',
                    style: TextStyle(
                      fontFamily: 'Normal',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funciones de MercadoPago eliminadas - Ya no se necesitan con PayPal
  // PayPal maneja el ciclo completo de pago dentro de la app
}
