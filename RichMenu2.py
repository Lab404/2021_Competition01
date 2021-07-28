from linebot import (
    LineBotApi, WebhookHandler
)

line_bot_api = LineBotApi('tmuAnHqQlmJQ2K2SGpuoISTqEdStRu76LLgDHOuJa+HMOW/2h8SiKlJf53Tjlwpt8VSxf/o1keFCxj2FLQYHS91nz4ldHSy+T0zWAYXSME1TIBqQ3j1ax56mP+OJuqhxkU+6VZmVWd1S4SA+Ax7C9gdB04t89/1O/w1cDnyilFU=')

with open("richmenuTEST.jpg", 'rb') as f:
    line_bot_api.set_rich_menu_image("richmenu-5241687957d65e90db0601e1411db174", "image/jpeg", f)