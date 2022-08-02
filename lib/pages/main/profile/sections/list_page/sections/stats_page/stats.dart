import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movielab/constants/colors.dart';
import 'package:movielab/models/hive/models/show_preview.dart';
import 'package:movielab/models/show_models/show_preview_model.dart';
import 'package:movielab/modules/preferences_shareholder.dart';
import 'package:movielab/pages/main/profile/sections/list_page/sections/stats_page/sections/navbar.dart';
import 'package:movielab/pages/main/profile/sections/list_page/sections/stats_page/sections/stats_chart.dart';

class ListStatsPage extends StatefulWidget {
  final String listName;
  const ListStatsPage({Key? key, required this.listName}) : super(key: key);

  @override
  State<ListStatsPage> createState() => _ListStatsPageState();
}

class _ListStatsPageState extends State<ListStatsPage> {
  double imdbRatingAverage = 0;
  Map<String, int> genres = {};
  List<String> sortedGenres = [];

  Map<String, int> countries = {};
  List<String> sortedCountries = [];

  Map<String, int> languages = {};
  List<String> sortedLanguages = [];

  Map<String, int> companies = {};
  List<String> sortedCompanies = [];

  Map<String, int> contentRatings = {};
  List<String> sortedContentRatings = [];

  @override
  void initState() {
    super.initState();
    getListStats().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: listPageStatsNavbar(context, listName: widget.listName),
        body: ValueListenableBuilder<Box<HiveShowPreview>>(
            valueListenable:
                Hive.box<HiveShowPreview>(widget.listName).listenable(),
            builder: (context, box, _) {
              final list = box.values.toList().cast<HiveShowPreview>();
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      list.length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Items",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                        color: kBlueColor.withOpacity(0.55), thickness: 7.5),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$imdbRatingAverage",
                            style: const TextStyle(
                              color: kImdbColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            )),
                        const Icon(Icons.star_rounded,
                            size: 30, color: kImdbColor),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: imdbRatingAverage / 10,
                            color: kImdbColor,
                            backgroundColor: kImdbColor.withOpacity(0.15),
                            minHeight: 13,
                          ),
                        )),
                    const SizedBox(
                      height: 7.5,
                    ),
                    Text("Avarage IMDB rating",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    StatsChart(
                      index: 0,
                      statsName: "Genres",
                      sortedSections: sortedGenres,
                      sections: genres,
                      length: sortedGenres.length > 7 ? 7 : sortedGenres.length,
                    ),
                    StatsChart(
                      index: 1,
                      statsName: "Countries",
                      sortedSections: sortedCountries,
                      sections: countries,
                      length: sortedCountries.length > 7
                          ? 7
                          : sortedCountries.length,
                    ),
                    StatsChart(
                      index: 2,
                      statsName: "Languages",
                      sortedSections: sortedLanguages,
                      sections: languages,
                      length: sortedLanguages.length > 7
                          ? 7
                          : sortedLanguages.length,
                    ),
                    StatsChart(
                      index: 3,
                      statsName: "Companies",
                      sortedSections: sortedCompanies,
                      sections: companies,
                      length: sortedCompanies.length > 7
                          ? 7
                          : sortedCompanies.length,
                    ),
                    StatsChart(
                      index: 4,
                      statsName: "Contents",
                      sortedSections: sortedContentRatings,
                      sections: contentRatings,
                      length: sortedContentRatings.length > 7
                          ? 7
                          : sortedContentRatings.length,
                    ),
                  ],
                ),
              );
            }));
  }

  getListStats() async {
    await getImdbRatingAverage().then((value) async {
      //await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        imdbRatingAverage = value;
      });
    });
    await getSortedGenres().then((value) => setState(() {
          sortedGenres = value;
        }));
    await getSortedCountries().then((value) => setState(() {
          sortedCountries = value;
        }));
    await getSortedLanguages().then((value) => setState(() {
          sortedLanguages = value;
        }));
    await getSortedCompanies().then((value) => setState(() {
          sortedCompanies = value;
        }));
    await getSortedContentRatings().then((value) => setState(() {
          sortedContentRatings = value;
        }));
  }

  Future<double> getImdbRatingAverage() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    List<double> itemsImdbRatings = [];
    for (ShowPreview item in items) {
      try {
        itemsImdbRatings.add(double.parse(item.imDbRating));
        // ignore: empty_catches
      } catch (e) {}
    }
    final double itemsImdbRatingAverage = double.parse(
        ((itemsImdbRatings.reduce((a, b) => a + b) / itemsImdbRatings.length))
            .toStringAsFixed(2));
    return itemsImdbRatingAverage;
  }

  Future<List<String>> getSortedGenres() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    Map<String, int> itemsGenres = {};
    for (ShowPreview item in items) {
      for (String genre in item.genres!.split(", ")) {
        if (itemsGenres.containsKey(genre)) {
          itemsGenres[genre] = itemsGenres[genre]! + 1;
        } else {
          itemsGenres[genre] = 1;
        }
      }
    }
    setState(() {
      genres = itemsGenres;
    });
    final List<String> sortedGenres = itemsGenres.keys.toList();
    sortedGenres.sort((a, b) => itemsGenres[b]!.compareTo(itemsGenres[a]!));
    return sortedGenres;
  }

  Future<List<String>> getSortedCountries() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    Map<String, int> itemsCountries = {};
    for (ShowPreview item in items) {
      for (String country in item.countries!.split(", ")) {
        if (itemsCountries.containsKey(country)) {
          itemsCountries[country] = itemsCountries[country]! + 1;
        } else {
          itemsCountries[country] = 1;
        }
      }
    }
    setState(() {
      countries = itemsCountries;
    });
    final List<String> sortedCountries = itemsCountries.keys.toList();
    sortedCountries
        .sort((a, b) => itemsCountries[b]!.compareTo(itemsCountries[a]!));
    return sortedCountries;
  }

  Future<List<String>> getSortedLanguages() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    Map<String, int> itemsLanguages = {};
    for (ShowPreview item in items) {
      for (String language in item.languages!.split(", ")) {
        if (itemsLanguages.containsKey(language)) {
          itemsLanguages[language] = itemsLanguages[language]! + 1;
        } else {
          itemsLanguages[language] = 1;
        }
      }
    }
    setState(() {
      languages = itemsLanguages;
    });
    final List<String> sortedLanguages = itemsLanguages.keys.toList();
    sortedLanguages
        .sort((a, b) => itemsLanguages[b]!.compareTo(itemsLanguages[a]!));
    return sortedLanguages;
  }

  Future<List<String>> getSortedCompanies() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    Map<String, int> itemsCompanies = {};
    for (ShowPreview item in items) {
      for (String company in item.companies!.split(", ")) {
        if (itemsCompanies.containsKey(company)) {
          itemsCompanies[company] = itemsCompanies[company]! + 1;
        } else {
          itemsCompanies[company] = 1;
        }
      }
    }
    setState(() {
      companies = itemsCompanies;
    });
    final List<String> sortedCompanies = itemsCompanies.keys.toList();
    sortedCompanies
        .sort((a, b) => itemsCompanies[b]!.compareTo(itemsCompanies[a]!));
    return sortedCompanies;
  }

  Future<List<String>> getSortedContentRatings() async {
    List<ShowPreview> items = [];
    PreferencesShareholder preferencesShareholder = PreferencesShareholder();
    await preferencesShareholder
        .getList(listName: widget.listName)
        .then((value) => {items = value});
    Map<String, int> itemsContentRatings = {};
    for (ShowPreview item in items) {
      for (String contentRating in item.contentRating!.split(", ")) {
        if (itemsContentRatings.containsKey(contentRating)) {
          itemsContentRatings[contentRating] =
              itemsContentRatings[contentRating]! + 1;
        } else {
          itemsContentRatings[contentRating] = 1;
        }
      }
    }
    setState(() {
      contentRatings = itemsContentRatings;
    });
    final List<String> sortedContentRatings = itemsContentRatings.keys.toList();
    sortedContentRatings.sort(
        (a, b) => itemsContentRatings[b]!.compareTo(itemsContentRatings[a]!));
    return sortedContentRatings;
  }
}
