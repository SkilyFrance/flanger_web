import 'newsapi';




const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const NewsAPI = require('newsapi');
const newsapi = new NewsAPI('41f01ac496d04712980b1d09c9c7d93a');

newsapi.v2.everything({
    domains: 'edm.com,djmag.com',
    from: '2021-04-19',
    to: '2021-04-26',
}).then(response => {
    console.log(response);
});


