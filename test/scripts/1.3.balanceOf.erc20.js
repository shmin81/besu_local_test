const Web3Utils = require('web3-utils')

const utils = require('./utils')
const test = require('./test.erc20')

const LOG = (msg) => console.log(`[${new Date().toISOString()}] ${typeof msg === 'object' ? JSON.stringify(msg) : msg}`)

//=============================
const args = process.argv.slice(2)
if (args.length != 1) {
  console.log('node  1.3.balanceOf.erc20.js  (or configName)')
  process.exit(0)
}

let confPath = args[0]

let conf = null
let accountFrom = null
let accountConf = null
let response = null
async function init() {
  conf = utils.loadConf(confPath)
  LOG(JSON.stringify(conf))

  accountFrom = utils.convertPrivKeyToAccount(conf.ownerPrivKey)
  //LOG(`Owner: ${accountFrom.address}`)

  const endpointConf = utils.loadJson(conf.endpointfile)
  httpRpcUrl = endpointConf[0]
  LOG(`RPC: ${httpRpcUrl}`)

  accountConf = utils.loadJson(conf.accountfile)

  test.setTestEnv(httpRpcUrl, conf)
}

async function run() {
  const acountCnt = accountConf.length
  //LOG(`Account Set Count: ${acountCnt}`)
  response = await test.balanceOf(accountFrom.address)
  LOG(`Own ${accountFrom.address} => balance: ${response}`)

  for (let i = 0; i < acountCnt; i++) {
    const acc = accountConf[i]
    response = await test.balanceOf(acc.sender)
    LOG(`${i}-0 ${acc.sender} => balance: ${response}`)
    response = await test.balanceOf(acc.receiver)
    LOG(`${i}-1 ${acc.receiver} => balance: ${response}`)
  }
  LOG('done.')
}

init()
run()
