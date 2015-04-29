wrench = require "wrench"
fs = require "fs"
grunt = require "grunt"

module.exports = ->
    grunt.registerTask 'build_tree', 'Build files versions tree', ->
        dist = "dist/"

        files = wrench.readdirSyncRecursive dist

        info = []
        files.forEach (filename) -> 
            stat = fs.lstatSync dist + filename
            return if stat.isDirectory()
            info.push
                filename: filename
                size: stat.size
                hash: ''

        console.log info