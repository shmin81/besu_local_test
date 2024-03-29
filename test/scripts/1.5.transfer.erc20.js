// transfer accounts.sender to accounts.receiver
const Web3Utils = require('web3-utils')

const utils = require('./utils')
const test = require('./test.erc20')

const LOG = (msg) => console.log(`[${new Date().toISOString()}] ${typeof msg === 'object' ? JSON.stringify(msg) : msg}`)

//=============================
const value = 1000
//const abiPath = "../contracts/SimpleToken.abi"
//=============================
const args = process.argv.slice(2)
if (args.length < 1) {
  console.log('node  1.2.deposit.erc20.js  (or configName)  userIdx(default:0)')
  process.exit(0)
}

let confPath = args[0]
let userId = 0
if (args.length == 2) {
  userId = parseInt(args[1])
}

let conf = null
let accountFrom = null
let accountConf = null
let senderNonce = 0
let receiver = null
let request
let response

async function init() {
  conf = utils.loadConf(confPath)
  LOG(JSON.stringify(conf))

  const endpointConf = utils.loadJson(conf.endpointfile)
  httpRpcUrl = endpointConf[0]
  LOG(`RPC: ${httpRpcUrl}`)

  accountConf = utils.loadJson(conf.accountfile)
  const acountCnt = accountConf.length
  LOG(`* target account count: ${acountCnt}`)
  if (acountCnt <= userId) {
    LOG(`[ERROR] wrong userIdx`)
    process.exit(1)
  }

  accountFrom = utils.convertPrivKeyToAccount(accountConf[userId].privKey)
  LOG(`Sender: ${accountFrom.address} - ${accountConf[userId].name}`)
  receiver = accountConf[userId].receiver

  test.setTestEnv(httpRpcUrl, conf)
  request = test.ethReq('eth_chainId')
  response = await utils.sendHttp(request)
  let chainId = Web3Utils.hexToNumber(response)
  LOG(`ChainId: ${chainId} ${response}`)
  test.customChain(chainId)

  return new Promise(function (resolve, reject) {
    resolve(true)
  })
}

async function run() {
  request = test.ethReq('eth_getTransactionCount', [accountFrom.address, 'latest'])
  response = await utils.sendHttp(request)
  senderNonce = Web3Utils.hexToNumber(response)
  //LOG(`NONCE: ${senderNonce} ${response}`)

  let settedGas = await test.transferEstimateGas(accountFrom.address, receiver)
  LOG(`* token transfer Estimated Gas: ${settedGas}`)

  response = await test.balanceOf(accountFrom.address)
  LOG(`* token owner's balance: ${response}`)

  response = await test.balanceOf(receiver)
  LOG(`* token receiver's balance: ${response}`)

  request = test.transferReq(accountFrom.privKeyBuf, receiver, senderNonce, value)
  let txidResults = await utils.sendHttp(request)
  LOG(`txid: ${txidResults}`)
  let txResults = await utils.httpGetTxReceipt(httpRpcUrl, txidResults)
  LOG(`eth_getTransactionReceipt (${txidResults}) => ${JSON.stringify(txResults)}`)
  if (txResults.status != true) {
    LOG(`tx - Failed `)
    return
  }
  LOG(`tx - success [status:${txResults.status}]`)

  response = await test.balanceOf(accountFrom.address)
  LOG(`* token owner's balance: ${response}`)

  response = await test.balanceOf(receiver)
  LOG(`* token receiver's balance: ${response}`)

  LOG('done.')
}

init().then(() => {
  return run()
})
