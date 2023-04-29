const {run} = require("hardhat")

const verify = async (_address, _args) => {
    try{
        await run("verify", {
            address: _address,
            constructorArgsParams: _args
        })
    }catch(e){
        console.error(e);
    }
}

module.exports = {
    verify
}