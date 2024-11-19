import 'package:flutter/material.dart';

import '../../const/homepage_features.dart';
import '../../custom/device_info.dart';
import '../../custom/my_app_bar.dart';
import '../../custom/my_widget.dart';
import '../../my_theme.dart';

class MoreServices extends StatelessWidget {
  const MoreServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context, title: "More Services").show(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: DeviceInfo(context).getWidth() *
                  2.5 /
                  DeviceInfo(context).getHeight()),
          itemCount: FeaturesList.featuresData(context)
              .where((feature) => feature["visible"])
              .length,
          itemBuilder: (context, index) {
            // Filter the features to only include those that are visible
            var features = FeaturesList.featuresData(context)
                .where((feature) => feature["visible"])
                .toList();

            var feature = features[index];
            return InkWell(
              onTap: feature["onTap"],
              child: MyWidget.customCardView(
                borderWidth: 1,
                elevation: 0,
                borderRadius: 10,
                borderColor: MyTheme.app_accent_border,
                backgroundColor: MyTheme.app_accent_color_extra_light,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      feature["icon"],
                      color: MyTheme.app_accent_color,
                      height: 50,
                      width: 50,
                    ),
                    Text(
                      feature["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.app_accent_color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
