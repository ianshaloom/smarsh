import 'package:flutter/material.dart';

class ImportedProducts extends StatelessWidget {
  const ImportedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Imported Products'),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  // loadAsset();
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(55.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Adding new products, managing products, importing and exporting data',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
            sliver: SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const Card(
                child: ListTile(
                  title: Text('Product Name'),
                  subtitle: Text('Product Code'),
                  trailing: Text('Stock Count'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


/** // NOTE - Load csv and upload contents

 * Future<void> loadAsset() async {
    try {
      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        print('entered');
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        listOne.removeLast();

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        print('List Two -------------------> ${listTwo.last}');

        for (int i = 0; i < listTwo.length; i++) {
          print('entered loop');
          final row = listTwo[i];
          print(row);
          final String productCode = Shared.generateProductCode(10);
          print(productCode);
          final String productName = row[0].toString().trim();
          print(productName);
          final double buyingPrice = double.parse(row[1]);
          print(buyingPrice.toString());
          final double sellingPrice = double.parse(row[2]);
          print(sellingPrice.toString());
          final int stockCount = int.parse(row[3]);
          print(stockCount.toString());

          // save product to hive
          final product = ProductModel(
            productId: productCode,
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          final CloudProduct fetchedFile = await _cloudStorage.createProduct(
            documentId: productCode,
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          print(
              '\n ====> \n =========> \n =================> ${fetchedFile.productName}');

          //break;
        }
      }
    } catch (e) {
      print('Error loading asset: $e');
    }
  }
 */
 
 
 /** // NOTE - Import data from csv file
  * 
  Future _importData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Importing data...'),
              ],
            ),
          ),
        ),
      ),
    );
    try {
      // clear product box
      await Boxes.productBox().clear();

      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        print('entered');
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        listOne.removeLast();

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        print('List Two -------------------> ${listTwo.last}');

        for (int i = 0; i < listTwo.length; i++) {
          print('entered loop');
          final row = listTwo[i];
          print(row);
          final String productCode = Shared.generateProductCode(10);
          print(productCode);
          final String productName = row[0].toString().trim();
          print(productName);
          final double buyingPrice = double.parse(row[1]);
          print(buyingPrice.toString());
          final double sellingPrice = double.parse(row[2]);
          print(sellingPrice.toString());
          final int stockCount = int.parse(row[3]);
          print(stockCount.toString());

          // save product to hive
          final product = ProductModel(
            productId: productCode,
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          print(product.productName);
          await Boxes.productBox().add(product);
          //break;
        }
      }

      _navigateToHomePage();
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      return;
    }
  }

  */