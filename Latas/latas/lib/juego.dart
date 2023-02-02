// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, duplicate_ignore, prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Minijuego extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: StateMiniJuego()));
  }
}

class StateMiniJuego extends StatefulWidget {
  @override
  Juego createState() => Juego();
}

// ignore: prefer_typing_uninitialized_variables
var size;
var alturaPantalla;
var anchoPantalla;

Color colorBala = Colors.transparent;

double moveToLeft = anchoPantalla * 0.4;
double moveToLeftBullet = anchoPantalla * 0.50;
double posicionBala = alturaPantalla * 0.75;
double topLata = (randomAltura.nextDouble() * 500) + 50;
double anchoLata = (randomDerecha.nextDouble() * 300) + 50;

int totalCanHits = 0;

Timer? shoot;
Timer? canRestart;

bool disparoBala = false;
bool desaparecerLata = false;

Random randomAltura = Random();
Random randomDerecha = Random();

class Juego extends State<StateMiniJuego> {
  @override
  Widget build(BuildContext context) {
    //Recogemos las medidas de la pantalla
    setState(() {
      size = MediaQuery.of(context).size;
      alturaPantalla = size.height;
      anchoPantalla = size.width;
    });

    return MaterialApp(
        home: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Fondo.gif"), fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // ignore: prefer_const_literals_to_create_immutables
              body: Stack(children: [
                Container(
                    margin: EdgeInsets.only(top: alturaPantalla * 0.9),
                    child: InkWell(
                      child: Image.asset("assets/Izquierda.png"),
                      onTap: () {
                        moveLeft();
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(
                        top: alturaPantalla * 0.9, left: anchoPantalla * 0.8),
                    child: InkWell(
                      child: Image.asset("assets/Derecha.png"),
                      onTap: () {
                        moveRight();
                      },
                    )),
                AnimatedContainer(
                  width: 70,
                  height: 52,
                  margin: EdgeInsets.only(
                      top: posicionBala, left: moveToLeftBullet),
                  duration: Duration(milliseconds: 500),
                  child: disparoBala ? bala() : null,
                ),
                Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                        top: alturaPantalla * 0.75, left: moveToLeft),
                    child: Image.asset("assets/escopeta.png")),
                Container(
                    margin: EdgeInsets.only(
                        top: alturaPantalla * 0.9, left: anchoPantalla * 0.4),
                    child: InkWell(
                      child: Image.asset("assets/diana.png"),
                      onTap: () {
                        shootGun();
                      },
                    )),
                Container(child: !desaparecerLata ? canContainer() : null)
              ]),
            )));
  }

  Widget bala() {
    return Image.asset(
      "assets/bala.png",
    );
  }

  Widget canContainer() {
    if (totalCanHits <= 5) {
      return Container(
          width: 100,
          height: 70,
          margin: EdgeInsets.only(top: topLata, left: anchoLata),
          child: Image.asset("assets/zombie.png"));
    }
    return Container();
  }

  double moveRight() {
    setState(() {
      moveToLeft = moveToLeft + 5;
      moveToLeftBullet = moveToLeftBullet + 5;
    });

    return moveToLeft;
  }

  double moveLeft() {
    setState(() {
      moveToLeft = moveToLeft - 5;
      moveToLeftBullet = moveToLeftBullet - 5;
    });
    return moveToLeft;
  }

  void shootGun() {
    //The bullet is visible
    disparoBala = true;

    shoot = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        posicionBala -= 40;
        //Hitbox can
        if (posicionBala <= topLata &&
            moveToLeftBullet >= anchoLata &&
            moveToLeftBullet <= (anchoLata + 100)) {
          desaparecerLata = true;
          //The bullet is invisible and comes back to the initial position
          disparoBala = false;
          posicionBala = alturaPantalla * 0.75;
          totalCanHits++;
          checkWinner();
          //Restart the can in 1 seconds
          canRestarted();
          timer.cancel();
        }
      });
      if (posicionBala <= 10) {
        setState(() {
          // The bullet hits can and comes back to the initial position
          posicionBala = alturaPantalla * 0.75;
          timer.cancel();
        });
        disparoBala = false;
      }
    });
  }

  void canRestarted() {
    Random randomAncho2 = Random();
    Random randomAltura2 = Random();
    double ancho2 = (randomAncho2.nextDouble() * 300) + 50;
    double altura2 = (randomAltura2.nextDouble() * 500) + 50;
    int counter = 0;
    canRestart = Timer.periodic(Duration(milliseconds: 800), (timer) {
      counter++;
      if (counter == 2) {
        setState(() {
          anchoLata = ancho2;
          topLata = altura2;
          desaparecerLata = false;
          timer.cancel();
        });
      }
    });
  }

// Winner Checks
  void checkWinner() {
    if (totalCanHits == 5) {
      showDialog(
          barrierColor: Colors.white,
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(actions: <Widget>[
                Stack(children: [Container(child: Text('Has ganado'))])
              ]));
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
