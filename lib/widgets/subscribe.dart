import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addSubscribe(String workId,String userId) async{
  List mySubscribe;
  Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
    mySubscribe =document['mySubscribe']??[];
    if (mySubscribe.indexOf(workId)==-1){
      mySubscribe.add(workId);
    }

  }).then((e){
    Firestore.instance.collection('users').document(userId).updateData(
        {'mySubscribe': mySubscribe});
  });

}

void removeSubscribe(String workId,String userId,BuildContext context) async{
  List mySubscribe;
  Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
    mySubscribe =document['mySubscribe']??[];
    mySubscribe.remove(workId);

  }).then((e){
    Firestore.instance.collection('users').document(userId).updateData(
        {'mySubscribe': mySubscribe});
  }).then((value) {});

}