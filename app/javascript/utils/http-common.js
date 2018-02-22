import axios from 'axios'

function getCsrfToken() {
  var metas = document.getElementsByTagName('meta');

  for (var i=0; i<metas.length; i++) {
    if (metas[i].getAttribute("name") == "csrf-token") {
      return metas[i].getAttribute("content");
    }
  }
  return "";
}

export const HTTP = axios.create({
  baseURL: `http://localhost:3000/`,
  headers: {
    "X-CSRF-Token": getCsrfToken()
  }
})
