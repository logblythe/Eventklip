import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/models/response.dart';
import 'package:eventklip/models/title_and_content.dart';

List<VideoDetails> getSliders() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/slider1.jpg",
      title: "Bushland",
      views: 3));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/slider1_.jpg",
      title: "The Jungle Book",
      views: 3));

  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/slider2_.jpg",
      title: "Sail Coaster",
      views: 3));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/slider3.jpg",
      title: "The Army",
      views: 3));

  return list;
}

List<VideoDetails> getMovieSliders() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/05.jpg",
      title: "Jumbo Queeen",
      views: 2));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/06.jpg",
      title: "The Lost Journey",
      views: 2));

  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/07.jpg",
      title: "Open Dead Shot",
      views: 2));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/08.jpg",
      title: "Unknown Land",
      views: 2));

  return list;
}

List<VideoDetails> getShowsSliders() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/01.jpg",
      title: "The Hero Camp",
      views: 5));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/02.jpg",
      title: "The Apartment",
      views: 3));

  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/03.jpg",
      title: "The Marshal King",
      views: 3));

  return list;
}

List<VideoDetails> getUpcomingMovie() {
  var list = List<VideoDetails>();
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/01.jpg"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/02.jpg"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/03.jpg"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/04.jpg"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/05.jpg"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/upcoming/06.jpg"));

  return list;
}

List<VideoDetails> getPopularShows() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/01.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/02.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/03.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/04.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/05.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/06.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/07.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/08.jpg",
  ));
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/shows/09.jpg",
  ));

  return list;
}

List<VideoDetails> getInternationalShows() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/05.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/06.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/04.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/08.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/07.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/09.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/01.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/02.jpg"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/shows/03.jpg"));

  return list;
}

List<VideoDetails> getBollywoodBlockBusters() {
  return getUpcomingMovie();
}

List<VideoDetails> getTrendingOnMovie() {
  var list = List<VideoDetails>();
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/01.jpg",title: "Trending video"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/02.jpg",title: "Trending video"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/03.jpg",title: "Trending video"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/04.jpg",title: "Trending video"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/05.jpg",title: "Trending video"));
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/trending/06.jpg",title: "Trending video"));

  return list;
}

List<VideoDetails> getMadeForYouMovie() {
  var list = List<VideoDetails>();
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/suggested/01.jpg",title:"Video Dummy Title",)) ;
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/suggested/02.jpg",title:"Video Dummy Title",)) ;
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/suggested/03.jpg",title:"Video Dummy Title",)) ;
  list.add(
      VideoDetails(thumbnailLocation: "assets/items/home/suggested/04.jpg",title:"Video Dummy Title",)) ;
  list.add(VideoDetails(
    thumbnailLocation: "assets/items/home/suggested/05.jpg", title:"Video Dummy Title",
  ));

  return list;
}

List<VideoDetails> getTop10() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/01.jpg", title:"Video Dummy Title",duration: "20:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/02.jpg", title:"Video Dummy Title",duration: "20:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/03.jpg", title:"Video Dummy Title",duration: "20:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/04.jpg", title:"Video Dummy Title",duration: "20:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/05.jpg", title:"Video Dummy Title",duration: "20:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/movies/06.jpg", title:"Video Dummy Title",duration: "20:30"));

  return list;
}

List<VideoDetails> getEpisodes() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/01.jpg", title:"Video Dummy Title",duration: "20:50"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/02.jpg", title:"Video Dummy Title",duration: "29:50"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/03.jpg", title:"Video Dummy Title",duration: "29:50"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/04.jpg", title:"Video Dummy Title",duration: "3:50"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/05.jpg", title:"Video Dummy Title",duration: "4:50"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/06.jpg", title:"Video Dummy Title",duration: "6:10"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/07.jpg", title:"Video Dummy Title",duration: "20:10"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/08.jpg", title:"Video Dummy Title",duration: "66:10"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/09.jpg", title:"Video Dummy Title",duration: "43:30"));
  list.add(VideoDetails(thumbnailLocation: "assets/items/episodes/10.jpg", title:"Video Dummy Title",duration: "20:30"));

  return list;
}

List<VideoDetails> getContinueMovies() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/favorite/01.jpg",duration: "20:30",
      title: "Champions in the Ring"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/favorite/02.jpg",duration: "30:30",
      title: "Last Race"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/favorite/03.jpg",duration: "90:30",
      title: "Boop Bitty"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/favorite/04.jpg",duration: "10:30",
      title: "Dino Land"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/home/favorite/05.jpg",duration: "04:30",
      title: "Jaction Action"));

  return list;
}

List<VideoDetails> getMyListMovies() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/03.jpg", title: "Hubby Cubby"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/01.jpg", title: "The Illusion"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/06.jpg", title: "Last Race"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/07.jpg", title: "Dino land"));

  return list;
}

List<VideoDetails> getDownloadedMovies() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/movies/08.jpg", title: "Unknown Land"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/03.jpg", title: "Arrival 1999"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/shows/04.jpg", title: "Night Mare"));

  return list;
}

