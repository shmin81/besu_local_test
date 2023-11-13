const fs = require('fs')

const ERROR = (msg) => console.error(`${new Date().toISOString()} [ERROR] ${msg}`)
const rootConfigDir = '../'
const defaultConfigDir = '../configs/'
let confPath = null
let confContent = null
//let conf = null;
exports.loadConf = function (_confPath) {
  //console.log('loadConf', _confPath)
  confPath = checkPath(_confPath)
  let conf = getConfig(confPath, false)

  // check data
  if (conf.accountfile == undefined) {
    //console.log('retry', conf)
    confPath = checkPath(conf)
    conf = getConfig(confPath)
  }

  if (conf.ownerPrivKey.startsWith('0x')) {
    conf.ownerPrivKey = conf.ownerPrivKey.substring(2)
  }

  if (conf.jwt != undefined && conf.jwt.length > 30) {
    conf.httpheaders = { 'Content-Type': 'application/json', Authorization: 'Bearer ' + conf.jwt }
  } else {
    conf.httpheaders = { 'Content-Type': 'application/json' }
  }

  return conf
}

exports.getweb3HttpHeader = function (conf) {
  const httpOptions = {
    headers: [{ name: 'Content-Type', value: 'application/json' }],
  }
  if (conf.jwt != undefined && conf.jwt.length > 30) {
    httpOptions.headers.push({ name: 'Authorization', value: 'Bearer ' + jwt_token })
  }
  return httpOptions
}

function checkPath(_confPath) {
  //console.log('checkPath', _confPath)
  if (fs.existsSync(_confPath)) {
    return _confPath
  }
  if (!_confPath.startsWith(rootConfigDir)) {
    if (fs.existsSync(rootConfigDir + _confPath)) {
      return rootConfigDir + _confPath
    }
    if (fs.existsSync(defaultConfigDir + _confPath)) {
      return defaultConfigDir + _confPath
    }
  }
  if (!_confPath.toString().toLowerCase().endsWith('.json')) {
    return checkPath(_confPath + '.json')
  }

  ERROR(`Not found: ${_confPath}`)
  process.exit(1)
}

function getConfig(path, strict = true) {
  //console.log('getConfig', path)
  confContent = fs.readFileSync(path, 'utf8')
  if (confContent.startsWith('{') || confContent.startsWith('[')) {
    return JSON.parse(confContent)
  } else {
    if (strict) {
      ERROR(`wrong file contents [${path}]`)
      process.exit(1)
    }
    return confContent
  }
}

exports.loadJson = function (path) {
  path = checkPath(path)
  const jsonContent = fs.readFileSync(path, 'utf8')
  return JSON.parse(jsonContent)
}

exports.sleep = function (ms) {
  const wakeUpTime = Date.now() + ms
  while (Date.now() < wakeUpTime) {}
}

const { Address } = require('ethereumjs-util')
exports.convertPrivKeyToAccount = function (privkey) {
  if (privkey.indexOf('0x') == 0) {
    privkey = privkey.substring(2)
  }
  let privKeyBuf = Buffer.from(privkey, 'hex')
  let addressBuf = Address.fromPrivateKey(privKeyBuf)
  let address = addressBuf.toString('hex')
  return {
    address,
    privKeyBuf,
    privateKey: `0x${privkey}`,
  }
}

exports.deployNewErc20Contract = function (contractAddress, transactionHash = null) {
  const confObj = JSON.parse(confContent)
  confObj.erc20Address = contractAddress
  let outStr = JSON.stringify(confObj, null, 2)
  fs.writeFileSync(confPath, outStr)
  // log ??
}

const _request = {
  method: 'POST',
  uri: null,
  json: true,
  headers: { 'Content-Type': 'application/json' },
  resolveWithFullResponse: true,
  timeout: 5000,
  body: [],
}
// http header에 JWT 인증 추가는 개발 필요함.
exports.getPostRequest = function (_url, _method, _params = [], _id = 1) {
  _request.uri = _url
  _request.body = {
    jsonrpc: '2.0',
    method: _method,
    params: _params,
    id: _id,
  }
  return _request
}

const httpRequest = require('request-promise')
exports.sendHttp = function (req) {
  return new Promise(function (resolve, reject) {
    httpRequest
      .post(req)
      .then((response) => {
        //if (response.body.result !== undefined && typeof response.body.result === 'string' && response.body.result.startsWith('0x')) {
        if (response.body.error == undefined && response.body.result !== undefined) {
          resolve(response.body.result)
        } else {
          console.error(req.body.method, response.body)
          //reject(response.body)
        }
      })
      .catch((err) => {
        console.error(req.body.method, 'error')
        console.error(err)
        //reject(err)
      })
  })
}

exports.httpGetTxReceipt = function (_url, _txid) {
  const _body = {
    jsonrpc: '2.0',
    method: 'eth_getTransactionReceipt',
    params: [_txid],
    id: 4586,
  }

  _request.uri = _url
  _request.body = _body

  return new Promise(function (resolve, reject) {
    // resolve(retryTest(_request))
    retryResponse(_request, _txid, resolve, reject)
  })
}

const interval = 500
const chkMaxCount = 120
let retryResponse = function (req, txid, res, rej) {
  let tryCnt = 0
  //console.log('*** retryResponse')
  let timerId = setInterval(function () {
    // console.log('*** sendhttpx', tryCnt)
    sendHttpSync(req).then((receipt) => {
      // console.log('*** response', receipt)
      if (receipt == null) {
        if (tryCnt++ >= chkMaxCount) {
          clearTimeout(timerId)
          rej(`failed by time out (not found tx receipt - ${txid})`)
        }
      } else {
        clearTimeout(timerId)
        res(receipt)
      }
    })
  }, interval)
}

async function sendHttpSync(req) {
  return new Promise(function (resolve, reject) {
    httpRequest
      .post(req)
      .then((response) => {
        //if (response.body.result !== undefined && typeof response.body.result === 'string' && response.body.result.startsWith('0x')) {
        if (response.body.error == undefined && response.body.result !== undefined) {
          resolve(response.body.result)
        } else {
          reject(response.body)
        }
      })
      .catch((err) => {
        console.error(err)
      })
  })
}
