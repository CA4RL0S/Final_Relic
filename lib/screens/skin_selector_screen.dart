import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/util/player_sprite_sheet.dart';
import 'package:darkness_dungeon/util/custom_sprite_animation_widget.dart';

class SkinSelectorScreen extends StatefulWidget {
  const SkinSelectorScreen({Key? key}) : super(key: key);

  @override
  State<SkinSelectorScreen> createState() => _SkinSelectorScreenState();
}

class _SkinSelectorScreenState extends State<SkinSelectorScreen> {
  final PlayerInventory inventory = PlayerInventory();

  // Definición de skins disponibles
  static const List<Map<String, dynamic>> allSkins = [
    {
      'id': 'default',
      'name': 'Aventurero',
      'description': 'El héroe original',
      'icon': Icons.person,
    },
    {
      'id': 'knight',
      'name': 'Caballero Real',
      'description': 'Desbloqueado al completar el Nivel 3',
      'icon': Icons.shield,
    },
  ];

  @override
  void initState() {
    super.initState();
    inventory.loadInventory().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0F0F1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: allSkins.length,
                  itemBuilder: (context, index) {
                    return _buildSkinCard(allSkins[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'SKINS',
                  style: TextStyle(
                    fontFamily: 'Normal',
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance del botón atrás
        ],
      ),
    );
  }

  Widget _buildSkinCard(Map<String, dynamic> skin) {
    final String skinId = skin['id'];
    final bool isUnlocked = inventory.hasSkin(skinId);
    final bool isEquipped = inventory.getActiveSkin() == skinId;

    // Elegir la animación correcta para la preview
    Future<SpriteAnimation> previewAnimation;
    if (skinId == 'knight') {
      previewAnimation = PlayerSpriteSheet.knightIdleRight();
    } else {
      previewAnimation = PlayerSpriteSheet.idleRight();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEquipped
              ? [const Color(0xFF1B5E20), const Color(0xFF0D3B10)]
              : isUnlocked
                  ? [const Color(0xFF2D1B4E), const Color(0xFF1A0F2E)]
                  : [const Color(0xFF1A1A1A), const Color(0xFF0D0D0D)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEquipped
              ? Colors.green
              : isUnlocked
                  ? Colors.purple.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          if (isEquipped)
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isUnlocked && !isEquipped
              ? () async {
                  await inventory.setActiveSkin(skinId);
                  setState(() {});
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '🎨 Skin "${skin['name']}" equipada',
                          style: const TextStyle(
                            fontFamily: 'Normal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Preview del personaje
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: isUnlocked
                      ? CustomSpriteAnimationWidget(
                          animation: previewAnimation,
                        )
                      : Icon(
                          Icons.lock,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                ),
                const SizedBox(width: 16),

                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            skin['icon'] as IconData,
                            color: isUnlocked ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            skin['name'] as String,
                            style: TextStyle(
                              fontFamily: 'Normal',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skin['description'] as String,
                        style: TextStyle(
                          fontFamily: 'Normal',
                          fontSize: 12,
                          color: isUnlocked ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Estado
                if (isEquipped)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'EQUIPADA',
                      style: TextStyle(
                        fontFamily: 'Normal',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else if (isUnlocked)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple),
                    ),
                    child: const Text(
                      'EQUIPAR',
                      style: TextStyle(
                        fontFamily: 'Normal',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Icon(Icons.lock_outline, color: Colors.grey[600], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
