const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function (app) {
    app.use(
        '/api', // Define the path you want to proxy
        createProxyMiddleware({
            target: 'https://q7q9rbu94k.execute-api.eu-north-1.amazonaws.com/dev/url', // Replace with your API server's address
            changeOrigin: true,
        })
    );
};