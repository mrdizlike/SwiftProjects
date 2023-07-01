from flask import Flask, request, jsonify
from characterai import pyAsyncCAI
import asyncio


client = pyAsyncCAI('771fab4398eaaf42d225db31de62c8824610a7b0')
app = Flask(__name__)

@app.route('/send', methods=['GET'])


async def send():
    await client.start(headless=True)

    while True:
        message = str(request.args.get('a'))
        data = await client.chat.send_message('LZM-paD4wnfHg1fXYUWWttWh9DbswClmWusaV1zSuwc', message, wait=True)
        return jsonify({'result': data['replies'][0]['text']})
    
if __name__ == '__main__':
    app.run(debug=True)


