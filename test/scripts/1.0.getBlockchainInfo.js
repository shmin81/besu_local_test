//const fs = require("fs");
//const { Address } = require('ethereumjs-util')
const Web3Utils = require('web3-utils')

const utils = require('./utils')
const test = require('./test.erc20')

const LOG = (msg) => console.log(`[${new Date().toISOString()}] ${typeof msg === 'object' ? JSON.stringify(msg) : msg}`)

//=============================
const args = process.argv.slice(2)
if (args.length < 1) {
  console.log('node  1.0.getBlockchainInfo.js  configPath(or configName)')
  console.log('  ex) node 1.0.getBlockchainInfo.js dev-local')
  process.exit(0)
}

let confPath = args[0]

let conf = null

async function init() {
  conf = utils.loadConf(confPath)
  LOG(JSON.stringify(conf))

  const endpointConf = utils.loadJson(conf.endpointfile)
  httpRpcUrl = endpointConf[0]
  LOG(`RPC: ${httpRpcUrl}`)

  test.setTestEnv(httpRpcUrl, conf)

  return new Promise(function (resolve, reject) {
    resolve(true)
  })
}

async function run() {
  // https://besu.hyperledger.org/en/21.10.9/Reference/API-Methods/

  let methodStr = 'web3_clientVersion'
  await runAPI(methodStr)

  methodStr = 'net_version'
  await runAPI_NumTo(methodStr)

  methodStr = 'eth_chainId'
  await runAPI_hexTo(methodStr)

  methodStr = 'eth_blockNumber'
  await runAPI_hexTo(methodStr)

  methodStr = 'eth_gasPrice'
  await runAPI(methodStr)

  LOG('done.')
}

async function runAPI(method, params = []) {
  let reqx = test.ethReq(method, params)
  let value = await utils.sendHttp(reqx)
  return new Promise(function (resolve, reject) {
    let res = `* ${method}: ${value}`
    LOG(res)
    resolve(res)
  })
}

async function runAPI_hexTo(method, params = []) {
  let reqx = test.ethReq(method, params)
  let value = await utils.sendHttp(reqx)
  return new Promise(function (resolve, reject) {
    let res = `* ${method}: ${value} [${Web3Utils.hexToNumberString(value)}]`
    LOG(res)
    resolve(res)
  })
}

async function runAPI_NumTo(method, params = []) {
  let reqx = test.ethReq(method, params)
  let value = await utils.sendHttp(reqx)
  return new Promise(function (resolve, reject) {
    let res = `* ${method}: ${value} [${Web3Utils.numberToHex(value)}]`
    LOG(res)
    resolve(res)
  })
}

init().then(() => {
  return run()
})
