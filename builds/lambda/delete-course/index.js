const { DynamoDBClient, DeleteItemCommand } = require("@aws-sdk/client-dynamodb");
const client = new DynamoDBClient({ region: process.env.AWS_REGION });
exports.handler = async (event) => {
  await client.send(new DeleteItemCommand({ TableName: process.env.COURSES_TABLE, Key: { id: { S: event.id } } }));
  return { message: "Deleted successfully" };
};
