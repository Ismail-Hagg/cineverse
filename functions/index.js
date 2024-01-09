const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const fcm = admin.messaging();
const db = admin.firestore();

exports.targetMessage = functions.https.onCall(async (data, context) => {
  const { token, body, image, title, action } = data;
  try {
    const message = {
      token: token,
      notification: {
        title: title,
        body: body,
        image: image,
      },
      android: {
        notification: {
          channel_id: "101",
        },
      },
      data: {
        body: body,
        action: action,
      },
    };

    return fcm
      .send(message)
      .then((response) => {
        return { success: true, response: "Success" + response };
      })
      .catch((error) => {
        return { error: error };
      });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "error" + error);
  }
});

exports.whenChanged = functions.firestore
  .document("/Users/{userId}/keeping/{showId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    await db
      .collection("Users")
      .doc(context["params"]["userId"])
      .get()
      .then(async (user) => {
        const lang = user.data()["language"];
        const messageToken = user.data()["messagingToken"];
        if (
          before["episode"] !== after["episode"] ||
          before["season"] !== after["season"]
        ) {
          const message = {
            token: messageToken,
            notification: {
              title: after["name"],
              body: lang === "en_US" ? "New Episode" : "حلقة جديدة",
              image: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
            },
            android: {
              notification: {
                channel_id: "101",
              },
            },
            data: {
              body: lang === "en_US" ? "New Episode" : "حلقة جديدة",
              action: JSON.stringify({
                type: "NotificationType.newEpisode",
                userId: "",
                movieId: `${after["id"]}`,
                movieOverView: after["overView"],
                posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                title: after["name"],
                isShow: "true",
                open: "false",
                notificationBody:
                  lang === "en_US" ? "New Episode" : "حلقة جديدة",
                userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                userName: after["name"],
                time: admin.firestore.Timestamp.now(),
              }),
            },
          };

          await db
            .collection("Users")
            .doc(context["params"]["userId"])
            .collection("notifications")
            .add({
              type: "NotificationType.newEpisode",
              userId: "",
              movieId: `${after["id"]}`,
              movieOverView: after["overView"],
              posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              title: after["name"],
              isShow: true,
              open: false,
              notificationBody: lang === "en_US" ? "New Episode" : "حلقة جديدة",
              userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              userName: after["name"],
              time: admin.firestore.Timestamp.now(),
            })
            .then(async (_) => {
              await fcm.send(message).catch((error) => {
                console.log("message wans not sent because => " + error);
              });
            })
            .catch((error) => {
              console.log("notification wans not added because => " + error);
            });
        } else if (before["status"] !== after["status"]) {
          const message = {
            token: messageToken,
            notification: {
              title: after["name"],
              body:
                lang === "en_US"
                  ? `Change in Status  ${
                      after["status"] === "Ended" ? "Ended" : "Returning Series"
                    }`
                  : `تغيير في حالة المسلسل : ${
                      after["status"] === "Ended" ? "منتهي" : "مستمر"
                    }`,
              image: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
            },
            android: {
              notification: {
                channel_id: "101",
              },
            },
            data: {
              body:
                lang === "en_US"
                  ? `Change in Status  ${
                      after["status"] === "Ended"
                        ? "Ended"
                        : "Returning Seeries"
                    }`
                  : `تغيير في حالة المسلسل : ${
                      after["status"] === "Ended" ? "منتهي" : "مستمر"
                    }`,
              action: JSON.stringify({
                type: "NotificationType.showEnded",
                userId: "",
                movieId: `${after["id"]}`,
                movieOverView: after["overView"],
                posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                title: after["name"],
                isShow: "true",
                open: "false",
                notificationBody:
                  lang === "en_US"
                    ? `Change in Status  ${
                        after["status"] === "Ended"
                          ? "Ended"
                          : "Returning Seeries"
                      }`
                    : `تغيير في حالة المسلسل : ${
                        after["status"] === "Ended" ? "منتهي" : "مستمر"
                      }`,
                userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                userName: after["name"],
                time: admin.firestore.Timestamp.now(),
              }),
            },
          };

          await db
            .collection("Users")
            .doc(context["params"]["userId"])
            .collection("notifications")
            .add({
              type: "NotificationType.showEnded",
              userId: "",
              movieId: `${after["id"]}`,
              movieOverView: after["overView"],
              posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              title: after["name"],
              isShow: true,
              open: false,
              notificationBody:
                lang === "en_US"
                  ? `Change in Status  ${
                      after["status"] === "Ended"
                        ? "Ended"
                        : "Returning Seeries"
                    }`
                  : `تغيير في حالة المسلسل : ${
                      after["status"] === "Ended" ? "منتهي" : "مستمر"
                    }`,
              userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              userName: after["name"],
              time: admin.firestore.Timestamp.now(),
            })
            .then(async (_) => {
              await fcm.send(message).catch((error) => {
                console.log("message wans not sent because => " + error);
              });
            })
            .catch((error) => {
              console.log("notification wans not added because => " + error);
            });
        } else if (before["nextEpisodeDate"] !== after["nextEpisodeDate"]) {
          const message = {
            token: messageToken,
            notification: {
              title: after["name"],
              body:
                lang === "en_US"
                  ? `Next Episodee Release Date : ${after["nextEpisodeDate"]}`
                  : ` موعد الحلقة القادمة: ${after["nextEpisodeDate"]}`,
              image: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
            },
            android: {
              notification: {
                channel_id: "101",
              },
            },
            data: {
              body:
                lang === "en_US"
                  ? `Next Episodee Release Date : ${after["nextEpisodeDate"]}`
                  : ` موعد الحلقة القادمة: ${after["nextEpisodeDate"]}`,
              action: JSON.stringify({
                type: "NotificationType.releaseDate",
                userId: "",
                movieId: `${after["id"]}`,
                movieOverView: after["overView"],
                posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                title: after["name"],
                isShow: "true",
                open: "false",
                notificationBody:
                  lang === "en_US"
                    ? `Next Episodee Release Date : ${after["nextEpisodeDate"]}`
                    : ` موعد الحلقة القادمة: ${after["nextEpisodeDate"]}`,
                userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
                userName: after["name"],
                time: admin.firestore.Timestamp.now(),
              }),
            },
          };

          await db
            .collection("Users")
            .doc(context["params"]["userId"])
            .collection("notifications")
            .add({
              type: "NotificationType.releaseDate",
              userId: "",
              movieId: `${after["id"]}`,
              movieOverView: after["overView"],
              posterPath: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              title: after["name"],
              isShow: true,
              open: false,
              notificationBody:
                lang === "en_US"
                  ? `Next Episodee Release Date : ${after["nextEpisodeDate"]}`
                  : ` موعد الحلقة القادمة: ${after["nextEpisodeDate"]}`,
              userImage: `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${after["pic"]}`,
              userName: after["name"],
              time: admin.firestore.Timestamp.now(),
            })
            .then(async (_) => {
              await fcm.send(message).catch((error) => {
                console.log("message wans not sent because => " + error);
              });
            })
            .catch((error) => {
              console.log("notification wans not added because => " + error);
            });
        }
      })
      .catch((error) => {
        console.log("can not connect to user document because => " + error);
      });
  });

