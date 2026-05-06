const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    try {
        // Беремо ID з URL
        const courseId = event.pathParameters.id;

        const params = {
            TableName: 'courses', 
            Key: {
                id: courseId
            }
        };

        // Видаляємо з бази
        await dynamodb.delete(params).promise();

        // Правильно форматуємо відповідь для API Gateway
        return {
            statusCode: 200,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ message: "Course deleted successfully", id: courseId })
        };
        
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error", error: error.message })
        };
    }
};
