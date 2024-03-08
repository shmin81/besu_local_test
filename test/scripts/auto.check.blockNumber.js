const fs = require('fs')
const path = require('path')
const { Web3, HttpProvider } = require('web3')
const utils = require('./utils')

const LOG = (msg) => console.log(`[${new Date().toISOString()}] ${typeof msg === 'object' ? JSON.stringify(msg) : msg}`)

const args = process.argv.slice(2)
if (args.length != 2) {
  console.log('node  auto.check.blockNumber.js  configName(dev-local)  maxBlockNumber(number)')
  process.exit(0)
}

let confPath = args[0]
let maxNumber = BigInt(parseInt(args[1]))

let conf = null
let web3 = null

async function init() {
  conf = utils.loadConf(confPath)
  LOG(JSON.stringify(conf))

  const endpointConf = utils.loadJson(conf.endpointfile)
  httpRpcUrl = endpointConf[0]
  LOG(`RPC: ${httpRpcUrl}`)

  //let httpProvider = new Web3.providers.HttpProvider(httpRpcUrl, utils.getweb3HttpHeader(conf));
  let httpProvider = new HttpProvider(httpRpcUrl)
  web3 = new Web3(httpProvider)

  showed = await web3.eth.getBlockNumber()
  LOG(`web3.eth.getBlockNumber() => ${showed}`)
  sTime = (new Date()).getTime() - 500
}

let showed = 0
let sTime = 0
let fblock = 0n
async function run() {
  let timerId = setInterval(function () {

    web3.eth.getBlockNumber().then((blockNumber) => {
      if (blockNumber >= maxNumber) {
        LOG(`stop - ${blockNumber}`)
        clearTimeout(timerId)
        return
      }
      if (showed != blockNumber && blockNumber % 10n == 0) {
        let now = new Date()
        let tOffset = (now).getTime() - sTime
        let bOffset = blockNumber - fblock
        if (fblock == 0) { // init 함수에서 처음 확인한 블럭은 시간이 정확하지 않기 떄문에
          bOffset -= showed
          fblock = blockNumber
          sTime = now.getTime()
        }
        showed = blockNumber
        let interval = BigInt(tOffset) / bOffset / 1000n
        //console.log(tOffset, bOffset, interval)
        let remained = (maxNumber - blockNumber) * interval
        LOG(` * blockNumber ${blockNumber} / ${maxNumber} ... ${remained} s [${remained/60n} m] remained.`)
      }
    })
  }, 1000)
}

init()
run()
