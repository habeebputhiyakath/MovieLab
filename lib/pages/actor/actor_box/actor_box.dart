import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movielab/models/models.dart';
import 'package:movielab/modules/navigate.dart';
import 'package:movielab/pages/actor/actor_page/actor_page.dart';

class ShowActorBox extends StatelessWidget {
  final ActorPreview actor;
  const ShowActorBox({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigate.pushTo(context, ActorPage(id: actor.id));
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.only(left: 2.5, right: 2.5, top: 10),
        width: 90,
        child: Column(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: actor.image,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholder: (context, url) => const Center(
                          child: SpinKitThreeBounce(
                            color: Colors.white,
                            size: 15.0,
                          ),
                        )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 3),
              child: Text(actor.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: GoogleFonts.ubuntu(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
            Text(actor.asCharacter,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.ubuntu(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
