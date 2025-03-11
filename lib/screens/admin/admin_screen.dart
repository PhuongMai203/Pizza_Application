import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Xóa pizza
  void _deletePizza(String pizzaId) {
    _firestore.collection('pizzas').doc(pizzaId).delete();
  }

  // Hiển thị hộp thoại thêm/sửa pizza
  void _showPizzaDialog({String? pizzaId, String? name, double? price}) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController priceController = TextEditingController(text: price?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pizzaId == null ? "Thêm Pizza" : "Chỉnh sửa Pizza"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên Pizza"),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Giá"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              String newName = nameController.text;
              double newPrice = double.tryParse(priceController.text) ?? 0;

              if (pizzaId == null) {
                // Thêm pizza
                _firestore.collection('pizzas').add({
                  'name': newName,
                  'price': newPrice,
                });
              } else {
                // Cập nhật pizza
                _firestore.collection('pizzas').doc(pizzaId).update({
                  'name': newName,
                  'price': newPrice,
                });
              }
              Navigator.pop(context);
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Admin Pizza Application"),
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Xử lý thông báo
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Pizza"),
                Tab(text: "Users"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.blue, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                "Thêm pizza",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: _buildPizzaList()),
                    ],
                  ),
                  _buildUserList(),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildPizzaList() {
    TextEditingController pizzaNameController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _firestore.collection('pizzas').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              var pizzas = snapshot.data!.docs;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: pizzas.map<DataRow>((pizza) {
                    return DataRow(cells: [
                      DataCell(Text(pizza['name'])),
                      DataCell(Text("${pizza['price']} VND")),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showPizzaDialog(
                              pizzaId: pizza.id,
                              name: pizza['name'],
                              price: double.tryParse(pizza['price'].toString()),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePizza(pizza.id),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildUserList() {
    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var users = snapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text("Email")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Actions")),
            ],
            rows: users.map<DataRow>((user) {
              return DataRow(cells: [
                DataCell(Text(user['email'])),
                DataCell(Text(user['name'])),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _firestore.collection('users').doc(user.id).delete(),
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

}