List<FAQ> getFaq() {
  var list = List<FAQ>();
  list.add(FAQ(
      title: "How to delete conitnue watching",
      subTitle:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
      isExpanded: false));
  list.add(FAQ(
      title: "How to delete conitnue watching",
      subTitle:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
      isExpanded: false));
  list.add(FAQ(
      title: "How to delete conitnue watching",
      subTitle:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
      isExpanded: false));
  list.add(FAQ(
      title: "How to delete conitnue watching",
      subTitle:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
      isExpanded: false));
  list.add(FAQ(
      title: "How to delete conitnue watching",
      subTitle:
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
      isExpanded: false));

  return list;
}

List<VideoDetails> getActors() {
  var list = List<VideoDetails>();
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/actors/1.jpg", title: "Rajiv Kapoor"));
  list.add(VideoDetails(title: "John doe"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/actors/02.jpg", title: "Alice Denial"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/actors/03.jpg", title: "John Vinaas"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/actors/04.jpg",
      title: "Alexender Cinah"));
  list.add(VideoDetails(
      thumbnailLocation: "assets/items/actors/05.jpg", title: "Tim Svages"));

  return list;
}


List<TitleAndContent> getTerms(){
  return [
    TitleAndContent("Introduction", """These Website Standard Terms And Conditions (these “Terms” or these “Website Standard
Terms And Conditions”) contained herein on this webpage, shall govern your use of this
website, including all pages within this website (collectively referred to herein below as this
“Website”). These Terms apply in full force and effect to your use of this Website and by
using this Website, you expressly accept all terms and conditions contained herein in full.
You must not use this Website, if you have any objection to any of these Website Standard
Terms And Conditions."""),
    TitleAndContent("Intellectual Property Rights", """Other than content you own, which you may have opted to include on this Website, under
these Terms, eventklip and/or its licensors own all rights to the intellectual property and
material contained in this Website, and all such rights are reserved. You are granted a
limited license only, subject to the restrictions provided in these Terms, for purposes of
viewing the material contained on this Website."""),
    TitleAndContent("Restrictions", """You are expressly and emphatically restricted from all of the following:
1. publishing any Website material in any media;
2. selling, sublicensing and/or otherwise commercializing any Website material;
3. publicly performing and/or showing any Website material;
4. using this Website in any way that is, or may be, damaging to this Website;
5. using this Website in any way that impacts user access to this Website;
6. using this Website contrary to applicable laws and regulations, or in a way that
causes, or may cause, harm to the Website, or to any person or business
entity;
7. engaging in any data mining, data harvesting, data extracting or any other
similar activity in relation to this Website, or while using this Website;
8. using this Website to engage in any advertising or marketing;
Certain areas of this Website are restricted from access by you and eventklip may further
restrict access by you to any areas of this Website, at any time, in its sole and absolute
discretion. Any user ID and password you may have for this Website are confidential and
you must maintain confidentiality of such information."""),
    TitleAndContent("Your Content", """In these Website Standard Terms And Conditions, “Your Content” shall mean any audio,
video, text, images or other material you choose to display on this Website. With respect to
Your Content, by displaying it, you grant eventklip a non-exclusive, worldwide, irrevocable,

royalty-free, sublicensable license to use, reproduce, adapt, publish, translate and distribute
it in any and all media.
Your Content must be your own and must not be infringing on any third party’s
rights. eventklip reserves the right to remove any of Your Content from this Website at any
time, and for any reason, without notice."""),
    TitleAndContent("No warranties", """This Website is provided “as is,” with all faults, and eventklip makes no express or implied
representations or warranties, of any kind related to this Website or the materials contained
on this Website. Additionally, nothing contained on this Website shall be construed as
providing consult or advice to you."""),
    TitleAndContent("Limitation of liability", """In no event shall eventklip, nor any of its officers, directors and employees, be liable to you
for anything arising out of or in any way connected with your use of this Website, whether
such liability is under contract, tort or otherwise, and eventklip, including its officers, directors
and employees shall not be liable for any indirect, consequential or special liability arising
out of or in any way related to your use of this Website."""),
    TitleAndContent("Indemnification", """You hereby indemnify to the fullest extent eventklip from and against any and all liabilities,
costs, demands, causes of action, damages and expenses (including reasonable attorney’s
fees) arising out of or in any way related to your breach of any of the provisions of these
Terms."""),
    TitleAndContent("Severability", """If any provision of these Terms is found to be unenforceable or invalid under any applicable
law, such unenforceability or invalidity shall not render these Terms unenforceable or invalid
as a whole, and such provisions shall be deleted without affecting the remaining provisions
herein."""),
    TitleAndContent("Variation of Terms", """eventklip is permitted to revise these Terms at any time as it sees fit, and by using this
Website you are expected to review such Terms on a regular basis to ensure you
understand all terms and conditions governing use of this Website."""),
    TitleAndContent("Assignment", """eventklip shall be permitted to assign, transfer, and subcontract its rights and/or obligations
under these Terms without any notification or consent required. However, .you shall not be
permitted to assign, transfer, or subcontract any of your rights and/or obligations under
these Terms."""),
    TitleAndContent("Entire Agreement", """These Terms, including any legal notices and disclaimers contained on this Website,
constitute the entire agreement between eventklip and you in relation to your use of this
Website, and supersede all prior agreements and understandings with respect to the same."""),
    TitleAndContent(" Governing Law &amp; Jurisdiction", """These Terms will be governed by and construed in accordance with the laws of the State
of [State], and you submit to the non-exclusive jurisdiction of the state and federal courts
located in [State] for the resolution of any disputes."""),
  ];
}