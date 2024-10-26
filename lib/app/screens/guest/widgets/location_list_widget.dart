import 'package:flutter/material.dart';
import 'package:smart_cleaner_app/core/models/location_model.dart';

class LocationListWidget extends StatelessWidget {
  final List<LocationModel>? locations;
  final Function(LocationModel)? onDelete;

  const LocationListWidget({Key? key, this.locations, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Locations (${locations?.length ?? 0})",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        ...?locations?.asMap().entries.map((entry) {
          int index = entry.key;
          LocationModel location = entry.value;

          return ListTile(
            leading: Icon(Icons.location_on, color: Colors.blueAccent),
            title: Text(
              (location.address?.isEmpty ?? true)
                  ? "Location #${index + 1}"
                  : location.address!,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "Latitude: ${location.latitude?.toStringAsFixed(4) ?? 'N/A'}, "
                  "Longitude: ${location.longitude?.toStringAsFixed(4) ?? 'N/A'}",
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => onDelete?.call(location),
            ),
          );
        }).toList(),
      ],
    );
  }
}
