import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/views/details_screen.dart';
import 'package:pizza_app/screens/home/views/user_profile_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';
import '../../auth/blocs/cart_blocs/cart_bloc.dart';
import '../../auth/blocs/cart_blocs/cart_event_bloc.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../auth/views/cart_screen.dart';
import 'package:intl/intl.dart'; // Import thư viện intl

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  static final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  String searchQuery = "";
  Future<List<Pizza>> fetchRecommendedPizzas() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pizzas').get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['pizzaId'] = doc.id; // Gán ID Firestore vào map để sử dụng trong Pizza.fromMap
        return Pizza.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách pizza: $e');
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/8.png',
              scale: 14,
            ),
            SizedBox(width: 5),
            Text(
              'PIZZA',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          // Ô nhập tìm kiếm
          SizedBox(
            width: 200, // Giới hạn chiều rộng của ô tìm kiếm
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // Cập nhật từ khóa tìm kiếm
                });
              },
              decoration: InputDecoration(
                //hintText: "Tìm kiếm pizza...",
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 1, // Độ rộng đường kẻ
                      height: 24, // Chiều cao đường kẻ
                      color: Colors.blue.shade700, // Màu sắc đường kẻ
                      margin: EdgeInsets.symmetric(horizontal: 8), // Căn lề hai bên
                    ),
                    const Icon(CupertinoIcons.search), // Icon tìm kiếm
                    SizedBox(width: 8), // Khoảng cách giữa icon và viền phải
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Bo tròn góc
                  borderSide: BorderSide(color: Colors.blue.shade100, width: 2), // Viền màu xanh
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade100, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 2), // Khi focus, viền đậm hơn
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Căn lề nội dung
              ),
            ),
          ),

          BlocBuilder<CartBloc, CartState>( // Lắng nghe trạng thái giỏ hàng
            builder: (context, cartState) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<CartBloc>(),
                        child: const CartScreen(),
                      ),
                    ),
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(CupertinoIcons.cart),
                    if (cartState.pizzas.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cartState.pizzas.fold(0, (sum, pizza) => sum + pizza.quantity).toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<SignInBloc>(), // Đảm bảo SignInBloc được cung cấp
                    child: const UserProfileScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.person_alt_circle),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'Gợi ý cho bạn',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100, // Giới hạn chiều cao phần gợi ý
              child: FutureBuilder<List<Pizza>>(
                future: fetchRecommendedPizzas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có gợi ý nào!'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true, // Đảm bảo danh sách không mở rộng toàn bộ không gian
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final pizza = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(pizza),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
                              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều ngang
                              children: [
                                Image.network(
                                  pizza.picture,
                                  width: 70,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    pizza.name,
                                    textAlign: TextAlign.center, // Căn giữa nội dung text
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),

                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 14),

            Expanded(
            child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
              builder: (context, state) {
                if (state is GetPizzaSuccess) {
                  // Lọc danh sách pizza theo searchQuery
                  final filteredPizzas = searchQuery.isEmpty
                      ? state.pizzas
                      : state.pizzas
                      .where((pizza) => pizza.name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

                  if (filteredPizzas.isEmpty) {
                    return const Center(
                      child: Text(
                        "Không tìm thấy kết quả!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: filteredPizzas.length,
                    itemBuilder: (context, int i) {
                      return Material(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => DetailsScreen(filteredPizzas[i]),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(filteredPizzas[i].picture),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: filteredPizzas[i].isVeg ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        child: Text(
                                          filteredPizzas[i].isVeg ? "CÓ RAU CỦ" : "KHÔNG RAU CỦ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        child: Text(
                                          filteredPizzas[i].spicy == 1
                                              ? "KHÔNG CAY"
                                              : filteredPizzas[i].spicy == 2
                                              ? "CAY VỪA"
                                              : "CAY",
                                          style: TextStyle(
                                            color: filteredPizzas[i].spicy == 1
                                                ? Colors.white
                                                : filteredPizzas[i].spicy == 2
                                                ? Colors.orange
                                                : Colors.red,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  filteredPizzas[i].name,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  filteredPizzas[i].description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          formatCurrency.format(filteredPizzas[i].price - (filteredPizzas[i].price * filteredPizzas[i].discount / 100)),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formatCurrency.format(filteredPizzas[i].price),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w700,
                                              decoration: TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(RemoveFromCart(filteredPizzas[i]));
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.minus_circle,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text(
                                        "${filteredPizzas[i].quantity}",
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(AddToCart(filteredPizzas[i]));
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.add_circled,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is GetPizzaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text("Something went wrong!"));
                }
              },
            ),
          ),
      ],
    ),
    ),
    );
  }
}
