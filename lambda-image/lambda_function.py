import json
import pandas as pd

from ratingcurve.ratings import PowerLawRating


def mock_event():
    from ratingcurve import data

    df = data.load('green channel')

    return {
        "data": df.to_json(orient="index"),
        "metadata": {'breakpoints': 2},
    }


def handler(event, context):
    event = mock_event()  # fort testing

    data = event.get("data")
    metadata = event.get("metadata")

    # from io import StringIO
    df = pd.read_json(data, orient="index")

    rating = PowerLawRating(**metadata)
    trace = rating.fit(q=df['q'], h=df['stage'], q_sigma=df['q_sigma'])

    table = rating.table()
    response = table.to_json(orient="index")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": response,
    }


if __name__ == "__main__":
    pass
