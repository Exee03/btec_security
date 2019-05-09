const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.statusTrigger = functions.firestore.document(
    'status/{statusId}'
).onWrite((change, context) => {
    const msgData = change.after.exists ? change.after.data() : null;
    const before = change.before.data();

    if (before.status == msgData.status) {
        console.log('Nothing change!');
        return null;
    }

    admin.firestore().collection('users').get().then((snapshots) => {
        var tokens = [];
        
        if (snapshots.empty) {
            console.log('No devices');
            return null;
        } else {
            for (var user of snapshots.docs) {
                if (user.data().uid == msgData.uid) {
                    tokens.push(user.data().token);
                } else {
                    console.log('uid not available in users collection');
                    return null;
                }
            }

            var payload = {
                'notification': {
                    'title': 'Status : ' + msgData.status,
                    'body': 'An unknown person attempts to enter your office ( ' + msgData.name + ' )',
                    'sound': 'loudalarm.mp3'
                },
            }

            var options = {
                priority: "high",
                timeToLive: 60 * 60 * 24,
                contentAvailable: true
              };

            return admin.messaging().sendToDevice(tokens, payload, options).then((response) => {
                console.log(' Succefull push notifications : ' + response.results);
            }).catch((err) => {
                console.log('Error : ' + err);
            })
        }
    })
})
