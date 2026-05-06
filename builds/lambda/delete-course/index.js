const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  const id = event.pathParameters.id;
  dynamodb.deleteItem({ TableName: process.env.COURSES_TABLE, Key: { id: { S: id } } }, (err) => {
    callback(null, {
      statusCode: err ? 500 : 200,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      body: JSON.stringify({ message: err ? "Error" : "Deleted" })
    });
  });
};
