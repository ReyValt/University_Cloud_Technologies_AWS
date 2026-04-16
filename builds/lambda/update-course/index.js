const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });

exports.handler = (event, context, callback) => {
  const params = {
    Item: {
      "id": { S: event.id },
      "title": { S: event.title },
      "watchHref": { S: event.watchHref },
      "authorId": { S: event.authorId },
      "length": { S: event.length },
      "category": { S: event.category }
    },
    TableName: process.env.COURSES_TABLE
  };
  dynamodb.putItem(params, (err, data) => {
    if (err) return callback(err);
    callback(null, event);
  });
};
