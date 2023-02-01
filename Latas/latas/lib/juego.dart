// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, duplicate_ignore, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';

import "dart:math" as math;

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
double moveToLeftBullet = anchoPantalla * 0.59;
double posicionBala = alturaPantalla * 0.75;

String bala = " ";

Timer? disparo;
bool disparoBala = false;

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
                    image: AssetImage("assets/FondoMinijuego2.jpg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // ignore: prefer_const_literals_to_create_immutables
              body: Stack(children: [
                Container(
                    margin: EdgeInsets.only(top: alturaPantalla * 0.9),
                    child: InkWell(
                      child: Image.asset("assets/Derecha.png"),
                      onTap: () {
                        moveRight();
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(
                        top: alturaPantalla * 0.9, left: anchoPantalla * 0.8),
                    child: InkWell(
                      child: Image.asset("assets/Izquierda.png"),
                      onTap: () {
                        moveLeft();
                      },
                    )),
                AnimatedContainer(
                  width: 22,
                  height: 22,
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
                        activarBala();
                      },
                    ))
              ]),
            )));
  }

  Widget bala() {
    return Image.asset(
      "assets/bala.png",
      fit: BoxFit.cover,
    );
  }

  double moveRight() {
    setState(() {
      moveToLeft = moveToLeft + 20;
      moveToLeftBullet = moveToLeftBullet + 20;
    });

    return moveToLeft;
  }

  double moveLeft() {
    setState(() {
      moveToLeft = moveToLeft - 20;
      moveToLeftBullet = moveToLeftBullet - 20;
    });

    return moveToLeft;
  }

  void activarBala() {
    disparoBala = true;
    disparo = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        posicionBala -= 40;
      });
      if (posicionBala <= 50) posicionBala = alturaPantalla * 0.75;
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
