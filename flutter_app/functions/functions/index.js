//import * as functions from 'firebase-functions';
//import * as admin from 'firebase-admin';
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firestore);
const fcm = admin.messaging();
/*
 exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
 });*/
    // [START trigger_document_updated]
    exports.updateUser = functions.firestore
        .document('task/{CMRCET}')
        .onUpdate((change, context) => {
          // Get an object representing the document
          // e.g. {'name': 'Marie', 'age': 66}
          const newValue = change.after.data();
  
          // ...or the previous value before this update
          const previousValue = change.before.data();
  
          // access a particular field as you would any JS property
          const name = newValue.name;
          const token="12345";
  console.log(newValue.taskvalue-previousValue.taskvalue);
  //console.log(previousValue.taskvalue);

          // perform desired operations ...
          const payload={
              notification:{
                  title:'Placements update',
                  body:'hello',
                  badge:'1',
                  sound:'default'
              }

          };
          //const token=Object.keys(allToken.val());
          return admin.messaging().sendToDevice(token,payload);
        });
    // [END trigger_document_updated]
