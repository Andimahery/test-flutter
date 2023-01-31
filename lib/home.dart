import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String _imageLink = 'assets/images/photos_produits';
  late var _produits;
  late var _produitsSearched;
  String _label = '';
  List<Map<String, dynamic>>? _filters;
  bool _loading = true;

  _buildItem(produit) {
    if (produit['article'] != null && produit['article'] != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage('$_imageLink/air-jordan-1-low-se.jpg'),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     child: null,
          //   ),
          // ),
          SizedBox(
            height: 200,
            child: Image.asset('$_imageLink/${produit['photo']}'),
            // child: Image.asset('$_imageLink/air-jordan-1-low-se.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produit["article"] ?? 'Air Jordan 1 Low SE',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Chaussure pour ${produit["sexe"]}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const Text(
                  '1 couleur',
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${produit["prix"]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  List<Widget> _buildAllItem() {
    List<Widget> res = [];
    for (var produit in _produitsSearched) {
      res.add(_buildItem(produit));
    }
    return res;
  }

  _showFullModal(context, filtersParam) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Modal",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        List<Map<String, dynamic>> filters = filtersParam ??
            [
              {
                'title': 'Sexe',
                'type': 'checkbox',
                'filterNb': 0,
                'field': 'sexe',
                'child': [
                  {'label': 'Hommes', 'value': false, 'realValue': 'Homme'},
                  {'label': 'Femmes', 'value': false, 'realValue': 'Femme'},
                  {'label': 'Mixte', 'value': false, 'realValue': 'Mixte'},
                ],
              },
              {
                'title': 'Rechercher par prix',
                'type': 'checkbox',
                'filterNb': 0,
                'field': 'prixNumber',
                'child': [
                  {'label': 'Moins €50', 'value': false, 'min': 0, 'max': 49},
                  {'label': '€50 - €100', 'value': false, 'min': 50, 'max': 99},
                  {
                    'label': '€100 - €150',
                    'value': false,
                    'min': 100,
                    'max': 149
                  },
                  {
                    'label': '€150 et plus',
                    'value': false,
                    'min': 150,
                    'max': double.infinity
                  },
                ],
              },
              {
                'title': 'Couleur',
                'type': 'color',
                'filterNb': 0,
                'field': 'couleur',
                'child': [
                  {
                    'label': 'Noir',
                    'value': false,
                    'color': Colors.black,
                    'textColor': Colors.white
                  },
                  {
                    'label': 'Rouge',
                    'value': false,
                    'color': Colors.red,
                    'textColor': Colors.white
                  },
                  {
                    'label': 'Blanc',
                    'value': false,
                    'color': Colors.white,
                    'textColor': Colors.black
                  },
                  {
                    'label': 'Jaune',
                    'value': false,
                    'color': Colors.yellow,
                    'textColor': Colors.black
                  },
                  {
                    'label': 'Vert',
                    'value': false,
                    'color': Colors.green,
                    'textColor': Colors.white
                  },
                  {
                    'label': 'Bleu',
                    'value': false,
                    'color': Colors.blue,
                    'textColor': Colors.white
                  },
                  {
                    'label': 'Rose',
                    'value': false,
                    'color': Colors.pink,
                    'textColor': Colors.white
                  },
                  {
                    'label': 'Gris',
                    'value': false,
                    'color': Colors.grey,
                    'textColor': Colors.white
                  },
                ],
              },
              {
                'title': 'Sports',
                'type': 'checkbox',
                'filterNb': 0,
                'field': 'sport',
                'child': [
                  {
                    'label': 'Football',
                    'value': false,
                    'realValue': 'Football'
                  },
                  {
                    'label': 'Basketball',
                    'value': false,
                    'realValue': 'Basket'
                  },
                  {'label': 'Running', 'value': false, 'realValue': 'Running'},
                ],
              },
            ];

        return Scaffold(
          backgroundColor: Colors.white,
          body: StatefulBuilder(builder: (context, setState) {
            calcFilterNumber() {
              num res = 0;
              for (var el in filters) {
                res += el['filterNb'];
              }
              return res;
            }

            reset() {
              final newFilter = filters;
              for (var el in newFilter) {
                el['filterNb'] = 0;
                for (var child in el['child']) {
                  child['value'] = false;
                }
              }
              setState(() {
                filters = newFilter;
              });
            }

            buildColor(child, parent) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.black26,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: child['color'],
                        child: IconButton(
                            icon: Icon(
                              child['value'] ? Icons.check : null,
                              color: child['textColor'],
                            ),
                            onPressed: () {
                              setState(() {
                                child['value'] = !child['value'];
                                parent['filterNb'] = child['value']
                                    ? parent['filterNb'] += 1
                                    : parent['filterNb'] -= 1;
                              });
                            }),
                      ),
                    ),
                    Text(child['label']),
                  ],
                ),
              );
            }

            List<Widget> buidFilter() {
              List<Widget> res = [];
              for (var el in filters) {
                res.add(
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0, bottom: 10),
                    child: Text(
                      '${el['title']} (${el['filterNb']})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                );
                if (el['type'] == 'checkbox') {
                  for (var child in el['child']) {
                    res.add(
                      Row(
                        children: [
                          Checkbox(
                            value: child['value'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              side: const BorderSide(
                                color: Colors.black26,
                                width: 0.1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                child['value'] = newValue!;
                                el['filterNb'] = child['value']
                                    ? el['filterNb'] += 1
                                    : el['filterNb'] -= 1;
                              });
                            },
                          ),
                          Text(
                            child['label'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  const limit = 3;
                  for (var i = 0; i < el['child'].length; i += limit) {
                    List<Widget> rowChild = [];
                    for (var k = 0; k < limit; k++) {
                      if (i + k < el['child'].length) {
                        if (el['child'][i + k] != null) {
                          rowChild.add(buildColor(el['child'][i + k], el));
                        }
                      }
                    }
                    final row = Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rowChild,
                    );
                    res.add(row);
                  }
                }
                res.add(
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Divider(),
                  ),
                );
              }
              return res;
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 15),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // buidFilterListView(),
                          ...buidFilter(),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () {
                          reset();
                          Navigator.pop(context, filters);
                        },
                        child: Text('Effacer(${calcFilterNumber()})'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, filters);
                      },
                      child: const Text('Appliquer'),
                    ),
                  ],
                )
              ],
            );
          }),
        );
      },
    ).then((value) {
      return value;
    });
  }

  _init() async {
    _produits =
        json.decode(await rootBundle.loadString('assets/produits.json'));
    for (var el in _produits) {
      final prix = el['prix'].toString();
      el['prixNumber'] = prix != ""
          ? double.parse(
              prix.substring(0, prix.length - 2).replaceAll(',', '.'))
          : 0;
    }
    _produitsSearched = _produits;
    setState(() {
      _loading = false;
    });
  }

  _search() {
    setState(() {
      _loading = true;
    });
    //  activeFilters =
    //     _filters != null ? _filters!.where((el) => el['filterNb'] > 0) : [];
    Map<String, dynamic> filter = {};
    String newLabel = '';
    for (var el in _filters!) {
      filter[el['field']] = [];
      for (var child in el['child']) {
        if (child['value']) {
          if (el['field'] == 'sexe' || el['field'] == 'sport') {
            filter[el['field']]
                .add(child['realValue'].toString().toLowerCase());
            if (el['field'] == 'sexe') newLabel += '${child['label']} ';
          } else if (el['field'] == 'prixNumber') {
            filter[el['field']].add(child);
            newLabel += '${child['label']} ';
          } else {
            filter[el['field']].add(child['label'].toString().toLowerCase());
          }
        }
      }
    }
    final noFilter = filter['sexe'].isEmpty &&
        filter['couleur'].isEmpty &&
        filter['sport'].isEmpty &&
        filter['prixNumber'].isEmpty;
    setState(() {
      _produitsSearched = _produits
          .where((el) =>
              (noFilter ||
                  filter['sexe']
                      .contains(el['sexe'].toString().toLowerCase()) ||
                  filter['sport']
                      .contains(el['sport'].toString().toLowerCase()) ||
                  filter['couleur']
                          .where((coul) => el['couleur']
                              .toString()
                              .toLowerCase()
                              .contains(coul))
                          .toList()
                          .length >
                      0 ||
                  filter['prixNumber']
                          .where((prix) =>
                              prix['min'] <= el['prixNumber'] &&
                              el['prixNumber'] <= prix['max'])
                          .toList()
                          .length >
                      0) &&
              el['article'] != '')
          .toList();
      newLabel += '(${_produitsSearched.length})';
      _loading = false;
      _label = newLabel;
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? SizedBox(
              height: MediaQuery.of(context).size.height - 40,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Nouveautés $_label',
                          // style: Theme.of(context).textTheme.headline4,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final val = await _showFullModal(context, _filters);
                          if (val != null) {
                            setState(() {
                              _filters = val;
                            });
                            _search();
                          }
                        },
                        iconSize: 35,
                        icon: const Icon(
                          Icons.tune,
                        ),
                      ),
                    ],
                  ),
                ),
                _produitsSearched.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'Aucun résultat',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : Expanded(
                        child: GridView.count(
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 0.59,
                          children: <Widget>[
                            ..._buildAllItem(),
                            // _buildItem(text: 'Air Jordan 1 Low SE very very long'),
                            // _buildItem(),
                            // _buildItem(),
                            // _buildItem(),
                            // _buildItem(),
                          ],
                        ),
                      ),
              ],
            ),
    );
  }
}
