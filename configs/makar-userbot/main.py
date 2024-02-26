import os

from pyrogram import Client, filters

#встановлення клієнта
app = Client(
    name="data/my_account",
    api_id=os.environ["BOT_API_ID"],
    api_hash=os.environ["BOT_API_HASH"],
)

@app.on_message(filters.chat(-1001223955273))
def echo(client, message):
    message.forward(-1001957404796)

@app.on_message(filters.chat(-1001872814736))
def echo(client, message):
    if '@radaruswarmonitor' in message.text:
        pass
    elif 'Реквізити' in message.text:
        pass
    else:
        message.forward(-1001957404796)

@app.on_message(filters.chat(-1001473413530))
def echo(client, message):
    message.forward(-1001957404796)

@app.on_message(filters.chat(-1001863114435))
def echo(client, message):
    print(message.text)
    message.forward(-1001938720179)

@app.on_message(filters.chat(-1001723988169))
def echo(client, message):
    if '@warradarukraine' in message.text:
        message.forward(-1001938720179)
    else:
        message.forward(-1001957404796)
 
@app.on_message(filters.chat(-1001938720179))
def echo(client, message):
    if '@warradarukraine' in message.text:
        text_without_username = message.text.replace('@warradarukraine', '')
        message.text = text_without_username.strip()
        message.reply_text(message.text)
    else:
        message.forward(-1001957404796)
    
app.run()

