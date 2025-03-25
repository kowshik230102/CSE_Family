import 'package:flutter/material.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isEditing = false;

  // User Details
  String name = "Kowshik Ghosh";
  String id = "230102";
  String reg = "1011987";
  String session = "2022-2023"; // Added Session
  String batch = "15 th";
  String email = "koushik.cse15@gmail.com";
  String address = "Rajshahi, Bangladesh";
  String contactNo = "+8801572930689";

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    idController.text = id;
    regController.text = reg;
    sessionController.text = session;
    batchController.text = batch;
    emailController.text = email;
    addressController.text = address;
    contactController.text = contactNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Account"),
        backgroundColor: const Color.fromARGB(255, 241, 239, 239),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
              ),
              SizedBox(height: 20),

              // Details Box
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 1.5),
                  color: Colors.blue.shade50,
                ),
                child: Column(
                  children: [
                    _buildInfoRow("Name", name, nameController),
                    _buildInfoRow("ID", id, idController),
                    _buildInfoRow("Reg No", reg, regController),
                    _buildInfoRow(
                        "Session", session, sessionController), // Added Session
                    _buildInfoRow("Batch", batch, batchController),
                    _buildInfoRow("Email", email, emailController),
                    _buildInfoRow("Address", address, addressController),
                    _buildInfoRow("Contact No", contactNo, contactController),

                    // Edit & Save Button (Bottom Right)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isEditing) {
                              // Save Updated Values
                              name = nameController.text;
                              id = idController.text;
                              reg = regController.text;
                              session = sessionController.text;
                              batch = batchController.text;
                              email = emailController.text;
                              address = addressController.text;
                              contactNo = contactController.text;
                            }
                            isEditing = !isEditing;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 116, 230, 135),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(isEditing ? "Save" : "Edit"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info Row Widget
  Widget _buildInfoRow(
      String label, String value, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          SizedBox(height: 3),
          isEditing
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(value, style: TextStyle(fontSize: 16)),
                ),
        ],
      ),
    );
  }
}
