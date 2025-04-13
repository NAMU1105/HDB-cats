import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";
import { APIGatewayProxyHandler } from "aws-lambda";

const dynamodb = new DynamoDBClient({});
const TABLE_NAME = process.env.TABLE_NAME || "HDBCatPhotos";

export const handler: APIGatewayProxyHandler = async (event) => {
  const hdb_block = event.pathParameters?.hdb_block;
  try {
    const command = new ScanCommand({
      TableName: TABLE_NAME,
      FilterExpression: "hdb_block = :hdb",
      ExpressionAttributeValues: {
        ":hdb": { S: hdb_block }
      }
    });
    const result = await dynamodb.send(command);
    const items = result.Items?.map(item => ({
      photo_id: item.photo_id.S,
      hdb_block: item.hdb_block.S,
      description: item.description.S,
      url: item.url.S,
      date: item.date.S
    }));

    return {
      statusCode: 200,
      body: JSON.stringify(items)
    };
  } catch (err) {
    console.error(err);
    return { statusCode: 500, body: "Failed to fetch photos" };
  }
};
