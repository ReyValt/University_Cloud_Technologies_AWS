const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  const params = { Key: { "id": { S: event.id } }, TableName: process.env.COURSES_TABLE };
  dynamodb.deleteItem(params, (err, data) => {
    if (err) return callback(err);
    callback(null, {});
  });
};
