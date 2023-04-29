const fs = require("fs-extra");



const generate = async () => {
for(let i = 0; i < 10; i++){
    const tokenId = i+1

    const metadata = {
        "name": `Azuki #${tokenId}`,
        "image": `ipfs://QmYDvPAXtiJg7s8JdRBSLWdgSphQdac8j1YuQNNxcGE1hg/${tokenId}.png`,
        "attributes": [
          {
            "trait_type": "Type",
            "value": "Human"
          }
        ]
      }

    fs.writeFileSync(`metadata/json/${tokenId}`,JSON.stringify(metadata) )
    console.log(tokenId)
    // console.log(JSON.stringify(metadata))
}
    
}

generate();