import sys
import json
#import ratingcurve

def handler(event, context):
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"dataset": { "name": "test", "stage": [1,2,3] }}),
    }


#if __name__ == "__main__":
#    pass
