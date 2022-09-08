importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCtqduJMigNCqWRIqjBaTubhSn8w4BONOU",
    authDomain: "apphrd.firebaseapp.com",
    databaseURL: "https://apphrd-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "apphrd",
    storageBucket: "apphrd.appspot.com",
    messagingSenderId: "659778191979",
    appId: "1:659778191979:web:850a2dacbd9ecf29ba272e",
    measurementId: "G-0YLVJ8GDW6"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});