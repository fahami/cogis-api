import 'package:flutter/material.dart';
import 'package:cogis/constants/color.dart';
import 'package:cogis/constants/text.dart';

import 'build_trail_cta.dart';

class ListCTA extends StatelessWidget {
  final String titleCTA;
  final String subtitleCTA;
  final String urlCTA1;
  final String urlCTA2;
  final IconData iconCTA1;
  final IconData iconCTA2;

  const ListCTA({
    Key key,
    @required this.titleCTA,
    this.subtitleCTA,
    this.urlCTA1,
    this.urlCTA2,
    this.iconCTA1,
    this.iconCTA2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        color: aAccentColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        trailing: (urlCTA1 == null && urlCTA2 == null)
            ? Icon(
                Icons.connect_without_contact,
                color: Colors.white,
              )
            : Container(
                width: 80,
                child: Row(
                  children: [
                    TrailCTA(
                      url: urlCTA1,
                      icon: iconCTA1,
                    ),
                    SizedBox(width: 8),
                    TrailCTA(
                      url: urlCTA2,
                      icon: iconCTA2,
                    ),
                  ],
                ),
              ),
        subtitle: Text(
          subtitleCTA,
          style: aDescriptionStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        title: Text(
          titleCTA,
          style: aHospitalStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
