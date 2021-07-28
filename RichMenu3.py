import requests

headers = {"Authorization":"Bearer tmuAnHqQlmJQ2K2SGpuoISTqEdStRu76LLgDHOuJa+HMOW/2h8SiKlJf53Tjlwpt8VSxf/o1keFCxj2FLQYHS91nz4ldHSy+T0zWAYXSME1TIBqQ3j1ax56mP+OJuqhxkU+6VZmVWd1S4SA+Ax7C9gdB04t89/1O/w1cDnyilFU=","Content-Type":"application/json"}

req = requests.request('POST', 'https://api.line.me/v2/bot/user/all/richmenu/richmenu-5241687957d65e90db0601e1411db174', 
                       headers=headers)

print(req.text)