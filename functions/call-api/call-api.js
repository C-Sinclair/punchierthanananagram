const axios = require("axios")

exports.handler = (event, context, callback) => {
  const { API_TOKEN, API_URL } = process.env
  console.log(`Injecting token into ${API_URL}`)
  return callback(null, {
    statusCode: 200,
    headers: {
      "content-type": "application/json; charset=UTF-8",
      "access-control-allow-origin": "*",
      "access-control-expose-headers": "content-encoding,date,server,content-length"
    },
    body: JSON.stringify({
      "api-token": API_TOKEN,
      "api-url": API_URL
    })
  })
}