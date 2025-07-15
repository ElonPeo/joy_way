import 'package:flutter/material.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({
    super.key,
  });

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  Province? selectedProvince;
  District? selectedDistrict;
  Ward? selectedWard;
  List<Province> filteredProvinces = [];
  List<District> filteredDistricts = [];
  List<Ward> filteredWards = [];
  final TextEditingController addressDetailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredProvinces = VietnamProvinces.getProvinces();
      });
    });
  }

  @override
  void dispose() {
    addressDetailController.dispose();
    super.dispose();
  }

  void updateFilteredProvinces(String query) {
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    filteredWards = [];
    filteredDistricts = [];
    setState(() {
      filteredProvinces = VietnamProvinces.getProvinces(query: query);
    });
  }

  void updateFilteredDistricts(String query) {
    selectedDistrict = null;
    selectedWard = null;
    filteredWards = [];
    if (selectedProvince != null) {
      setState(() {
        filteredDistricts = VietnamProvinces.getDistricts(
          provinceCode: selectedProvince!.code,
          query: query,
        );
      });
    }
  }

  void updateFilteredWards(String query) {
    selectedWard = null;
    if (selectedDistrict != null) {
      setState(() {
        filteredWards = VietnamProvinces.getWards(
          provinceCode: selectedProvince!.code,
          districtCode: selectedDistrict!.code,
          query: query,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vietnam Provinces Picker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdownSection(
              title: "Select Province/City",
              hintText: "Search province/city",
              items: filteredProvinces.map((p) => p.name).toList(),
              onSearchChanged: updateFilteredProvinces,
              currentValueSelected: selectedProvince?.name,
              onItemSelected: (value) {
                setState(() {
                  selectedProvince =
                      filteredProvinces.firstWhere((p) => p.name == value);
                  selectedDistrict = null;
                  selectedWard = null;
                  filteredDistricts = VietnamProvinces.getDistricts(
                    provinceCode: selectedProvince!.code,
                  );
                });
              },
            ),
            if (selectedProvince != null)
              buildDropdownSection(
                title: "Select District",
                hintText: "Search District",
                items: filteredDistricts.map((d) => d.name).toList(),
                onSearchChanged: updateFilteredDistricts,
                currentValueSelected: selectedDistrict?.name,
                onItemSelected: (value) {
                  setState(() {
                    selectedDistrict =
                        filteredDistricts.firstWhere((d) => d.name == value);
                    selectedWard = null;
                    filteredWards = VietnamProvinces.getWards(
                      provinceCode: selectedProvince!.code,
                      districtCode: selectedDistrict!.code,
                    );
                  });
                },
              ),
            if (selectedDistrict != null)
              buildDropdownSection(
                title: "Select Ward/Commune",
                hintText: "Search Ward/Commune",
                items: filteredWards.map((w) => w.name).toList(),
                onSearchChanged: updateFilteredWards,
                currentValueSelected: selectedWard?.name,
                onItemSelected: (value) {
                  setState(() {
                    selectedWard =
                        filteredWards.firstWhere((w) => w.name == value);
                  });
                },
              ),
            if (selectedWard != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: addressDetailController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Describe the specific location',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
            if (selectedProvince != null && selectedDistrict != null && selectedWard != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ${selectedProvince?.name}, ${selectedDistrict?.name}, ${selectedWard?.name}"
                        "${addressDetailController.text.trim().isNotEmpty ? ', ${addressDetailController.text.trim()}' : ''}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final baseAddress = "${selectedProvince?.name}, ${selectedDistrict?.name}, ${selectedWard?.name}";
                      final detail = addressDetailController.text.trim();
                      final result = detail.isNotEmpty
                          ? "$baseAddress, $detail"
                          : baseAddress;
                      Navigator.pop(context, result);
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget buildDropdownSection({
    required String title,
    required String hintText,
    required List<String> items,
    required void Function(String query) onSearchChanged,
    required void Function(String selectedItem) onItemSelected,
    required String? currentValueSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentValueSelected,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) onItemSelected(value);
            },
          ),
        ],
      ),
    );
  }
}
