const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.statusDatabaseTrigger = functions.database.ref(
    '/{userId}'
).onWrite((change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    console.log('From : ' + before.status);
    console.log('To : ' + msgData.status);

    if (before.status == msgData.status) {
        console.log('Nothing change!');
        return null;
    }

    if (msgData.status == 'Detected!') {
        admin.firestore().collection('users').get().then((snapshots) => {
            var tokens = [];
            console.log("Check Firestore");
            if (snapshots.empty) {
                console.log('No devices');
                return null;
            } else {
                console.log("Get User");
                for (var user of snapshots.docs) {
                    if (user.data().uid == msgData.uid) {
                        tokens.push(user.data().token);
                        console.log("Get Token");
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
                    console.log('Successfully push notifications!');
                }).catch((err) => {
                    console.log('Error : ' + err);
                })
            }
        })
    }
    else {
        console.log("Status : " + msgData.status);
        return null;
    }
})
