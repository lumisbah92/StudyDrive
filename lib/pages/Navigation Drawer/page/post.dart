import 'package:flutter/material.dart';

class posts extends StatelessWidget {
  const posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: CircleAvatar(),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "Kamolesh Roy Pritom",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.more_horiz),
              )
            ],
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 150,
              minWidth: 150,
              maxHeight: 350.0,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Container(
              child: Image.asset("assets/images/background_for_department.png"),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.33,
                child: Container(
                  width: 100,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        //width: 30,
                        child: Icon(Icons.favorite_border, color: Colors.blue),
                      ),
                      Container(
                        alignment: Alignment.center,
                        //width: 30,
                        child: Text("Upvote"),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.33,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      child: Icon(Icons.add_comment, color: Colors.black),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("comment"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
