import * as functions from 'firebase-functions'
// import * as admin from 'firebase-admin'

// const serviceAccount = require("../serviceAccount.json")
// const storageBucket = "punchierthanananagram-47017.appspot.com"

// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount),
//     storageBucket
// })

export const getData = functions.https.onCall(async () => {
    return { data: "Hello world"}
})