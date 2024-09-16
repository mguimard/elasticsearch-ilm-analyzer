import got from 'got'
import ejs from 'ejs'
import fs from 'fs'

const ES_HOST = process.env.ES_HOST || 'http://localhost:9200'
const ES_USERNAME = process.env.ES_USERNAME
const ES_PASSWORD = process.env.ES_PASSWORD

let auth = {}

if (ES_USERNAME && ES_PASSWORD) {
    auth.username = ES_USERNAME
    auth.password = ES_PASSWORD
}

let paths = {
    index_settings: '/*/_settings?filter_path=*.settings.index.routing.allocation.include,*.settings.index.uuid,*.settings.index.provided_name',
    nodes_settings: '/_nodes/settings?filter_path=nodes.*.roles,nodes.*.name',
    shard_list: '/_cat/shards?format=json&h=index,node,state,prirep,docs'
}

const indices = await got(`${ES_HOST}${paths.index_settings}`, auth).json()
const nodes_data = await got(`${ES_HOST}${paths.nodes_settings}`, auth).json()
const shards = await got(`${ES_HOST}${paths.shard_list}`, auth).json()

const nodes = Object.values(nodes_data.nodes)

for (const node of nodes) {
    node.shards = shards.filter(s => s.node === node.name)
    for (const shard of node.shards) {
        if (indices[shard.index])
            shard.tier = indices[shard.index].settings.index.routing.allocation.include._tier_preference.split(',')
    }
}

function compareNodes(a, b) {
    const order = ['data_hot', 'data_warm', 'data_cold', 'data_content', 'data']

    for(const o of order){
        if(a.roles.indexOf(o) !== -1) {
            return -1
        }
        if(b.roles.indexOf(o) !== -1) {
            return 1
        }
    }
    
    return a.name > b.name ? -1 : 1
}
  
nodes.sort(compareNodes)

let report = await ejs.renderFile('report.tpl', {nodes})
await fs.promises.writeFile('report.html', report)