exports.updateKeeping = functions.pubsub
  .schedule("0 */2 * * *")
  .onRun(async (context) => {
    let nextEpisodeDate;
    let nextSeason;
    let nextEpisode;

    return db
      .collection("other")
      .get()
      .then((items) => {
        items.forEach((snap) => {
          const data = snap.data();
          if (typeof data["id"] !== "undefined") {
            const url = `https://api.themoviedb.org/3/tv/${data["id"]}?api_key=e11cff04b1fcf50079f6918e5199d691&language=en-US`;
            axios
              .get(url)
              .then(function (response) {
                const resData = response.data;
                const episode =
                  resData["last_episode_to_air"]["episode_number"];
                const season = resData["last_episode_to_air"]["season_number"];
                const status = resData["status"];
                const name = resData["name"];

                console.log("--------------------");
                console.log(name + " => " + data["name"]);
                console.log(status + " => " + data["status"]);
                console.log(data["status"] === status);

                if (resData["next_episode_to_air"] === null) {
                  nextEpisodeDate = "";
                  nextEpisode = 0;
                  nextSeason = 0;
                } else {
                  nextEpisodeDate = resData["next_episode_to_air"]["air_date"];
                  nextEpisode =
                    resData["next_episode_to_air"]["episode_number"];
                  nextSeason = resData["next_episode_to_air"]["season_number"];
                }

                if (
                  data["episode"] !== episode ||
                  data["nextEpisodeDate"] !== nextEpisodeDate ||
                  data["nextSeason"] !== nextSeason ||
                  data["nextepisode"] !== nextEpisode ||
                  data["season"] !== season ||
                  data["status"] !== status
                ) {
                  data["refList"].forEach((ref) => {
                    ref.update({
                      episode: episode,
                      nextEpisodeDate: nextEpisodeDate,
                      nextSeason: nextSeason,
                      nextepisode: nextEpisode,
                      season: season,
                      status: status,
                      isUpdated: true,
                      change: admin.firestore.Timestamp.now(),
                    });
                  });
                  snap.ref.update({
                    episode: episode,
                    nextEpisodeDate: nextEpisodeDate,
                    nextSeason: nextSeason,
                    nextepisode: nextEpisode,
                    season: season,
                    status: status,
                    isUpdated: true,
                    change: admin.firestore.Timestamp.now(),
                  });
                }
              })
              .catch(function (err) {
                console.log(err);
              });
          }
        });
      });
  });

exports.userChanging = functions.https.onCall(async (data, context) => {
  const { userName, link, local, userId, avatarType } = data;
  try {
    await db
      .collection("Users")
      .doc(userId)
      .update({
        avatarType: avatarType,
        localPicPath: local,
        onlinePicPath: link,
        userName: userName,
      })
      .then(async (response) => {
        await db
          .collection("Users")
          .doc(userId)
          .collection("comments")
          .get()
          .then((items) => {
            if (items.empty === false) {
              items.forEach(async (snap) => {
                const comment = snap.data();
                const movieId = comment["movieId"];
                const commentId = comment["commentId"];
                const ref = db
                  .collection("other")
                  .doc(movieId)
                  .collection("comments")
                  .doc(commentId);
                await ref
                  .update({
                    userLink: link,
                    userName: userName,
                  })
                  .then((res) => {
                    ref.get().then(async (docu) => {
                      if (docu.data()["hasMore"] === true) {
                        await ref
                          .collection("replies")
                          .get()
                          .then((reps) => {
                            reps.forEach(async (rep) => {
                              const oneRep = rep.data();
                              const repId = oneRep["userId"];
                              if (repId === userId) {
                                await ref
                                  .collection("replies")
                                  .doc(oneRep["commentId"])
                                  .update({
                                    userLink: link,
                                    userName: userName,
                                  });
                              }
                            });
                          });
                      }
                    });
                  });
              });
            }
          });
      })
      .then(async (_) => {
        await db
          .collection("Users")
          .doc(userId)
          .collection("chat")
          .get()
          .then((items) => {
            if (items.empty === false) {
              items.forEach(async (item) => {
                const chatData = item.data();
                const ref = chatData["ref"];
                await ref.update({
                  onlinePath: link,
                  userNsme: userName,
                });
              });
            }
          });
      });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "error" + error);
  }
});
