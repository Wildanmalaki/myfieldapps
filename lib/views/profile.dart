import 'package:flutter/material.dart';
import 'package:MyField/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final UserModel currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF071A2C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// hEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),

                SizedBox(height: 30),

                // PROFILE IMAGE
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          "https://scontent.fcgk12-2.fna.fbcdn.net/v/t39.30808-6/610964674_2679999182333365_6903091626739272275_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=1d70fc&_nc_eui2=AeG3ffvtVTA9GRRQUyHkLEFCrZlFi7NRhLOtmUWLs1GEswZh25jZ0vyFISOGLtD9vuGRuiod-AG3b1qxJdVtzXLt&_nc_ohc=Gkd9m1jgqpUQ7kNvwG37QwQ&_nc_oc=AdlHqpSStbNOz7hIEsx3WVCCjwamSA2bxWJy6S-mPczWNnAH7KCdCEXYUFOXz4SFP9k&_nc_zt=23&_nc_ht=scontent.fcgk12-2.fna&_nc_gid=3E9ZWA7evg_eJOMKnvZvpA&_nc_ss=8&oh=00_AfyajaUDtJnu8ML9d1XQVVCPI4u9ESOIKytIDOPFTGKBSA&oe=69BB4021",
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// NAME
                Center(
                  child: Text(
                    currentUser.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 6),

                Center(
                  child: Text(
                    "Member since 1945",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 20),

                /// EDIT BUTTON
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    onPressed: () {},
                  ),
                ),

                SizedBox(height: 30),

                /// SPORTS STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "STATS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(color: Colors.blue.shade300),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    /// MATCHES CARD
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E2A47),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.sports_soccer, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "100",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "LAPANGAN YANG SUDAH DIBOOKING",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// WIN RATE CARD
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF0E2A47),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "64%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "WIN RATE",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                /// TOP SPORT
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3A7BFF), Color(0xFF2A5BEA)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sports_soccer, color: Colors.white, size: 40),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATIC",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Minisoccer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Striker • Avg Rating 8.4",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                /// RECENT ACTIVITY
                Text(
                  "History Lapangan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                fungsiKolom(
                  Icons.sports_basketball,
                  "Dekings Arena",
                  "Dibooking pada 12 Jan 2024",
                  "2 jam lalu",
                  Colors.orange,
                  Image.network(
                    "https://scontent-cgk1-2.xx.fbcdn.net/v/t39.30808-1/610964674_2679999182333365_6903091626739272275_n.jpg?stp=dst-jpg_s160x160_tt6&_nc_cat=108&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeG3ffvtVTA9GRRQUyHkLEFCrZlFi7NRhLOtmUWLs1GEswZh25jZ0vyFISOGLtD9vuGRuiod-AG3b1qxJdVtzXLt&_nc_ohc=R9vTCjBGoHEQ7kNvwEgdCT1&_nc_oc=AdmY2ASZ25NvGE0k9dkgYH5v6XeecXBtt9C0f2IZoYJjp5_qOE6CjE0LWH_fd_USYrU&_nc_zt=24&_nc_ht=scontent-cgk1-2.xx&_nc_gid=aS6GJIQkkseVX1pNVJaAaA&_nc_ss=8&oh=00_Afwv7cN5mnbKEphn6B3URGRGOe30e-_-JDxyn5tXIguKFQ&oe=69B3EA63",
                  ),
                ),
                fungsiKolom(
                  Icons.sports_basketball,
                  "Lapangan Basket B",
                  "Dibooking pada 12 Jan 2024",
                  "2 jam lalu",
                  Colors.orange,
                  Image.network(
                    "https://scontent-cgk1-2.xx.fbcdn.net/v/t39.30808-1/610964674_2679999182333365_6903091626739272275_n.jpg?stp=dst-jpg_s160x160_tt6&_nc_cat=108&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeG3ffvtVTA9GRRQUyHkLEFCrZlFi7NRhLOtmUWLs1GEswZh25jZ0vyFISOGLtD9vuGRuiod-AG3b1qxJdVtzXLt&_nc_ohc=R9vTCjBGoHEQ7kNvwEgdCT1&_nc_oc=AdmY2ASZ25NvGE0k9dkgYH5v6XeecXBtt9C0f2IZoYJjp5_qOE6CjE0LWH_fd_USYrU&_nc_zt=24&_nc_ht=scontent-cgk1-2.xx&_nc_gid=aS6GJIQkkseVX1pNVJaAaA&_nc_ss=8&oh=00_Afwv7cN5mnbKEphn6B3URGRGOe30e-_-JDxyn5tXIguKFQ&oe=69B3EA63",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fungsiKolom(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
    Image imageUrl,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF0E2A47),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Text(time, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
