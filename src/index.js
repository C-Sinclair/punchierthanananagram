import './styles/mvp.css'
import './styles/main.css';
import { Elm } from './App.elm';
import * as serviceWorker from './js/serviceWorker';

const storageKey = "pn_store"
const flags = localStorage.getItem(storageKey)

const app = Elm.App.init({
  node: document.getElementById('root'),
  flags
});

app.ports.storage.subscribe(value => {
  if (value === null) {
    localStorage.removeItem(storageKey)
  } else {
    localStorage.setItem(storageKey, JSON.stringify(value))
  }
  // report success
  app.ports.onStorageChange(value)
})

// listen for external storage changes
window.addEventListener("storage", event => {
  const { storageArea, key, newValue } = event
  if (storageArea === localStorage && key === storageKey) {
    app.ports.onStorageChange.send(newValue)
  }
}, false)

serviceWorker.register();
