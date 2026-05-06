const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  dynamodb.scan({ TableName: process.env.AUTHORS_TABLE }, (err, data) => {
    const response = {
      statusCode: err ? 500 : 200,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      body: err ? JSON.stringify(err) : JSON.stringify(data.Items.map(i => ({ id: i.id.S, firstName: i.firstName.S, lastName: i.lastName.S })))
    };
    callback(null, response);
  });
};
