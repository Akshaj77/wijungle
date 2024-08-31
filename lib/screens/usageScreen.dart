import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wijungle/login_bloc/bloc/service_bloc.dart';

class UsageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: screenHeight * 0.4, // Adjusted width based on screen height
            color: Color(0xFF1C1945),
            // padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Logo and Title
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://s3-alpha-sig.figma.com/img/2281/9a03/81a73d06f156efd12ab496a41efb0ac6?Expires=1725840000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=flyPib57ZL3p6zQlTzsqwB248dpDu~98zYvZA3mnnvE7aC7wEE-OtikcyV0LL6aa0-gGgaKtxxuZz9uPnSeZRSdqa42~JMU9V1-IjYD7iucDEsisZM5-7mJGm00eKqAAFEK5VyTiVKUd1ulbxnybpiExllyMibSJepQV0bZRcgfL9EX1u93BCHo40vrPPw~Xc8PIKibi6kLctqr38-L81azwDYZh6c2ssuzsfAM6DlxoIeGFWTqLJrIL3aug7xTiWITaBMEoVDO3sy4Hd8pBu4eisxbgypLtzzmHMEMy5epVxambKvWIzIe7FimpJHUdntfRNSBGwc1SF0tr3KjCGg__',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: screenHeight * 0.3, // Adjusted width based on screen height
                  height: screenHeight * 0.3, // Adjusted height based on screen height
                ),
                // Analytics Button
                Container(
                  width: screenHeight * 0.3, // Adjusted width based on screen height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.analytics, color: Colors.black),
                         const SizedBox(width: 20), // Add some spacing between the icon and the text
                          Text('Analytics', style: TextStyle(color: Color(0xFF1E215C),
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.03
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                // Feedback Button
                SizedBox(
                  width: screenHeight * 0.3, // Adjusted width based on screen height
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                       const Icon(Icons.feedback, color: Colors.white),
                        SizedBox(width: 16), // Add some spacing between the icon and the text
                        Text('Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: screenHeight * 0.03)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analytics',
                        style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // User Profile
                      Row(
                        children: [
                          Text('Hello', style: TextStyle(fontSize: screenHeight * 0.035,fontWeight: FontWeight.w600, color: Colors.grey)),
                          SizedBox(width: 8),
                          Text('User', style: TextStyle(fontSize: screenHeight * 0.04, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          CircleAvatar(
                            // Add your avatar asset here
                            child: Icon(Icons.person),
                            radius: screenHeight * 0.03,
                             // Adjusted radius based on screen height
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.1), // Adjusted height based on screen height
                  // Circular Progress Indicators
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      double cpuUsage = 0;
                      double ramUsage = 0;

                      if (state is ServiceLoaded) {
                        cpuUsage = state.cpuUsage.toDouble();
                        ramUsage = state.ramUsage.toDouble();
                      } else if (state is ServiceError) {
                        return const Center(
                          child: Text(
                            'Failed to load data',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // CPU Usage
                          CircularPercentIndicator(
                            radius: screenHeight * 0.2, // Adjusted radius based on screen height
                            lineWidth: screenHeight * 0.05, // Adjusted line width based on screen height
                            percent: cpuUsage / 100,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${cpuUsage.toStringAsFixed(1)}%",
                                  style: TextStyle(fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold), // Adjusted font size based on screen height
                                ),
                                Text("CPU", style: TextStyle(fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold)), // Adjusted font size based on screen height
                              ],
                            ),
                            progressColor: const Color(0xFF2979FF),
                            backgroundColor: const Color(0xFFE0E0E0),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          // RAM Usage
                          CircularPercentIndicator(
                            radius: screenHeight * 0.2, // Adjusted radius based on screen height
                            lineWidth: screenHeight * 0.05, // Adjusted line width based on screen height
                            percent: ramUsage / 100,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${ramUsage.toStringAsFixed(1)}%",
                                  style: TextStyle(fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold), // Adjusted font size based on screen height
                                ),
                                Text("RAM", style: TextStyle(fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold)), // Adjusted font size based on screen height
                              ],
                            ),
                            progressColor: Color(0xFF2979FF),
                            backgroundColor: Color(0xFFE0E0E0),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}