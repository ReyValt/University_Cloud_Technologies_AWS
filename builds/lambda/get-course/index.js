const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });
exports.handler = (event, context, callback) => {
  const params = { Key: { "id": { S: event.id } }, TableName: process.env.COURSES_TABLE };
  dynamodb.getItem(params, (err, data) => {
    if (err) return callback(err);
    if (!data.Item) return callback(null, {});
    const course = {
      id: data.Item.id.S,
      title: data.Item.title.S,
      watchHref: data.Item.watchHref.S,
      authorId: data.Item.authorId.S,
      length: data.Item.length.S,
      category: data.Item.category.S
    };
    callback(null, course);
  });
};
