wrench = require "wrench"
fs = require "fs"
grunt = require "grunt"
require "shelljs/global"

module.exports = ->
    grunt.registerTask 'build_tree', 'Build files versions tree', ->
        dist = "dist/files/"
        versionsFile = "dist/versions.json"

        files = wrench.readdirSyncRecursive dist

        info = []
        files.forEach (filename) -> 
            stat = fs.lstatSync dist + filename
            return if stat.isDirectory()
            stat.gitHash = exec "git log -n 1 --pretty=format:%H -- #{dist}#{filename}",
                silent: true
            .output
            info.push
                filename: filename
                size: stat.size
                hash: stat.gitHash

        infoString = JSON.stringify info, null, 4

        console.log infoString