const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
const replaceAll = (str, find, replace) => { return str.replace(new RegExp(find, 'g'), replace); };

exports.handler = (event, context, callback) => {
  const id = replaceAll(event.title.toLowerCase(), ' ', '-');
  const watchHref = "http://www.pluralsight.com/courses/" + id;
  const params = {
    Item: {
      "id": { S: id },
      "title": { S: event.title },
      "watchHref": { S: watchHref },
      "authorId": { S: event.authorId },
      "length": { S: event.length },
      "category": { S: event.category }
    },
    TableName: process.env.COURSES_TABLE
  };
  dynamodb.putItem(params, (err, data) => {
    if (err) return callback(err);
    callback(null, { id, title: event.title, watchHref, authorId: event.authorId, length: event.length, category: event.category });
  });
};
