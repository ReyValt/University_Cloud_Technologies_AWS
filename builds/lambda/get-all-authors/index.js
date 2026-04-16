const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  const params = { TableName: process.env.AUTHORS_TABLE };
  dynamodb.scan(params, (err, data) => {
    if (err) return callback(err);
    const authors = data.Items.map(item => ({ id: item.id.S, firstName: item.firstName.S, lastName: item.lastName.S }));
    callback(null, authors);
  });
};
