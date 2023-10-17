import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: const Color.fromARGB(255, 161, 141, 219),
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Text(
                    "Alerts",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                CustomCard(
                  title:
                      "Apple AirPods Pro 2 available at a steal price of ₹16,749 during Amazon, Flipkart sale. Here's how the deal works",
                  subTitle:
                      "Festive sales have begun on Amazon and Flipkart and with that huge discounts on Apple products have also been announced. The Apple Air Pods Pro second generation that were upgraded at this year's Apple event are being offered at a steal price during this year's festive sale on both the e-commerce giants. ",
                ),
                CustomCard(
                  title:
                      "Apple AirPods Pro 2 available at a steal price of ₹16,749 during Amazon, Flipkart sale. Here's how the deal works",
                  subTitle:
                      "Festive sales have begun on Amazon and Flipkart and with that huge discounts on Apple products have also been announced. The Apple Air Pods Pro second generation that were upgraded at this year's Apple event are being offered at a steal price during this year's festive sale on both the e-commerce giants. ",
                ),
                CustomCard(
                  title:
                      "Apple AirPods Pro 2 available at a steal price of ₹16,749 during Amazon, Flipkart sale. Here's how the deal works",
                  subTitle:
                      "Festive sales have begun on Amazon and Flipkart and with that huge discounts on Apple products have also been announced. The Apple Air Pods Pro second generation that were upgraded at this year's Apple event are being offered at a steal price during this year's festive sale on both the e-commerce giants. ",
                ),
                CustomCard(
                  title:
                      "Apple AirPods Pro 2 available at a steal price of ₹16,749 during Amazon, Flipkart sale. Here's how the deal works",
                  subTitle:
                      "Festive sales have begun on Amazon and Flipkart and with that huge discounts on Apple products have also been announced. The Apple Air Pods Pro second generation that were upgraded at this year's Apple event are being offered at a steal price during this year's festive sale on both the e-commerce giants. ",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomCard({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(103, 65, 217, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
