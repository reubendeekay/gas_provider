const admin = require("firebase-admin");
const functions = require("firebase-functions");

// User IDs to be deleted
const UIDs = [];

// initialize the app
admin.initializeApp();

exports.deleteUser = functions.https.onRequest(async (req, res) => {
  // get the user ID from the request
  const uid = req.body.uid;
  try {
    await admin
      .auth()
      .deleteUser(uid)
      .catch(function (error) {
        console.log("Error deleting user", uid, error);
      });

    await admin.firestore().collection("users").doc(uid).delete();
  } catch (error) {
    console.log("Error deleting user", uid, error);
  }

  res.send("User deleted");
});

//Delete a user on delete from users collection's document
exports.deleteUserOnDelete = functions.firestore
  .document("users/{uid}")
  .onDelete(async (snap, context) => {
    const uid = context.params.uid;
    try {
      await admin
        .auth()
        .deleteUser(uid)
        .catch(function (error) {
          console.log("Error deleting user", uid, error);
        });
    } catch (error) {
      console.log("Error deleting user", uid, error);
    }
    return null;
  });

// Send a message to the device whenever a new message is written to the Realtime Database
exports.sendNotification = functions.firestore
  .document("userData/{userId}/notifications/{notificationId}")
  .onCreate(async (snap, context) => {
    const notData = snap.data();
    const payload = {
      notification: {
        title: notData.type + " request notification",
        body: notData.mesage,
        icon: notData.imageUrl,
      },
    };
    const options = {
      priority: "high",
      timeToLive: 60 * 60 * 24,
    };
    return admin.messaging().sendToTopic("chat", payload, options);
  });
