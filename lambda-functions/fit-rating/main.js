'use strict';

exports.handler = function (event, context, callback) {
    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            table: [
                ['1', '2', '3'],
                ['1', '2', '3'],
                ['1', '2', '3']
            ]
        }),
    };
    callback(null, response);
};
