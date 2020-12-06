import 'package:flutter/material.dart';
import 'package:spot_hot/models/property.dart';
import 'property_screen.dart';
import 'package:spot_hot/proxy/firestore_proxy.dart' as firestore_proxy;

class PropertyCard extends StatelessWidget {
  Property prop;

  PropertyCard(this.prop) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(10, 8), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(80),
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.my_location),
              title: Text(prop.name),
              subtitle: Text(prop.propertyType.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.star),
                Text("(4.1/5)"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('MORE INFO'),
                  onPressed: () {
                    Navigator.pushNamed(context, PropertyScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListPropertyCards extends StatelessWidget {
  ListPropertyCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firestore_proxy.getNearestProperties(),
        builder: (context, snapshot) {
          Size screenSize = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.done) {
            List<Property> list_properties = snapshot.data;
            List<PropertyCard> listPropertyCards = [];
            for (Property property in list_properties) {
              PropertyCard curPropretyCard = PropertyCard(property);
              listPropertyCards.add(curPropretyCard);
            }
            return SingleChildScrollView(
              child: Center(
                  child: Column(
                    children: listPropertyCards,
                  )),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
