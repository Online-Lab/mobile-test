wrench = require "wrench"
fs = require "fs"
grunt = require "grunt"
require "shelljs/global"

module.exports = ->
    grunt.registerTask 'build_tree', 'Build files versions tree', ->
        dist = "dist/"
        filesDir = "files/"
        versionsFile = "#{dist}/versions.json"

        files = wrench.readdirSyncRecursive "#{dist}#{filesDir}"

        info = []
        files.forEach (filename) -> 
            filePath = "#{dist}#{filesDir}#{filename}"
            stat = fs.lstatSync filePath
            return if stat.isDirectory()
            stat.gitHash = exec "git log -n 1 --pretty=format:%H -- #{filePath}",
                silent: true
            .output
            info.push
                filename: "#{filesDir}#{filename}"
                size: stat.size
                hash: stat.gitHash

        infoString = JSON.stringify info, null, 4
        fs.writeFileSync versionsFile, infoString