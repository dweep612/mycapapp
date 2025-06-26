module.exports = (srv) => {
    srv.on("test", (req, res) => {
        return "Hello " + req.data.input;
    })
}