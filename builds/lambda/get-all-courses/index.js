const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: process.env.AWS_REGION });

exports.handler = (event, context, callback) => {
  const params = { TableName: process.env.COURSES_TABLE };
  dynamodb.scan(params, (err, data) => {
    if (err) return callback(err);
    const courses = data.Items.map(item => {
      return {
        id: (item.id && item.id.S) ? item.id.S : "unknown",
        title: (item.title && item.title.S) ? item.title.S : "No Title",
        watchHref: (item.watchHref && item.watchHref.S) ? item.watchHref.S : "",
        authorId: (item.authorId && item.authorId.S) ? item.authorId.S : "",
        length: (item.length && item.length.S) ? item.length.S : "",
        category: (item.category && item.category.S) ? item.category.S : ""
      };
    });
    callback(null, courses);
  });
};
