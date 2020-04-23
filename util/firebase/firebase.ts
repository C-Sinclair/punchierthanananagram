import firebase from 'firebase/app'
import 'firebase/firestore';
import config from './config'

require("dotenv").config()

export default () => firebase.initializeApp(config)
