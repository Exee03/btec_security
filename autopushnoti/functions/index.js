const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();

exports.statusDatabaseTrigger = functions.database.ref(
    '/{userId}'
).onWrite( async (change, context) => {

    const msgData = change.after.val();
    const before = change.before.val();

    var currentDate = new Date();
    var date = currentDate.getDate();
    var month = currentDate.getMonth();
    var year = currentDate.getFullYear();
    var hour = currentDate.getHours();
    var minute = currentDate.getMinutes();

    // change time zone
    if (hour < 16) {
        hour = hour + 8;
        var dateMonthYear = date + "-" + (month + 1) + "-" + year;
    } else {
        hour = hour - 16;
        var dateMonthYear = (date + 1) + "-" + (month + 1) + "-" + year;
    }
    // format 24 to 12
    if (hour > 12) {
        hour = hour - 12;
        var ampm = 'pm';
    } else {
        var ampm = 'am';
    }
    if (minute < 10) {
        var hourMinute = hour + ":0" + minute + ampm;
    } else {
        var hourMinute = hour + ":" + minute + ampm;
    }

    console.log(dateMonthYear + ' at ' + hourMinute);
    console.log('From : ' + before.status);
    console.log('To : ' + msgData.status);

    if (before.status == msgData.status) {
        console.log('Nothing change!');
        return null;
    }

    await saveFirestore(msgData, dateMonthYear, hourMinute);
    console.log('exit saveFirestore');

    await firestore.collection('users').where("uid", "==", msgData.uid).get().then((snapshots) => {
        var tokens = [];
        console.log("Check Firestore");
        if (snapshots.empty) {
            console.log('No devices');
            return null;
        } else {
            console.log("Get User");
            for (var user of snapshots.docs) {
                console.log('db        : ' + msgData.uid);
                console.log('Firestore : ' + user.data().uid);

                if (user.data().uid == msgData.uid) {
                    tokens.push(user.data().token);
                    console.log("Get Token");
                } else {
                    console.log('uid not available in users collection');
                    return null;
                }
                console.log("after get token");
            }
            console.log('before detected loop');
            if (msgData.status == 'Detected!') {
                console.log('entering detected loop');
                var payload = {
                    notification: {
                        title: 'Status : ' + msgData.status,
                        body: 'An unknown person attempts to enter your office ( ' + msgData.name + ' )',
                        sound: 'loudalarm.mp3'
                    },
                    data: {
                        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                        'title': 'Status : ' + msgData.status,
                        'body': 'An unknown person attempts to enter your office ( ' + msgData.name + ' )',
                    }
                }
                var options = {
                    priority: "high",
                    timeToLive: 60 * 60 * 24,
                    contentAvailable: true
                };

                return admin.messaging().sendToDevice(tokens, payload, options).then((response) => {
                    console.log('Successfully push notifications : ' + response);
                }).catch((err) => {
                    console.log('Error : ' + err);
                })
            }
            else {
                console.log("Status : " + msgData.status);
                return null;
            }
        }
    })
    console.log('outsite firestore loop');
    return null;
})

function saveFirestore(data, dateMonthYear, hourMinute) {
    console.log('enter saveFirestore');

    const ref = firestore.collection("status").doc(data.uid).collection(dateMonthYear);

    const newData = {
        status: data.status,
        detail: 'An unknown person attempts to enter your office ( ' + data.name + ' )',
        time: hourMinute
    }

    return ref.add(newData).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}
