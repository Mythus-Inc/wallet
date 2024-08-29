import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60, 
          left: 40, 
          right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 180,
              height: 180,
              child: Image.asset("assets/app/ifprlogo.png"),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "R.A.",
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "RA",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 172, 172, 172),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                filled: true,
                fillColor: Color(0xFFCED1CE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Senha",
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 172, 172, 172),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                filled: true,
                fillColor: Color(0xFFCED1CE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 129, 68),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child: Text(
                    "Acessar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => {},
                ),
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                child: Text(
                  "Recuperar Senha",
                ),
                onPressed: () {},               
              )
            )
          ]
        )
      ),
    );
  }
}