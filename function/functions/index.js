const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();
const db = admin.database();

const spawn = require('child-process-promise').spawn;
const path = require('path');
const os = require('os');
const fs = require('fs');

const client = require('twilio')("ACb87faf643fcd88901858d3019ae1201f", "dde5e9c4d9e28e24f971a1acb68b824b");

exports.getAuth = functions.https.onRequest((request, response) => {
    const email = request.headers.email;
    console.log(email);

    return firestore.collection('admin').where("email", "==", email).get().then((snapshots) => {
        console.log("Check Firestore");
        if (snapshots.empty) {
            console.log('No email');
            return response.send({ 'auth': false });
        } else {
            console.log("Get User");
            return response.send({ 'auth': true });
        }
    }).catch(error => {
        response.send(error);
    });
});

exports.getCompany = functions.https.onRequest((request, response) => {
    const email = request.body.email;
    const userId = request.body.uid;
    console.log(email);

    return firestore.collection('admin').where("email", "==", email).get().then((snapshots) => {
        console.log("Check Firestore");
        if (snapshots.empty) {
            console.log('No email');
        } else {
            console.log("Get User");
            for (var user of snapshots.docs) {
                console.log('Firestore : ' + user.data().company);
                return firestore.collection('employee').doc(userId).get().then(result => {
                    if (result.data() == null) {
                        console.log('Null')
                        return response.send({ 'totalEmployee': 0, 'company': user.data().company });
                    } else {
                        console.log('successful! : ' + result.data())
                        return response.send({ 'totalEmployee': result.data().totalEmployee, 'company': user.data().company });
                    }
                }).catch(error => {
                    response.send(error);
                });
            }
        }
    }).catch(error => {
        response.send(error);
    });
});

exports.attendanceTrigger = functions.database.ref(
    '/attendance/{uid}'
).onWrite(async (change, context) => {
    const data = change.after.val();
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
    console.log('time = ', hourMinute);

    if (data.time == "null") {
        return addTime(hourMinute, data);
    }

    console.log(before.time);
    console.log(data.time);

    if (before.time == data.time && before.scanData == data.scanData) {
        console.log('Nothing change!');
        return null;
    }

    return firestore.collection('employee').doc(data.uid).collection(data.branch).where('id', '==', data.scanData).get().then((snapshots) => {
        console.log("Check Firestore");
        if (snapshots.empty) {
            console.log('No devices');
            return null;
        } else {
            console.log("Get User");
            for (var employee of snapshots.docs) {
                console.log('db        : ' + data.uid);
                console.log('Firestore : ' + employee.data().name);

                if (employee.data().id == data.scanData) {
                    console.log("Get name & attendance");
                    var name = employee.data().name;
                    var details = name + ' enter your office at ' + data.branch + ' branch.';
                    const refAttd = firestore.collection('attendance').doc(data.uid).collection(dateMonthYear).where('name', '==', name);
                    return refAttd.get().then((snapshots) => {
                        if (snapshots.empty) {
                            return saveAttendance(data, employee.data(), dateMonthYear)
                                .then((_) => saveHistory(data.uid, 'Attendance', details, dateMonthYear, data.time));
                        } else {
                            console.log('Already attend')
                        }

                    });
                } else {
                    console.log('uid not available in users collection');
                    return null;
                }
            }
        }
    })
})

function addTime(hourMinute, data) {
    const ref = db.ref("attendance/" + data.uid);
    return ref.update({ "time": hourMinute });

}

function saveAttendance(data, employee, dateMonthYear) {
    console.log('enter saveAttendance');

    const refAttendance = firestore.collection("attendance").doc(data.uid).collection(dateMonthYear);

    const newData = {
        name: employee.name,
        time: data.time
    }

    return refAttendance.add(newData).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}

