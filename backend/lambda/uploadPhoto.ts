import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { v4 as uuidv4 } from "uuid";
import { APIGatewayProxyHandler } from "aws-lambda";

const s3 = new S3Client({});
const dynamodb = new DynamoDBClient({});
const BUCKET_NAME = process.env.BUCKET_NAME || "hdb-cat-photos-bucket";
const TABLE_NAME = process.env.TABLE_NAME || "HDBCatPhotos";

export const handler: APIGatewayProxyHandler = async (event) => {
  try {
    const body = JSON.parse(event.body || "{}");
    const { photoBase64, hdb_block, description } = body;

    const photoId = uuidv4();
    const buffer = Buffer.from(photoBase64, "base64");

    await s3.send(new PutObjectCommand({
      Bucket: BUCKET_NAME,
      Key: `${photoId}.jpg`,
      Body: buffer,
      ContentType: "image/jpeg",
      ACL: "public-read"
    }));

    await dynamodb.send(new PutItemCommand({
      TableName: TABLE_NAME,
      Item: {
        photo_id: { S: photoId },
        hdb_block: { S: hdb_block },
        description: { S: description },
        url: { S: `https://${BUCKET_NAME}.s3.amazonaws.com/${photoId}.jpg` },
        date: { S: new Date().toISOString() }
      }
    }));

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Photo uploaded", photoId }),
    };
  } catch (error) {
    console.error(error);
    return { statusCode: 500, body: "Upload failed" };
  }
};
