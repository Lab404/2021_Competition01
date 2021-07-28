import requests
import json

headers = {"Authorization":"Bearer tmuAnHqQlmJQ2K2SGpuoISTqEdStRu76LLgDHOuJa+HMOW/2h8SiKlJf53Tjlwpt8VSxf/o1keFCxj2FLQYHS91nz4ldHSy+T0zWAYXSME1TIBqQ3j1ax56mP+OJuqhxkU+6VZmVWd1S4SA+Ax7C9gdB04t89/1O/w1cDnyilFU=","Content-Type":"application/json"}

body = {
    "size": {"width": 2500, "height": 1686},
    "selected": "true",
    "name": "選單",
    "chatBarText": "點我收合選單",
    "areas":[
        {
          "bounds": {"x": 0, "y": 0, "width": 833, "height": 843},
          "action": {"type": "message", "text": "認識憂鬱症"}
        },
        {
          "bounds": {"x": 834, "y": 0, "width": 833, "height": 843},
          "action": {"type": "message", "text": "查詢wiki"}
        },
        {
          "bounds": {"x": 1667 , "y": 0, "width": 833, "height": 843},
          "action": {"type": "uri", "uri":"https://line.me/R/nv/location/"}
        },
        {
          "bounds": {"x": 0, "y": 844, "width": 833, "height": 843},
          "action": {"type": "message", "text": "檢測憂鬱情緒"}
        },
        {
          "bounds": {"x": 834, "y": 844, "width": 833, "height": 843},
          "action": {"type": "message", "text": "短期關懷服務"}
        },
        {
          "bounds": {"x": 1667, "y": 844, "width": 833, "height": 843},
          "action": {"type": "message", "text": "長期輔助系統"}
        }
    ]
  }

req = requests.request('POST', 'https://api.line.me/v2/bot/richmenu', 
                       headers=headers,data=json.dumps(body).encode('utf-8'))

print(req.text)
#"type":"location", "label":"Location"