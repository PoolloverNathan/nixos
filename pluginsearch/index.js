const { verify } = require("tweetnacl").sign.detached
const fetch$ = import("node-fetch")
const PUBLIC_KEY = "4d965c978584d2bbb27956047001b1a107f34fb67faf34d0a7066dc63f265ad0"
console.log("a")
require("http").createServer(async (req, res) => {
  console.log("incoming")
  const chunks = []
  for await (const chunk of req) chunks.push(chunk)
  if (!chunks.length) {
    res.writeHead(204)
    res.end()
    return
  }
  let data = Buffer.concat(chunks).toString("utf-8")
  if (!req.headers["x-signature-bypass"]) {
    const signature = req.headers["x-signature-ed25519"];
    const timestamp = req.headers["x-signature-timestamp"];
    const isVerified = signature && timestamp && verify(
      Buffer.from(timestamp + data),
      Buffer.from(signature, "hex"),
      Buffer.from(PUBLIC_KEY, "hex")
    )
    if (!isVerified) {
      res.writeHead(401)
      res.end("invalid request signature")
      return
    }
  }
  try {
    data = JSON.parse(data)
  } catch (e) {
    res.writeHead(400)
    res.end(e.message)
    return
  }
  try {
    const out = await handle(data)
    if (out) {
      const json = JSON.stringify(out, null, 2)
      res.writeHead(200, { "Content-Type": "application/json" })
      res.end(json)
    } else {
      res.writeHead(204)
      res.end()
    }
  } catch (e) {
    console.error(e.stack)
    res.writeHead(500)
    res.end(e.stack)
  }
}).listen(22942, () => {
  console.log("b")
})

const plugins$ = fetch$
  .then(({ fetch }) => fetch("https://raw.githubusercontent.com/Vencord/builds/main/plugins.json"))
  .then(resp => resp.statusCode == 200 ? resp.json() : Promise.reject(`unexpected status code ${resp.statusCode}`))
const cachedPlugins$ = plugins$.then(data => Object.fromEntries(data.map(p => [p.name, p])))

async function handle(data) {
  const { type, token } = data
  switch (type) {
    case 1: {
      return { type: 1 }
    }
    case 2: {
      const { token, data: { options } } = data
      const { value } = options.find(o => o.name == "name")
      return {
        type: 4,
        data: {
          tts: false,
          content: "Hello, world!",
          embeds: [],
          allowed_mentions: { parse: [] },
        }
      }
    }
    case 4: {
      const { options } = data.data
      const { value } = options.find(o => o.name == "name")
      return {
        choices: (await plugins$).filter(p => p.name.includes(value)).map(p => { value: p.name })
      }
    }
    default: {
      console.log(data)
      throw new Error(`Unknown type received: ${type}`)
    }
  }
}
