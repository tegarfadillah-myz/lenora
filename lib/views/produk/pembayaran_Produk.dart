import 'package:flutter/material.dart';
import 'package:lenora/models/produk.dart';



class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key, required Produk produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          _buildBottomSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/Desain tanpa judul.png'),
      ),git 
      title: const Text(
        'SKINEXPERT',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alamatmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Jl. Kpg Sutoyo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Text('Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit Address'),
                style: _outlinedButtonStyle(),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Note'),
                style: _outlinedButtonStyle(),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProductCard(),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.watch_later_outlined, size: 20, color: Colors.black),
              SizedBox(width: 8),
              Text('1 Discount Voucher', style: TextStyle(fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Jumlah Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildPriceRow('Harga 1x:', 'Rp. 200.000'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total:', style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Text('Rp. 20.000 ',
                      style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                  Text('Rp. 180.000', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/produk1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paket Skincare', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Deep Foam', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.receipt_outlined, size: 14),
                SizedBox(width: 2),
                Text('1'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3258),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3861),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cash/Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    Text('Rp. 200.000',
                        style: TextStyle(color: Color(0xFFFFA726), fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Bayar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0E3258))),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(Icons.home, true),
              _buildBottomNavItem(Icons.favorite_border, false),
              _buildBottomNavItem(Icons.shopping_bag_outlined, false),
              _buildBottomNavItem(Icons.notifications_none, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFF0E3258) : Colors.white,
        size: 24,
      ),
    );
  }

  ButtonStyle _outlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
