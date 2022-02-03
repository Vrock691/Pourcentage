import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) =>
            const ExtractArgumentsScreen(),
      },
      title: 'Pourcentage de réduction',
      home: const HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: Colors.amberAccent,
          primary: Colors.amber,
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: Colors.amberAccent,
          surface: Colors.amberAccent,
          error: Colors.red,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
      ),
    );
  }
}

final percentController = TextEditingController();
final priceController = TextEditingController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pourcentage de réduction'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
                controller: priceController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Prix en euros (€)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
                controller: percentController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Pourcentage de réduction (%)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          void err(errmessage) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(errmessage),
                  action: SnackBarAction(
                    label: "Fermer",
                    onPressed: () {
                      // empty
                    },
                  ),
                ))
              };

          if (percentController.text != "" && priceController.text != "") {
            var percent = num.tryParse(percentController.text);
            var price = num.tryParse(priceController.text);

            if (percent! < 101 && percent > 0) {
              if (price! > 0) {
                var newprice = price - ((price * percent) / 100);
                var newpriceString = newprice.toString();
                var save = price - newprice;
                var savingString = save.toString();
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsScreen.routeName,
                  arguments: ScreenArguments(priceController.text,
                      percentController.text, newpriceString, savingString),
                );
              } else {
                err('Le prix doit être supérieur à 0.');
              }
            } else {
              err('Les pourcents doivent être compris entre 0 et 100.');
            }
          } else {
            err('Tout les champs ne sont pas remplis.');
          }
        },
        label: const Text("Calculer"),
        icon: const Icon(Icons.calculate),
      ),
    );
  }
}

class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({Key? key}) : super(key: key);

  static const routeName = '/extractArguments';
  static const style = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultat du calcul"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Prix initial : " + args.initialprice + "€",
                  style: style,
                ),
                Text(
                  "Taux de réduction : " + args.percent + "%",
                  style: style,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const Text("Prix Final après réduction",
                          style: TextStyle(fontSize: 15, color: Colors.green)),
                      Text(
                        args.newprice + "€",
                        style:
                            const TextStyle(color: Colors.green, fontSize: 30),
                      )
                    ],
                  ),
                ),
                Text(
                  "Vous avez économisé environ " + args.saving + "€",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Fait ♥ par Valentin",
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          )),
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String initialprice;
  final String percent;
  final String newprice;
  final String saving;

  ScreenArguments(this.initialprice, this.percent, this.newprice, this.saving);
}
