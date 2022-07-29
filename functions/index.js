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
      //Delete the user from the users collection
      await admin.firestore().collection("users").doc(uid).delete();
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

    //get push token from the user
    const user = await admin
      .firestore()
      .collection("users")
      .doc(notData.userId)
      .get();
    const token = user.data().pushToken;
    if (token) {
      return admin.messaging().sendToDevice(token, payload, options);
    }
  });

//Send a message to the device a product is less than 10 units in product collection's document
exports.sendNotificationOnProduct = functions.firestore
  .document("providers/{providerId}/products/{productId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (after.quantity < 20) {
      const payload = {
        notification: {
          title: "Product notification",
          body: after.name + " is depleting. Please procure more.",
          icon: before.imageUrl,
        },
      };
      const options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
      };
      //get push token from the user
      const user = await admin
        .firestore()
        .collection("users")
        .doc(after.ownerId)
        .get();
      const token = user.data().pushToken;
      if (token) {
        return admin.messaging().sendToDevice(token, payload, options);
      }
    }
  });

//Disable a user account on request
exports.disableUser = functions.https.onRequest(async (req, res) => {
  // get the user ID from the request
  const uid = req.body.uid;
  try {
    await admin
      .auth()
      .updateUser(uid, {
        disabled: true,
      })
      .catch(function (error) {
        console.log("Error disabling user", uid, error);
      });
  } catch (error) {
    console.log("Error disabling user", uid, error);
  }

  res.send("User disabled");
});
