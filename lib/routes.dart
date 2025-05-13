// import 'package:flutter/material.dart';
// import 'views/beranda/HomePage.dart';
// import 'views/dokter/DokterDetail.dart';
// import 'views/dokter/pembayaran.dart'; 
// import 'views/article_page.dart'; 
// import 'views/article_detail_page.dart'; // Tambahkan ini
// import 'models/dokter.dart';
// import 'splash.dart'; // Tambahkan ini juga

// class AppRoutes {
//   static const String splash = '/';
//   static const String home = '/home';
//   static const String doctorDetail = '/doctorDetail';
//   static const String pembayaranDokter = '/bayarDokter';
//   static const String artikel = '/artikel';
//   static const String artikelDetail = '/artikelDetail';


//   static Route generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case splash:
//         return MaterialPageRoute(
//           builder: (_) => SplashScreen(nextScreen: HomePage()),
//         );

//       case home:
//         return MaterialPageRoute(builder: (_) => HomePage());

//       case doctorDetail:
//         if (settings.arguments == null || settings.arguments is! Dokter) {
//           return MaterialPageRoute(
//             builder:
//                 (_) => const Scaffold(
//                   body: Center(child: Text('Data dokter tidak ditemukan')),
//                 ),
//           );
//         }

//         final dokter = settings.arguments as Dokter;
//         return MaterialPageRoute(
//           builder: (_) => DoctorDetailPage(dokter: dokter),
//         );

//       case pembayaranDokter:
//         if (settings.arguments == null || settings.arguments is! Dokter) {
//           return MaterialPageRoute(
//             builder:
//                 (_) => const Scaffold(
//                   body: Center(child: Text('Data dokter tidak ditemukan')),
//                 ),
//           );
//         }

//         final dokter = settings.arguments as Dokter;
//         return MaterialPageRoute(
//           builder: (_) => BayarDokterPage(dokter: dokter),
//         );

//       case artikel:
//         return MaterialPageRoute(builder: (_) => ArticlePage());

//       case artikelDetail:
//         final article = settings.arguments as Article;
//         return MaterialPageRoute(
//           builder: (_) => ArticleDetailPage(articleId: article.id),
//         );

//       default:
//         return MaterialPageRoute(
//           builder:
//               (_) =>
//                   const Scaffold(body: Center(child: Text('Page Not Found'))),
//         );
//     }
//   }
// }
