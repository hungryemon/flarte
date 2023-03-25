import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'detail.dart';

class SerieScreen extends StatefulWidget {
  final String title;
  final String url;
  const SerieScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<SerieScreen> createState() => _SerieScreenState();
}

class _SerieScreenState extends State<SerieScreen> {
  List<dynamic> teasers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final resp =
          await http.get(Uri.parse('https://www.arte.tv${widget.url}'));
      final document = parser.parse(resp.body);
      final script = document.querySelector('script#__NEXT_DATA__');
      if (script != null) {
        final Map<String, dynamic> jd = json.decode(script.text);
        final zones =
            jd['props']['pageProps']['props']['page']['value']['zones'];
        for (var z in zones) {
          if (z['code'].startsWith('collection_subcollection_')) {
            setState(() {
              teasers.clear();
              teasers.addAll(z['content']['data']);
            });
            break;
          }
          //debugPrint(json.encode(teasers));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showDialogProgram(BuildContext context, Map<String, dynamic> v) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 8.0,
              child: SizedBox(
                  width: min(MediaQuery.of(context).size.width - 100, 600),
                  child: ShowDetail(video: v)));
        });
  }

  @override
  Widget build(BuildContext context) {
    int count = MediaQuery.of(context).size.width ~/ 285;
    double width = 285.0 * count;
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
            child: Container(
                width: width,
                child: GridView.count(
                  childAspectRatio: 0.85,
                  crossAxisCount: count,
                  children: teasers.map((t) {
                    return InkWell(
                        onTap: () {
                          _showDialogProgram(context, t);
                        },
                        child: Card(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: CachedNetworkImage(
                                      imageUrl: t['mainImage']['url']
                                          .replaceFirst('__SIZE__', '400x225'),
                                      height: 148,
                                      width: 265,
                                    )),
                                    const SizedBox(height: 10),
                                    Text(t['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 10),
                                    Text(t['teaserText'].toString().trim(),
                                        maxLines: 3,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 10),
                                    if (t['durationLabel'] != null)
                                      Chip(
                                        backgroundColor:
                                            Theme.of(context).primaryColorDark,
                                        label: Text(t['durationLabel']),
                                      ),
                                  ],
                                ))));
                  }).toList(),
                ))));
  }
}