exports.statusTrigger = functions.database.ref(
    'status/{userId}'
).onWrite(async (change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    const userId = msgData.uid;
    console.log(userId);

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
        var hourMinute2 = hour + "0" + minute + ampm;
    } else {
        var hourMinute = hour + ":" + minute + ampm;
        var hourMinute2 = hour + minute + ampm;
    }

    console.log(dateMonthYear + ' at ' + hourMinute);
    console.log('From : ' + before.status);
    console.log('To : ' + msgData.status);

    if (before.status == msgData.status) {
        console.log('Nothing change!');
        return null;
    }

    await saveHistory(userId, msgData.status, 'An unknown person attempts to enter your office.', dateMonthYear, hourMinute);
    console.log('exit saveFirestore');

    await firestore.collection('users').where("uid", "==", userId).get().then((snapshots) => {
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

                return sendNotification(msgData, tokens, dateMonthYear, hourMinute, hourMinute2);
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

function saveHistory(userId, titles, details, dateMonthYear, hourMinute) {
    console.log('enter saveHistory');

    const ref = firestore.collection("history").doc(userId).collection(dateMonthYear);

    const newData = {
        title: titles,
        detail: details,
        time: hourMinute
    }

    return ref.add(newData).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}

async function sendNotification(data, tokens, dateMonthYear, hourMinute, hourMinute2) {
    const filePath = 'image.png';
    const contentType = 'image/png';
    const fileName = path.basename(filePath);

    const bucket = admin.storage().bucket('btec-e4bef.appspot.com');
    const tempFilePath = path.join(os.tmpdir(), fileName);
    const metadata = {
        contentType: contentType,
    };
    await bucket.file(filePath).download({ destination: tempFilePath });
    console.log('Image downloaded locally to', tempFilePath);
    // Generate a thumbnail using ImageMagick.
    await spawn('convert', [tempFilePath, '-thumbnail', '200x200>', tempFilePath]);
    console.log('Thumbnail created at', tempFilePath);
    // We rename thumbnails file name. That's where we'll upload the thumbnail.
    const thumbFileName = `${data.uid}_${dateMonthYear}_${hourMinute2}`;
    const thumbFilePath = path.join(path.dirname(filePath), thumbFileName);
    // Uploading the thumbnail.

    return bucket.upload(tempFilePath, {
        destination: thumbFilePath,
        metadata: metadata,
        predefinedAcl: 'publicRead'
    }).then(result => {
        const file = result[0];
        return file.getMetadata();
    }).then(results => {
        const metadata = results[0];
        console.log('metadata=', metadata.mediaLink);
        console.log('hourMinute ', hourMinute);
        var payload = {
            notification: {
                title: 'Status : ' + data.status,
                body: 'An unknown person attempts to enter your office',
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'title': 'Status : ' + data.status,
                'url': metadata.mediaLink,
                'time': hourMinute,
                'date': dateMonthYear,
                'state': data.state,
                'address': data.address,
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
    }).then((_) => {
        console.log('fs.unlinkSync(tempFilePath)')
        // Once the thumbnail has been uploaded delete the local file to free up disk space.
        return fs.unlinkSync(tempFilePath);
    }).catch(error => {
        console.error(error);
    });
}

exports.sendSms = functions.https.onRequest((req, res) => {
    var state = req.body.state;
    var address = req.body.address;
    console.log(state + ' ' + address);
    return client.messages.create({
        body: 'POLIS' + state.toUpperCase() + ' CEROBOH DI ' + address.toUpperCase(),
        to: '+60147437314',
        from: '+13057713601'
    }).then((_) => console.log('Successfuly send sms'))
        .catch(err => {
            console.log('Error getting document', err);
        });
});

exports.addDetailsEvent = functions.https.onRequest(async (request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return updateHistory(request.body).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

async function updateHistory(data) {
    console.log('enter saveFirestore');

    const col = firestore.collection("history").doc(data.uid).collection(data.date)
    const query = col.where("time", "==", data.time);

    return query.get()
        .then(snapshot => {
            console.log('enter snapshot, length = ', snapshot.docs.length);
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                var newData = {
                    title: 'Update : ' + data.title,
                    detail: data.detail,
                    time: data.time
                }
                return col.doc(doc.id).update(newData);
            });
        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
}

exports.ratingTrigger = functions.firestore.document('employee/{uid}/{branch}/{docId}').onWrite((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    console.log(previousValue.ratingDetail);
    console.log(newValue.ratingDetail);
    console.log(previousValue.name);

    var isEq = isEqual(previousValue.ratingDetail, newValue.ratingDetail);

    if (isEq == true) {
        console.log('Nothing change');
    }
    else if (isEq == false) {
        console.log('Something change');
        console.log(change.after.ref);

        var newData = newValue.ratingDetail.length;
        console.log('newData : ', newData);

        return change.after.ref.set({
            rating: newData
        }, { merge: true })
            .then(val => console.log('Successfully update rating : ', val))
            .catch(e => console.log('Error : ', e));
    }
    console.log('done');
    return null;
});

var isEqual = function (value, other) {

    // Get the value type
    var type = Object.prototype.toString.call(value);

    // If the two objects are not the same type, return false
    if (type !== Object.prototype.toString.call(other)) return false;

    // If items are not an object or array, return false
    if (['[object Array]', '[object Object]'].indexOf(type) < 0) return false;

    // Compare the length of the length of the two items
    var valueLen = type === '[object Array]' ? value.length : Object.keys(value).length;
    var otherLen = type === '[object Array]' ? other.length : Object.keys(other).length;
    if (valueLen !== otherLen) return false;

    // Compare two items
    var compare = function (item1, item2) {

        // Get the object type
        var itemType = Object.prototype.toString.call(item1);

        // If an object or array, compare recursively
        if (['[object Array]', '[object Object]'].indexOf(itemType) >= 0) {
            if (!isEqual(item1, item2)) return false;
        }

        // Otherwise, do a simple comparison
        else {

            // If the two items are not the same type, return false
            if (itemType !== Object.prototype.toString.call(item2)) return false;

            // Else if it's a function, convert to a string and compare
            // Otherwise, just compare
            if (itemType === '[object Function]') {
                if (item1.toString() !== item2.toString()) return false;
            } else {
                if (item1 !== item2) return false;
            }

        }
    };

    // Compare properties
    if (type === '[object Array]') {
        for (var i = 0; i < valueLen; i++) {
            if (compare(value[i], other[i]) === false) return false;
        }
    } else {
        for (var key in value) {
            if (value.hasOwnProperty(key)) {
                if (compare(value[key], other[key]) === false) return false;
            }
        }
    }

    // If nothing failed, return true
    return true;

};

exports.getTotalEmployee = functions.https.onRequest((request, response) => {
    const userId = request.path;

    firestore.collection('employee').doc(userId).get().then(result => {
        if (result.data() == null) {
            console.log('Null')
        }
        console.log('successful! : ' + result.data())
        return response.send(result.data());
    }).catch(error => {
        response.send(error);
    });
});

exports.addEmployee = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return addProfile(request.body).then(() => {
        console.log('Save to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

async function addProfile(data) {
    console.log('enter saveFirestore');
    const ref = firestore.collection("employee").doc(data.uid);
    var totalEmployees;
    await ref.get().then((snapshot) => {
        totalEmployees = snapshot.data()['totalEmployee'] + 1;
        return ref.set({ totalEmployee: totalEmployees }, { merge: true }).then(() => {
            console.log('Update to Firestore');
        }).catch((err) => {
            console.log('Error : ' + err);
        });
    })

    const refBranch = ref.collection(data.branch);
    await refBranch.where('name', '==', 'null').get().then(snapshot => {
        console.log('enter snapshot');
        snapshot.forEach(doc => {
            console.log(doc.id);
            console.log(doc.id, '=>', doc.data());
            refBranch.doc(doc.id).delete();
        });
    }).catch(err => {
        console.log('Error getting documents', err);
    });
    const newData = {
        profileUrl: data.profileUrl,
        name: data.name,
        level: data.level,
        attendance: 0,
        rating: 0,
        salary: parseInt(data.salary),
    }

    return refBranch.add(newData);
}

exports.editEmployee = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return editProfile(request.body).then(() => {
        console.log('Save to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

function editProfile(data) {
    console.log('enter saveFirestore');
    console.log('Salary : ', data.salary)
    var salary = parseInt(data.salary);
    console.log('Salary : ', salary)
    const col = firestore.collection("employee").doc(data.uid).collection(data.branch)
    const query = col.where("name", "==", data.name);

    const newData = {
        profileUrl: data.profileUrl,
        name: data.name,
        level: data.level,
        salary: salary,
    }

    return query.get()
        .then(snapshot => {
            console.log('enter snapshot');
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                col.doc(doc.id).update(newData);
            });
        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
}

exports.deleteEmployee = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return deleteProfile(request.body).then(() => {
        console.log('Save to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

function deleteProfile(data) {
    console.log('enter saveFirestore');
    const col = firestore.collection("employee").doc(data.uid);
    const colBranch = firestore.collection("employee").doc(data.uid).collection(data.branch);
    const query = colBranch.where("name", "==", data.name);

    return query.get()
        .then(snapshot => {
            console.log('enter snapshot');
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                colBranch.doc(doc.id).delete();
            });

            return col.get().then((snapshots) => {
                var totalEmployees = snapshots.data()['totalEmployee'];
                var data = totalEmployees - 1;
                console.log(data);
                col.update({ totalEmployee: data }, { merge: true });
            });

        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
}

exports.ratingEmployee = functions.https.onRequest(async (request, response) => {
    const userId = request.body.uid;
    console.log(userId);
    var ref = firestore.collection('employee').doc(userId);
    var refQuery = ref.collection(request.body.branch).where("name", "==", request.body.name);
    // var ratingDetail;
    var docId;
    await refQuery.get()
        .then(snapshot => {
            console.log('enter snapshot');
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                // col.doc(doc.id).update(newData);
                docId = doc.id;
                return addRating(request.body, docId).catch((err) => console.log('Error : ' + err));
            });
        })
        .catch(err => {
            console.log('Error getting documents', err);
        });

    console.log('Value docId : ' + docId);

});

async function addRating(data, docId) {
    console.log('enter saveFirestore : ' + data.ratingDetail);
    console.log('enter saveFirestore : ' + docId);

    const ref = firestore.collection("employee").doc(data.uid).collection(data.branch).doc(docId);

    var ratingDetail;
    await ref.get()
        .then(doc => {
            if (!doc.exists) {
                console.log('No such document!');
            } else {
                console.log('Document data:', doc.data());
                ratingDetail = doc.data();
            }
        })
        .catch(err => {
            console.log('Error getting document', err);
        });
    var newRatingDetail = [];

    if (ratingDetail["ratingDetail"] == null) {
        console.log('No rating detail')
        newRatingDetail.push(data.ratingDetail);
        return ref.set({ ratingDetail: newRatingDetail }, { merge: true }).then(() => {
            console.log('Update to Firestore');
        }).catch((err) => {
            console.log('Error : ' + err);
        });
    } else if (ratingDetail["ratingDetail"] != null) {
        console.log('Has rating detail')
        await ratingDetail["ratingDetail"].push(data.ratingDetail);
        var newData = ratingDetail["ratingDetail"];
        return ref.update({ ratingDetail: newData }, { merge: true }).then(() => {
            console.log('Update to Firestore');
        }).catch((err) => {
            console.log('Error : ' + err);
        });
    }
}

// exports.getTodoCat = functions.https.onRequest((request, response) => {
//     const userId = request.path;

//     firestore.collection('todo').doc(userId).get().then(result => {
//         response.send(result.data());
//         console.log('successful! : ' + result.data())
//     }).catch(error => {
//         response.send(error);
//     });
// });

exports.deleteCat = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;

    const ref = firestore.collection('todo').doc(userId);

    return ref.get().then(result => {
        // response.send(result.data());
        var array = result.data()['collections'];
        console.log(array)
        var index = array.indexOf(request.body.branch);
        if (index > -1) {
            array.splice(index, 1);
        }


        ////
        // function deleteCollection(db, collectionPath, batchSize) {
        //     var collectionRef = db.collection(collectionPath);
        //     var query = collectionRef.orderBy('__name__').limit(batchSize);

        //     return new Promise((resolve, reject) => {
        //         deleteQueryBatch(db, query, batchSize, resolve, reject);
        //     });
        // }

        // function deleteQueryBatch(db, query, batchSize, resolve, reject) {
        //     query.get()
        //         .then((snapshot) => {
        //             // When there are no documents left, we are done
        //             if (snapshot.size == 0) {
        //                 return 0;
        //             }

        //             // Delete documents in a batch
        //             var batch = db.batch();
        //             snapshot.docs.forEach((doc) => {
        //                 batch.delete(doc.ref);
        //             });

        //             return batch.commit().then(() => {
        //                 return snapshot.size;
        //             });
        //         }).then((numDeleted) => {
        //             if (numDeleted === 0) {
        //                 resolve();
        //                 return;
        //             }

        //             // Recurse on the next process tick, to avoid
        //             // exploding the stack.
        //             process.nextTick(() => {
        //                 deleteQueryBatch(db, query, batchSize, resolve, reject);
        //             });
        //         })
        //         .catch(reject);
        // }
        ////
        console.log(array);

        return ref.update({ collections: array }).then((results) => console.log('successful! : ' + results.data()['collections'])).catch((e) => console.log('Error ', e));
    }).catch(error => {
        response.send(error);
    });
});

exports.getTaskToday = functions.https.onRequest(async (request, response) => {
    const userId = request.headers.uid;
    const dateToday = request.headers.date;
    console.log(userId);
    console.log(dateToday);
    return firestore.collection('todo').where('uid', '==', userId).get().then(async (data) => {
        console.log(data);
        if (!data.empty) {
            const todoRef = firestore.collection('todo').doc(userId);

            var cols;
            var total = 0;
            var resultCol = await todoRef.get();
            cols = resultCol.data();
            var colLength = cols['collections'].length;

            console.log('successful! : ' + colLength);

            var array = cols['collections'];

            const start = async () => {
                await asyncForEach(array, async (element) => {
                    const queryDateToday = todoRef.collection(element).where("date", "==", dateToday);
                    var snapshot = await queryDateToday.get();
                    total = await total + snapshot.docs.length;
                    console.log('total after ', total);
                });
                console.log('Done ', total);
                const newData = {
                    taskToday: total
                }
                response.send(newData);
            }
            return start();
        } else {
            const newData = {
                taskToday: 0
            }
            response.send(newData);
        }
    });
});

async function asyncForEach(array, callback) {
    for (let index = 0; index < array.length; index++) {
        await callback(array[index], index, array);
    }
}

exports.addTask = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return addTodo(request.body).then(() => {
        console.log('Save to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

async function addTodo(data) {
    console.log('enter saveFirestore');

    const ref = firestore.collection("todo").doc(data.uid).collection(data.todoCat);

    await ref.where('title', '==', 'null').get().then(snapshot => {
        console.log('enter snapshot');
        snapshot.forEach(doc => {
            console.log(doc.id);
            console.log(doc.id, '=>', doc.data());
            ref.doc(doc.id).delete();
        });
    }).catch(err => {
        console.log('Error getting documents', err);
    });

    const newData = {
        title: data.title,
        detail: data.detail,
        date: data.date,
        complete: false
    }

    return ref.add(newData);
}

exports.editTask = functions.https.onRequest((request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return editTodo(request.body).then(() => {
        console.log('Save to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

function editTodo(data) {
    console.log('enter saveFirestore');

    const col = firestore.collection("todo").doc(data.uid).collection(data.todoCat)
    const query = col.where("title", "==", data.title).where("date", "==", data.date);

    const newData = {
        title: data.title,
        detail: data.detail,
        date: data.date,
        complete: false
    }

    return query.get()
        .then(snapshot => {
            console.log('enter snapshot');
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                col.doc(doc.id).update(newData);
            });
        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
}

exports.doneTask = functions.https.onRequest(async (request, response) => {
    const userId = request.body.uid;
    console.log(userId);

    return doneTodo(request.body).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
});

function doneTodo(data) {
    console.log('enter saveFirestore');
    console.log(data.todoCat);
    console.log(data.title);

    const col = firestore.collection("todo").doc(data.uid).collection(data.todoCat)
    const query = col.where("title", "==", data.title).where("date", "==", data.date);

    return query.get()
        .then(snapshot => {
            console.log('enter snapshot');
            snapshot.forEach(doc => {
                console.log(doc.id);
                console.log(doc.id, '=>', doc.data());
                if (data.complete == 'true') {
                    col.doc(doc.id).update({ complete: true });
                } else if (data.complete == 'false') {
                    col.doc(doc.id).update({ complete: false });
                }
            });
        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
}

exports.addBranch = functions.https.onRequest(async (request, response) => {
    const userId = request.body.uid;
    console.log(userId);
    var ref = firestore.collection('employee').doc(userId);
    var collections;
    return ref.get()
        .then(doc => {
            if (!doc.exists) {
                console.log('No such document!');
                return ref.set({ branch: [request.body.branch], uid: userId, totalEmployee: 0 }).then(() => {
                    var newData = {
                        name: 'null',
                        rating: 0,
                        attendance: 0,
                        id: 'null',
                        level: 'null',
                        ratingDetail: [],
                        salary: 0
                    }
                    return ref.collection(request.body.branch).add(newData);
                })
            } else {
                console.log('Document data:', doc.data());
                collections = doc.data();
                var insideCol = collections["branch"];
                console.log('Value collections : ' + insideCol[0]);
                return addBranchEmployee(request.body, collections).catch((err) => console.log('Error : ' + err));
            }
        })
        .catch(err => {
            console.log('Error getting document', err);
        });
});

async function addBranchEmployee(data, collections) {
    console.log('enter saveFirestore : ' + data.branch);

    const ref = firestore.collection("employee").doc(data.uid);


    await collections["branch"].push(data.branch);
    var newData = collections["branch"];

    return ref.update({ branch: newData }, { merge: true }).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}

exports.addCat = functions.https.onRequest(async (request, response) => {
    const userId = request.body.uid;
    console.log(userId);
    var ref = firestore.collection('todo').doc(userId);
    var collections;
    await ref.get()
        .then(doc => {
            if (!doc.exists) {
                console.log('No such document!');
                return ref.set({ collections: [request.body.todoCat], uid: userId }).then(() => {
                    var newData = {
                        complete: false,
                        date: 'null',
                        detail: 'null',
                        title: 'null'
                    }
                    return ref.collection(request.body.todoCat).add(newData);
                })
            } else {
                console.log('Document data:', doc.data());
                collections = doc.data();
            }
        })
        .catch(err => {
            console.log('Error getting document', err);
        });
    var insideCol = collections["collections"];
    console.log('Value collections : ' + insideCol[0]);
    return addTodoCat(request.body, collections).catch((err) => console.log('Error : ' + err));
});

async function addTodoCat(data, collections) {
    console.log('enter saveFirestore : ' + data.todoCat);

    const ref = firestore.collection("todo").doc(data.uid);


    await collections["collections"].push(data.todoCat);
    var newData = collections["collections"];

    return ref.update({ collections: newData }, { merge: true }).then(() => {
        console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}




