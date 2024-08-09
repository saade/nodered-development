module.exports = {
    editorTheme: {
        projects: {
            enabled: true
        },
    },
    adminAuth: {
        type: "credentials",
        users: [
            {
                username: "nodered",
                // docker exec -it nodered-ew node-red-admin hash-pw
                password: "$2y$08$wuCnNUkVFtolBFJH9wCzZeSZV0PiCui7OMl9cpJqs.4h6zJvmwlka", // nodered
                permissions: "*"
            }
        ]
    },
    userDir: "/data",
};