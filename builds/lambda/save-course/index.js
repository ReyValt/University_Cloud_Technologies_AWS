const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  const item = JSON.parse(event.body);
  const params = {
    TableName: process.env.COURSES_TABLE,
    Item: {
      id: { S: item.id },
      title: { S: item.title },
      watchHref: { S: item.watchHref },
      authorId: { S: item.authorId },
      length: { S: item.length },
      category: { S: item.category }
    }
  };
  dynamodb.putItem(params, (err) => {
    callback(null, {
      statusCode: err ? 500 : 201,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      body: err ? JSON.stringify(err) : JSON.stringify(item)
    });
  });
};
