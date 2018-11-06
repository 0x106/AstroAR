// Import the Firebase modules that you need in your app.
import firebase from 'firebase/app';
import 'firebase/database';

// Initalize and export Firebase.
const config = {
  apiKey: 'AIzaSyAZTszT9fG-r4EwoDuSJRfPibKzp8DR8g4',
  authDomain: 'mosaico-ar.firebaseapp.com',
  databaseURL: 'https://mosaico-ar.firebaseio.com',
  projectId: 'mosaico-ar',
  storageBucket: 'mosaico-ar.appspot.com',
  messagingSenderId: '909935930793'
};
export default firebase.initializeApp(config);
