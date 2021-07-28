# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 17:09:59 2021

@author: AN
"""

from flask import Flask, request, abort,make_response,jsonify,redirect

from linebot import (
    LineBotApi, WebhookHandler
)
from linebot.exceptions import (
    InvalidSignatureError
)
from linebot.models import (
    MessageEvent, TextMessage, TextSendMessage,QuickReply,
    QuickReplyButton,MessageAction,CameraAction,CameraRollAction,
    LocationAction,FlexSendMessage,LocationMessage,TemplateSendMessage,
    CarouselTemplate,CarouselColumn,PostbackTemplateAction,MessageTemplateAction,
    URITemplateAction,ButtonsTemplate,PostbackAction,URIAction,FollowEvent
)

import json

import re

import jieba
import jieba.analyse
jieba.case_sensitive = True # 可控制對於詞彙中的英文部分是否為case sensitive, 預設False

import logging
#logging.disable(50)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)
import os
from gensim import corpora, models, similarities

import random

from opencc import OpenCC

import pymssql

import requests
from bs4 import BeautifulSoup

import datetime

import math

app = Flask(__name__)

#Channel access token
line_bot_api = LineBotApi('tmuAnHqQlmJQ2K2SGpuoISTqEdStRu76LLgDHOuJa+HMOW/2h8SiKlJf53Tjlwpt8VSxf/o1keFCxj2FLQYHS91nz4ldHSy+T0zWAYXSME1TIBqQ3j1ax56mP+OJuqhxkU+6VZmVWd1S4SA+Ax7C9gdB04t89/1O/w1cDnyilFU=')
#Channel secret
handler = WebhookHandler('55a8086a8c1ad17a6df07d77da00a5bb')
LineLogin='https://d18a3e2692f3.ngrok.io'
Bot_Basic_id = "@145ltdwx"


conn = pymssql.connect(
        host = 'localhost',
        user = 'Wiwi',
        password = '0919794175',
        database = 'DepChatBot2'
        )

cursor = conn.cursor(as_dict=True)

x = datetime.datetime.now()
date = str(x.year)+'年'+str(x.month)+'月'+str(x.day)+'日'

urlpicture='https://scontent.xx.fbcdn.net/v/t1.6435-9/143971440_3246615255440558_6639615273793150161_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=730e14&_nc_ohc=QM17f_oqWygAX9Xp0CF&_nc_ht=scontent.frmq2-1.fna&oh=ed7011fb9f43c44fa403668e734d17f8&oe=60C820CF&_nc_fr=frmq2c01'
FileAddress="C:\\Users\\user\\Desktop\\研究室\\比賽一\\Code\\"

@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']

    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)

    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        print("Invalid signature. Please check your channel access token/channel secret.")
        abort(400)

    return 'OK'

@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    path=FileAddress
    profile = line_bot_api.get_profile(event.source.user_id)
    user_name = profile.display_name #使用者名稱
    uid = profile.user_id # 發訊者ID
    #print(uid)
    user_talk = event.message.text
    
    action(user_talk,event,uid,user_name)
    
@handler.add(MessageEvent, message=LocationMessage)
def handle_location_message(event):
    #https://ipinfo.io/ 查IP
    addr = event.message.address #地址
    my_lat = str(event.message.latitude)  #緯度
    my_lon = str(event.message.longitude) #緯度

    if addr is None:
        msg=f'收到GPS座標:({my_lat},{my_lon})\n謝謝!'
    else:
        msg=f'收到GPS座標:({my_lat},{my_lon})\n地址:{addr}!'
    print(msg)
    
    #//////////////////////////////////////////////////////////#
    #開啟藥局資料CSV
    import csv
    name=[]
    phone=[]
    address=[]
    lon=[]
    lat=[]
    
    
    # 開啟 CSV 檔案
    with open(FileAddress+'clinic3.csv', newline='',encoding = 'utf-8-sig') as csvFile:
    
      # 3.轉成一個 dictionary, 讀取 CSV 檔內容，將每一列轉成字典
      rows = csv.DictReader(csvFile)
    
      # 迴圈輸出 指定欄位
      for row in rows:
            name.append(row['name'])
            phone.append(row['phone'])
            address.append(row['address'])
            lon.append(row['lon'])
            lat.append(row['lat'])
    #//////////////////////////////////////////////////////////#
    
    profile = line_bot_api.get_profile(event.source.user_id)
    uid = profile.user_id # 發訊者ID
    
    l1 = float(my_lat),float(my_lon)
    site = []
    sort = []
    final_list=[]

    i=0
    for i in range(len(name)):
        l2 = float(lon[i]),float(lat[i])
        #site.append(distance(l1,l2))
        final_list.append([distance(l1,l2),name[i],phone[i],address[i],lon[i],lat[i]])
        #print(final_list)
        
    sort = sorted(final_list)
    
    print('前5家最近的診所:')
    print(sort[:5])
    
    
    message2 = TemplateSendMessage(
        alt_text='Carousel template',
        template=CarouselTemplate(
            columns=[
                CarouselColumn(
                    thumbnail_image_url=urlpicture,
                    title='診所名稱:' + sort[:5][0][1],
                    text='地址:' + sort[:5][0][3] + '\n'
                    '電話:' + sort[:5][0][2] + '\n'
                    '距離您的位置:' + str(sort[:5][0][0]) + '/km',
                    actions=[                      
                        URITemplateAction(
                            label='查看路線',
                            uri="https://www.google.com.tw/maps/dir/" + my_lat + "," + my_lon + "/'" + sort[:5][0][4] + "," + sort[:5][0][5] + "'"
                        )
                    ]
                ),
                CarouselColumn(
                    thumbnail_image_url=urlpicture,
                    title='診所名稱:' + sort[:5][1][1],
                    text='地址:' + sort[:5][1][3] + '\n'
                    '電話:' + sort[:5][1][2] + '\n'
                    '距離您的位置:' + str(sort[:5][1][0]) + '/km',
                    actions=[                       
                        URITemplateAction(
                            label='查看路線',
                            uri="https://www.google.com.tw/maps/dir/" + my_lat + "," + my_lon + "/'" + sort[:5][1][4] + "," + sort[:5][1][5] + "'"
                        )
                    ]
                ),    
                CarouselColumn(
                    thumbnail_image_url=urlpicture,
                    title='診所名稱:' + sort[:5][2][1],
                    text='地址:' + sort[:5][2][3] + '\n'
                    '電話:' + sort[:5][2][2] + '\n'
                    '距離您的位置:' + str(sort[:5][2][0]) + '/km',
                    actions=[                       
                        URITemplateAction(
                            label='查看路線',
                            uri="https://www.google.com.tw/maps/dir/" + my_lat + "," + my_lon + "/'" + sort[:5][2][4] + "," + sort[:5][2][5] + "'"
                        )
                    ]
                ),
                CarouselColumn(
                    thumbnail_image_url=urlpicture,
                    title='診所名稱:' + sort[:5][3][1],
                    text='地址:' + sort[:5][3][3] + '\n'
                    '電話:' + sort[:5][3][2] + '\n'
                    '距離您的位置:' + str(sort[:5][3][0]) + '/km',
                    actions=[                       
                        URITemplateAction(
                            label='查看路線',
                            uri="https://www.google.com.tw/maps/dir/" + my_lat + "," + my_lon + "/'" + sort[:5][3][4] + "," + sort[:5][3][5] + "'"
                        )
                    ]
                ),
                CarouselColumn(
                    thumbnail_image_url=urlpicture,
                    title='診所名稱:' + sort[:5][4][1],
                    text='地址:' + sort[:5][4][3] + '\n'
                    '電話:' + sort[:5][4][2] + '\n'
                    '距離您的位置:' + str(sort[:5][4][0]) + '/km',
                    actions=[                       
                        URITemplateAction(
                            label='查看路線',
                            uri="https://www.google.com.tw/maps/dir/" + my_lat + "," + my_lon + "/'" + sort[:5][4][4] + "," + sort[:5][4][5] + "'"
                        )
                    ]
                ),
            ]
        )
    )        
    
    line_bot_api.reply_message(
        event.reply_token,
        message2
    )
    
def action(user_talk,event,uid,user_name):
    if user_talk == '認識憂鬱症':
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(
                text='您想先認識憂鬱症的那些範圍呢?',
                quick_reply=QuickReply(
                    items=[
                        QuickReplyButton(
                            action=MessageAction(label="甚麼是憂鬱症?", text="甚麼是憂鬱症?")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="憂鬱症有哪些症狀?", text="憂鬱症有哪些症狀?")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="老年憂鬱症和一般憂鬱症有啥不同?", text="老年憂鬱症和一般憂鬱症有啥不同?")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="憂鬱症要怎麼治療?", text="憂鬱症要怎麼治療?")
                        ),                            
                    ])))
    elif user_talk == '甚麼是憂鬱症?':
            line_bot_api.reply_message(
                event.reply_token,
                TextSendMessage(
                    text='台灣地區的重鬱症盛行率，由台大李明濱教授及陳為堅教授等人所主持的台灣精神疾病調查顯示，在 2003 年到 2005 年間，18 歲以上成年人符合重鬱症診斷標準者大約在 1.2%左右，也就是將近有 20 萬人罹患重鬱症[2]。其實這是依照較嚴謹的標準，用來定義憂鬱症狀嚴重度較高的個案；所以，要是不管有沒有達到嚴格的診斷標準，在一般人口中，因憂鬱焦慮情緒而感到困擾的比例必定大幅提高。憂鬱不但影響生活品質，還可能造成一個最不願意見到的遺憾，那就是 ─ 自殺；正因為如此，怎麼辨識自我情緒狀態、當面對情緒困擾時，要如何自助和求助專業人員，這些知識不可或缺。',
                    quick_reply=QuickReply(
                        items=[
                            QuickReplyButton(
                                action=MessageAction(label="憂鬱症有哪些症狀?", text="憂鬱症有哪些症狀?")
                            ),
                            QuickReplyButton(
                                action=MessageAction(label="老年憂鬱症和一般憂鬱症有啥不同?", text="老年憂鬱症和一般憂鬱症有啥不同?")
                            ),
                            QuickReplyButton(
                                action=MessageAction(label="憂鬱症要怎麼治療?", text="憂鬱症要怎麼治療?")
                            ),                            
                        ])))
            
    elif user_talk == '持續性憂鬱症':
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(
                text='持續性憂鬱症的症狀與重度憂鬱症的症狀相似，但是與重度憂鬱症相比，持續性憂鬱症的程度較輕，而持續時間較長[3]。持續性憂鬱症一般要持續2年才能確診，病程可以持續10年以上甚至一生[1]。心境障礙診斷方法與重度憂鬱症相同，但其診斷標準較低。對確診的患者，其治療方法與重度憂鬱症的治療方法相同[3]。持續性憂鬱症會引發重度憂鬱症，有研究顯示有79%的患者在一生中會併發重度憂鬱症，此情況亦稱為雙重憂鬱症[1]。',
                quick_reply=QuickReply(
                    items=[
                        QuickReplyButton(
                            action=MessageAction(label="季節性憂鬱症", text="季節性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="重度憂鬱症", text="重度憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="非典型憂鬱症", text="非典型憂鬱症")
                        ),                            
                    ])))
        
    elif user_talk == '季節性憂鬱症':
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(
                text='季節性憂鬱症的症狀與重度憂鬱症相似，有時歸類為重度憂鬱症的一個亞型[31]。這種憂鬱症的主要特點就是經常在寒冷季節發病並在其他季節完全緩解。季節性憂鬱症隨緯度的增高而越發流行, 意即日照時間越少，發病率越高。多曬太陽可減輕病情，對這種疾病的診斷需要確認患者只在特定時節發病而在其他季節從未發病。對患者的治療與重性抑鬱障礙的治療相似，對於季節性情緒障礙，光照療法似乎特別有效。 澳洲昆士蘭大學的學者於2013年繪製的「憂鬱症世界地圖」顯示，日本與陽光充足、氣候溫暖的東南亞、南歐、澳大利亞同屬憂鬱症發病率較低的地區，而氣候寒冷、缺少陽光的北歐、俄羅斯、阿富汗等地區則屬憂鬱症高發區[32] [1]。',
                quick_reply=QuickReply(
                    items=[
                        QuickReplyButton(
                            action=MessageAction(label="持續性憂鬱症", text="持續性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="重度憂鬱症", text="重度憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="非典型憂鬱症", text="非典型憂鬱症")
                        ),                            
                    ])))
        
    elif user_talk == '重度憂鬱症':
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(
                text='在所有憂鬱症中，重度抑鬱障礙的症狀最為嚴重，其主要影響心境、認知和軀體功能。心境方面，患者長期（兩周以上）處於極其抑鬱的情感狀態中；認知方面，患者往往看到事物的消極面，被空虛感和無價值感包圍；軀體功能方面主要有進食和睡眠障礙和無力感，頭痛等[1]。患者可能反覆想到死或者有自殺企圖，最終大約有3.4%的患者自殺[20]。',
                quick_reply=QuickReply(
                    items=[
                        QuickReplyButton(
                            action=MessageAction(label="持續性憂鬱症", text="持續性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="季節性憂鬱症", text="季節性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="非典型憂鬱症", text="非典型憂鬱症")
                        ),                            
                    ])))
        
    elif user_talk == '非典型憂鬱症':
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(
                text='在一些特殊情況下，患者可能表現出明顯的憂鬱症狀，但是不符合DSM任何一種具體病症的診斷標準，這時可以作出非典型憂鬱症的診斷[33]。',
                quick_reply=QuickReply(
                    items=[
                        QuickReplyButton(
                            action=MessageAction(label="持續性憂鬱症", text="持續性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="季節性憂鬱症", text="季節性憂鬱症")
                        ),
                        QuickReplyButton(
                            action=MessageAction(label="重度憂鬱症", text="重度憂鬱症")
                        ),                            
                    ])))
        
    elif user_talk == '查詢wiki':
        #cursor.execute("SELECT * FROM \"Contexts\" where UserID = " + uid)
        cursor.execute('SELECT * FROM "Student" WHERE Student_userID = %(name1)s' , {'name1': uid})
        msg=""
        for row in cursor:
            msg = msg + str(row['Student_Id'])
        
        if msg!="":
            cursor.execute('SELECT *  FROM "Service" WHERE [User] = %(name1)s' , {'name1': msg})
            SearchWiki = ""
            for row in cursor:
                SearchWiki = SearchWiki + row['SearchWiki']
            
            if SearchWiki=='1':
                line_bot_api.reply_message(
               event.reply_token,
               TextSendMessage(text="您已經開啟wiki服務了")
           )
            elif SearchWiki=='0':
                cursor.execute('UPDATE Service SET SearchWiki = 1 Where [User]= %(name1)s' , {'name1': msg})
                conn.commit()
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text="請輸入您要查詢的內容")
               )
            else:
                cursor.executemany(
                  "INSERT INTO \"Service\" VALUES (%s,%s,%s,%s)",
                  [(msg,'1','0','0')])
                # 如果沒有指定autocommit屬性為True的話就需要呼叫commit()方法
                conn.commit()
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text="請輸入您要查詢的內容")
               )
        else:
            buttons_template_message2 = TemplateSendMessage(
                        alt_text='在使用本服務前，請您先透過以下網址進行註冊',
                        template=ButtonsTemplate(
                            thumbnail_image_url=urlpicture,
                            title='您可以透過以下網址進行註冊',
                            text='註冊完畢後會自動引導您進行下一個步驟',
                            actions=[
                                URIAction(
                                    label='前往註冊',
                                    uri=LineLogin+'/Student/Login?check=true'
                                )
                            ]
                        )
                    )
            line_bot_api.push_message(uid, buttons_template_message2)
          
    elif user_talk=="檢測憂鬱情緒":
        cursor.execute('SELECT * FROM "Student" WHERE Student_userID = %(name1)s' , {'name1': uid})
        UserID = ""
        for row in cursor:
            UserID = UserID + str(row['Student_Id'])
            
        buttons_template_message = TemplateSendMessage(
            alt_text='您可以透過以下網址進行檢測',
            template=ButtonsTemplate(
                thumbnail_image_url=urlpicture,
                title='您可以透過以下網址進行檢測',
                text='檢設完畢後會自動將結果傳回來給您',
                actions=[
                    URIAction(
                        label='前往檢測',
                        uri=LineLogin+'/Student/Scale?userID='+uid
                    )
                ]
            )
        )
        
        buttons_template_message2 = TemplateSendMessage(
            alt_text='在檢測量表前，請您先透過以下網址進行註冊',
            template=ButtonsTemplate(
                thumbnail_image_url=urlpicture,
                title='您可以透過以下網址進行註冊',
                text='註冊完畢後會自動引導您進行下一個步驟',
                actions=[
                    URIAction(
                        label='前往註冊',
                        uri=LineLogin+'/Student/Login?check=true'
                    )
                ]
            )
        )
        #https://4d5fd34b202e.ngrok.io/Student/Login
        if UserID!="":
            line_bot_api.push_message(uid, buttons_template_message)
        else:
            line_bot_api.push_message(uid, buttons_template_message2)
        
        """
        line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text="您的填單網址:\n" + "https://57df098d8a2c.ngrok.io/Student/Scale?userID="+uid)
               )
        """
        
    elif user_talk=='測試':
        test(uid,user_talk)
        
    elif user_talk=='短期關懷服務':
        print("111122222221")
        cursor.execute('SELECT * FROM "Student" WHERE Student_userID = %(name1)s' , {'name1': uid})
        ID = ""
        for row in cursor:
            ID = ID + str(row['Student_Id'])
        
        if ID!="":
            cursor.execute('SELECT *  FROM "Service" WHERE [User] = %(name1)s' , {'name1': ID})
            Short_Service = ""
            for row in cursor:
                Short_Service = Short_Service + row['Short_Service']
            if Short_Service=="1":
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text='您目前正在執行短期關懷服務')
               )
            elif Short_Service=="0":
                #print('1111')
                cursor.execute('UPDATE Service SET Short_Service = 1 Where [User] = %(name1)s' , {'name1': ID})
                conn.commit()
                
                cursor.executemany(
                  "INSERT INTO \"Short_record2\" VALUES (%s,%s,%s,%s,%s,%s)",
                  [(ID,"","",date,"",'0')])
                # 如果沒有指定autocommit屬性為True的話就需要呼叫commit()方法
                conn.commit()

                line_bot_api.reply_message(
                                   event.reply_token,
                                   TextSendMessage(text='也許您可以跟我聊聊')
                               )
            else:        
                cursor.executemany(
                  "INSERT INTO \"Service\" VALUES (%s,%s,%s,%s)",
                  [(ID,'0','1','0')])
                # 如果沒有指定autocommit屬性為True的話就需要呼叫commit()方法
                conn.commit()
                
                cursor.executemany(
                  "INSERT INTO \"Short_record2\" VALUES (%s,%s,%s,%s,%s,%s)",
                  [(ID,"","",date,"",'0')])
                # 如果沒有指定autocommit屬性為True的話就需要呼叫commit()方法
                conn.commit()
                
                
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text='也許您可以跟我聊聊')
               )
                
        else:
            buttons_template_message2 = TemplateSendMessage(
                        alt_text='在使用本服務前，請您先透過以下網址進行註冊',
                        template=ButtonsTemplate(
                            thumbnail_image_url=urlpicture,
                            title='您可以透過以下網址進行註冊',
                            text='註冊完畢後會自動引導您進行下一個步驟',
                            actions=[
                                URIAction(
                                    label='前往註冊',
                                    uri=LineLogin+'/Student/Login?check=true'
                                )
                            ]
                        )
                    )
            line_bot_api.push_message(uid, buttons_template_message2)
    
    elif  user_talk=='長期輔助系統':
        cursor.execute('SELECT * FROM "Student" WHERE Student_userID = %(name1)s' , {'name1': uid})
        UserID = ""
        Counseling = ""
        Socialworker_id=""
        for row in cursor:
            UserID = UserID + str(row['Student_Id'])
            Counseling = Counseling + str(row['Counseling'])
            Socialworker_id = Socialworker_id + str(row['Socialworker_id'])
        
        if UserID!="":
            if Counseling=='0':
                buttons_template_message2 = TemplateSendMessage(
                            alt_text='歡迎使用長期日誌回報系統',
                            template=ButtonsTemplate(
                                thumbnail_image_url=urlpicture,
                                title='請點選下方按紐進行日誌填寫',
                                text='填寫完畢後請等待回覆',
                                actions=[
                                    URIAction(
                                        label='前往填寫',
                                        uri=LineLogin+'/Student/Record?uid='+uid+'&name='+user_name
                                    )
                                ]
                            )
                        )
                line_bot_api.push_message(uid, buttons_template_message2)
            else:
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text='您不是長期服務的用戶。')
               )

        else:
            buttons_template_message2 = TemplateSendMessage(
                        alt_text='在使用本服務前，請您先透過以下網址進行註冊',
                        template=ButtonsTemplate(
                            thumbnail_image_url=urlpicture,
                            title='您可以透過以下網址進行註冊',
                            text='註冊完畢後會自動引導您進行下一個步驟',
                            actions=[
                                URIAction(
                                    label='前往註冊',
                                    uri=LineLogin+'/Student/Login'
                                )
                            ]
                        )
                    )
            line_bot_api.push_message(uid, buttons_template_message2)            

            
    elif user_talk!="":
        cursor.execute('SELECT * FROM "Student" WHERE Student_userID = %(name1)s' , {'name1': uid})
        UserID=""
        for row in cursor:
            UserID = UserID + str(row['Student_Id'])
        
        if UserID != "":
            cursor.execute('SELECT * FROM Service WHERE [User] = %(name1)s' , {'name1': UserID})
            SearchWiki = ""
            Short_Service = ""
            Report_Service = ""
            for row in cursor:
                SearchWiki = SearchWiki + row['SearchWiki']
                Short_Service = Short_Service + row['Short_Service']
                Report_Service = Report_Service + row['Report_Service']
            
            if SearchWiki == '1':
                respone = getwiki(user_talk)
                if user_talk =='憂鬱症':
                    line_bot_api.reply_message(
                        event.reply_token,
                        TextSendMessage(
                            text=respone,
                            quick_reply=QuickReply(
                                items=[
                                    QuickReplyButton(
                                        action=MessageAction(label="持續性憂鬱症", text="持續性憂鬱症")
                                    ),
                                    QuickReplyButton(
                                        action=MessageAction(label="季節性憂鬱症", text="季節性憂鬱症")
                                    ),
                                    QuickReplyButton(
                                        action=MessageAction(label="重度憂鬱症", text="重度憂鬱症")
                                    ),
                                    QuickReplyButton(
                                        action=MessageAction(label="非典型憂鬱症", text="非典型憂鬱症")
                                    ),                        
                                ])))
                else:
                    line_bot_api.reply_message(
                       event.reply_token,
                       TextSendMessage(text=respone)
                   )
                cursor.execute('UPDATE Service SET SearchWiki = 0 Where [User]= %(name1)s' , {'name1': UserID})
                conn.commit()

            elif Short_Service == '1':
                respone = short_talking(uid,event,user_talk)
                line_bot_api.reply_message(
                       event.reply_token,
                       TextSendMessage(text=respone)
                   )
            else:
                line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text='請由下方服務選單來選擇服務。')
               )
            

        else:
            line_bot_api.reply_message(
                   event.reply_token,
                   TextSendMessage(text='請由下方服務選單來選擇服務。')
               )
            
    
    
    respone = '123'
        
    return respone


def getwiki(keyword):
    res = requests.get('https://zh.wikipedia.org/wiki/{}'.format(keyword))
    soup = BeautifulSoup(res.text, 'lxml')
    article = soup.select_one('.mw-parser-output p').text
    cc = OpenCC('s2twp')
    return cc.convert(article)

def distance(origin, destination):
    import math
    lat1, lon1 = origin
    lat2, lon2 = destination
    radius = 6371 # km

    dlat = math.radians(lat2-lat1)
    dlon = math.radians(lon2-lon1)
    a = math.sin(dlat/2) * math.sin(dlat/2) + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dlon/2) * math.sin(dlon/2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    d = round(radius * c,2)

    return d

def short_talking(uid,event,user_talk):
    cursor.execute('SELECT * FROM Student WHERE Student_userID = %(name1)s' , {'name1': uid})
    UserID = ""
    lineID = ""
    for row in cursor:
        UserID = UserID + str(row['Student_Id'])
        lineID = lineID + str(row['LineId'])
        
    cursor.execute('SELECT * FROM Short_record2 WHERE [User] = %(name1)s' , {'name1': UserID})
    context=""
    word_nm=0
    context_ID=0
    for row in cursor:
        context = row['Context']
        word_nm = int(row['Word_nm'])
        context_ID = row['ID']
        
    word_nm = str(word_nm + 1)
    total_context = context + user_talk
    print('目前累積句數:' + word_nm)
    print(total_context)
    
    cursor.execute('UPDATE Short_record2 SET Context = %(name1)s , Word_nm = %(name2)s Where ID = %(name3)s' , {'name1': total_context,'name2': word_nm,'name3': context_ID})
    conn.commit()
    
    if (int(word_nm))%2==0 and int(word_nm)!=0:
        line_bot_api.push_message(uid, TextSendMessage(text='請稍等，系統正在分析中。'))
        sims,msgg,news_ID = checkpageLSI(total_context)
        context_num=[]
        for i in range(len(sims)):
            if sims[i][1]>=0.6:
                cursor.execute('UPDATE Service SET Short_Service = 0 Where [User] = %(name1)s' , {'name1': UserID})
                conn.commit()
                
                topic = check_topic(news_ID)
                cursor.execute('UPDATE Short_record2 SET Topic = %(name1)s Where ID = %(name2)s' , {'name1': topic,'name2': context_ID})
                conn.commit()
                
                respone='系統將為您推薦「'+topic+'」領域的輔導員。'
                
                final_S_ID,final_tfidf = recommend(uid,topic)
                
                line_bot_api.push_message(uid, TextSendMessage(text='推薦的社工ID:'+str(final_S_ID) + '，權重為:'+str(final_tfidf)))
                
                cursor.execute('SELECT * FROM Socialworker WHERE Socialworker_Id = %(name1)s' , {'name1': final_S_ID})
                Email = ""
                for row in cursor:
                    Email = Email + row['Socialworker_Email']
                
                cursor.execute('SELECT * FROM Student WHERE Student_userID = %(name1)s' , {'name1': uid})
                LineID = ""
                for row in cursor:
                    LineID = LineID + row['LineId']
                
                buttons_template_message2 = TemplateSendMessage(
                    alt_text='您是否同意將自己的Line ID提供給該社工?',
                    template=ButtonsTemplate(
                        thumbnail_image_url=urlpicture,
                        title='按下以下按鈕代表同意系統將您的LINE ID提供給社工。',
                        text='點選擇代表同意。',
                        actions=[
                            URIAction(
                                label='同意',
                                uri=LineLogin+'/Student/sendGmail?email='+Email+'&lineID='+LineID
                            )
                        ]
                    )
                )               
                
                buttons_template_message3 = TemplateSendMessage(
                    alt_text='如果使用後覺得服務不錯，請幫助我們填寫滿意度調查表。',
                    template=ButtonsTemplate(
                        thumbnail_image_url=urlpicture,
                        title='此滿意度調查表並不會讓社工知道，僅作系統資料參考。',
                        text='填寫代表同意。',
                        actions=[
                            URIAction(
                                label='填寫',
                                uri=LineLogin+'/Student/Feedback?uid=' + uid + '&sid=' + str(final_S_ID) + '&topic=' + str(topic) +'&cid=' + str(context_ID)
                            )
                        ]
                    )
                )                         
                
                line_bot_api.push_message(uid, buttons_template_message2)
                line_bot_api.push_message(uid, buttons_template_message3)
                break
            else:
                msg = jieba_stopword(user_talk)
                taps = tfidf(msg)
                #這裡設TFIDF隨機
                rnum = random.randint(0,3)
                print("隨機:"+str(rnum))
                if rnum==0:
                    respone = "多和我說說「" + taps[0][0] + "」或「" + taps[1][0] + "」，想到其他的也可以直接跟我說喔。"       
                elif rnum==1:
                    respone = "看來您想多聊一些有關「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題，想到其他的也可以直接跟我說喔。" 
                elif rnum==2:
                    respone = "不訪多和我談談「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題，想到其他的也可以直接跟我說喔。"       
                elif rnum==3:
                    respone = "也許多聊聊「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題可以幫助系統快速判斷，想到其他的也可以直接跟我說喔。"                        
                
                break
            
    else:
        msg = jieba_stopword(user_talk)
        taps = tfidf(msg)
        #這裡設TFIDF隨機
        rnum = random.randint(0,3)
        print("隨機:"+str(rnum))
        if rnum==0:
            respone = "多和我說說「" + taps[0][0] + "」或「" + taps[1][0] + "」，想到其他的也可以直接跟我說喔。"       
        elif rnum==1:
            respone = "看來您想多聊一些有關「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題，想到其他的也可以直接跟我說喔。" 
        elif rnum==2:
            respone = "不訪多和我談談「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題，想到其他的也可以直接跟我說喔。"       
        elif rnum==3:
            respone = "也許多聊聊「" + taps[0][0] + "」或「" + taps[1][0] + "」的話題可以幫助系統快速判斷，想到其他的也可以直接跟我說喔。"

    return respone

def jieba_stopword(msg):
    re_msg = re.sub('[(%。，》／：…？/」▲※▼▲★●【｜】◎:&\'-.『』！!-〈〉‘’\n（）「；～＆ㄜ🔴🙂🤮🈶🤓🤧👏😯👆🌚😥😃🥴🌝😜😝😨🖐👌😁👼👻－👵👿📖🔆😮🌟🏭👎👈😳😇😣😁😖😩😫😙😞🤗🙂🤨🔔🤩😦🤮😇💡🙋🧐😁💜🤕😰👨🎉🎉👋💻🚀📢🐣🚩👀🔹🔸🔺🙇😟😬🐶🤯🤬🤪😍👧💁👊😱🔥🙂😣🤤🤫😥📌📍🐳😟😨😠👏😾🤫👉👇😑😆😂😄😱👿👌🙇🤵😟🧐～🙏👍💪🙄🙃😒👂😭😡🤦😢😅😀😭🌸😊🤔😊😏😔😐💥🐦💦😵😓😡💸🥺🤷🤦🤣🥳💩💢🤢👩🏻👩😧🔪😤💰😎😚🤭💝💞💓🥰💗💘🤝🍀🔻🎈🔎🙂👆🎓👣🗣🤳🙋🌀👥🙇)(a-zA-Z))]',"",msg)
    seg_list = jieba.cut(re_msg)
    final_msg = " ".join(seg_list)
    msg5 = final_msg.strip().replace("  ", " ")
    msg3 = msg5.strip().replace("    ", " ")
    msg4 = msg3.strip().replace("  ", " ")
    msg6= msg4.strip().replace("  ", " ")
    
    #載入停用詞字典
    f = open(FileAddress+'dcard_total\\stopword.txt',encoding = 'utf-8-sig')
    stoplist = f.readlines()
    f.close()
    
    for i in range(len(stoplist)):
        stoplist[i] = re.sub('\n',"",stoplist[i])
    #stoplist
    
    a = msg6.split(' ')
    del_context=[]
    for i in range(len(a)):
        for j in range(len(stoplist)):
            if a[i] == stoplist[j]:
                del_context.append(stoplist[j])
                
    #print("去除單詞:")
    #print(del_context)
    
    for k in range(len(del_context)):
        try:
            a.remove(del_context[k])
        except:
            print("",end="")
            #print(del_context[k]+":已刪除")
    
    #去除相同單詞
    b = list(set(a))
    #恢復原本排列
    c = sorted(b,key=a.index)
    
    del_c=[]
    for i in range(len(c)):
        if len(c[i])<2:
            del_c.append(c[i])
                
    for k in range(len(del_c)):
        try:
            c.remove(del_c[k])
        except:
            print("",end="")
            
    #去除相同單詞
    b = list(set(c))
    #恢復原本排列
    c = sorted(b,key=a.index)
    
    print("jieba及stopword結果:")
    print(c)
    msgg = ""
    for msge in range(len(c)):
        if msge!=len(c)-1:
            msgg = msgg+c[msge] + " "
        else:
            msgg = msgg+c[msge]
    return msgg

def tfidf(msg):
    jieba.load_userdict(FileAddress+'dcard_total\\userDict.txt')
    jieba.analyse.set_idf_path(FileAddress+'dcard_total\\my_IDF.txt')
    seg_list = jieba.cut(msg)
    final_msg = " ".join(seg_list)
    #print(final_msg)
    tags = jieba.analyse.extract_tags(final_msg, topK=5,withWeight=True)
    print("tdidf結果:")
    print(tags)
    return tags

def checkpageLSI(msg):
    msg = jieba_stopword(msg)
    Path = FileAddress+'dcard_total\\'
    lsi = models.LsiModel.load(Path+'lyrics_total.lsi')
    # 載入語料庫
    if (os.path.exists(Path + "lyrics_total.dict")):
        dictionary = corpora.Dictionary.load(Path + "lyrics_total.dict")
        corpus = corpora.MmCorpus(Path+"lyrics_total.mm") # 將數據流的語料變為內容流的語料
        print("Used files generated from first tutorial")
    else:
        print("Please run first tutorial to generate data set")
    # 基於tfidf-> lsi 的文本相似度分析
    #newdoc = open('C:\\Users\\AN\\paper1\\paper code\\paper_lsi_test\\dcard_total\\test.txt','r',encoding="utf-8")
    doc = msg
    vec_bow = dictionary.doc2bow(doc.split()) # 把doc語料庫轉為一個一個詞包
    vec_lsi = lsi[vec_bow] # 用前面建好的 lsi 模型去計算這一篇歌詞 (input: 斷詞後的詞包、output: 20個主題成分)
    print('判斷文章:\n'+doc+"\n")
    #print(vec_lsi)
    
    # 建立索引
    index = similarities.MatrixSimilarity(lsi[corpus]) 
    index.save (Path+"lyrics_total.index")
    
    # 計算相似度（前五名）
    sims = index[vec_lsi]
    sims = sorted(enumerate(sims), key=lambda item: -item[1])
    for i in range(len(sims[:5])):
        print(sims[:5][i])
        #print(sims[:5][0][0])
    #print(sims[:5])
    #print(sims[:5][1][1])
    
    lyrics = [];
    fp = open(Path+"lyrics_cut_total.dataset",encoding="utf-8") # 斷詞後的歌詞
    #fp = open("lyrics/lyrics.dataset") # 看完整的歌詞
    for i, line in enumerate(fp):
        lyrics.append(line)
    fp.close()
    
    """
    for lyric in sims:
        if lyric[1]>0.7:
            print("\n相似新聞：",  lyrics[lyric[0]])
            print("相似度：",  lyric[1])
    """

    
    a=[]
    for i in range(0,5):
        a.append(sims[:5][i][1])
        
    news_ID=[]
    for i in range(5):
        news_ID.append(int(sims[:5][i][0])+2)
    
    return sims,msg,news_ID

def check_topic(news_ID):
    import csv
    label=[]
    jieba.load_userdict(FileAddress+'dcard_total\\userDict.txt')
    
    # 開啟 CSV 檔案
    with open(FileAddress+'dcard_total\\process_allData.csv', newline='',encoding = 'utf-8-sig') as csvFile:
    
      # 3.轉成一個 dictionary, 讀取 CSV 檔內容，將每一列轉成字典
      rows = csv.DictReader(csvFile)
    
      # 迴圈輸出 指定欄位
      for row in rows:
            #title.append(row['title'])
            #context.append(row['context'])
            #href.append(row['href'])
            #hashtag.append(row['hashtag'])
            label.append(row['label'])
    
    a=0
    b=0
    c=0
    for i in range(len(news_ID)):
        if label[news_ID[i]]=='0':
            a = a+1
        elif label[news_ID[i]]=='1':
            b = b+1
        else:
            c = c+1
    
    print("工作類別數量:"+str(a))
    print("感情類別數量:"+str(b))
    print("新生季類別數量:"+str(c))
            
    if a>b and a>c:
        topic = '工作'
        print("判斷領域為「工作」")
    elif b>a and b>c:
        topic = '感情'
        print("判斷領域為「感情」")
    elif c>a and c>b:
        topic = '新生季'
        print("判斷領域為「新生季」")
    
    return topic
    
def test(uid,user_talk):
    cursor.execute('SELECT * FROM "UserTest" WHERE uid = %(name1)s' , {'name1': uid})
    eventA = ""
    for row in cursor:
        eventA = eventA + row['event']
    eventA = MessageEvent(eventA).mode
    #print(eventA)
    print(eventA['message'])
    

    #line_bot_api.push_message(uid, TextSendMessage(text='正在分析話題子領域中...'))
    
@app.route('/tk', methods=['post','get'])
def tk():
    #https://8c087f7c25db.ngrok.io/tk?uid=U98f85fa7160ccbf0bdf25fc61f13edcf&b=3&c=TEST
    uid = request.args.get('uid')
    b = request.args.get('b')
    c = request.args.get('c')
    d = request.args.get('d')
    e = request.args.get('e')
    print(b)
    print(c)
    line_bot_api.push_message(uid, TextSendMessage(text='測量時間:'+str(e)))
    line_bot_api.push_message(uid, TextSendMessage(text='您的量表分數為:'+str(c)))
    line_bot_api.push_message(uid, TextSendMessage(text='分數範圍為:'+d))
    print(uid)
    #return jsonify({'t': [uid]})
    return redirect("http://line.me/ti/p/"+Bot_Basic_id, code=302)

@app.route('/refun', methods=['post','get'])
def refun():
    uid = request.args.get('uid')
    line_bot_api.push_message(uid, TextSendMessage(text="感謝您的填報，輔導師回覆後會立即通知您。"))
    #return jsonify({'t': [uid]})
    return redirect("http://line.me/ti/p/"+Bot_Basic_id, code=302)

@app.route('/long', methods=['post','get'])
def long():
    #return jsonify({'t': [uid]})
    ID = request.args.get('id')
    Context = request.args.get('context')
    Time = request.args.get('time')
    SID = request.args.get('sid')
    
    cursor.execute('SELECT * FROM Student WHERE Student_Id = %(name1)s' , {'name1': ID})
    
    uid=""
    for row in cursor:
        uid = uid + row['Student_userID']
        
        
        
    cursor.execute('SELECT * FROM Socialworker WHERE Socialworker_Id = %(name1)s' , {'name1': SID})
    
    name=""
    Socialworker_account = ""
    Socialworker_password = ""
    for row in cursor:
        name = name + row['Socialworker_name']
        Socialworker_account = Socialworker_account + row['Socialworker_account']
        Socialworker_password = Socialworker_password + row['Socialworker_password']
       
    line_bot_api.push_message(uid, TextSendMessage(text="輔導人員「"+name+"」回覆了您的回報。"))  
    line_bot_api.push_message(uid, TextSendMessage(text="您於「"+Time+"」所回報的日誌得到回覆內容如下:\n"+Context)) 
           
    return redirect(LineLogin+"/Socialworker/ShowStudent?acc="+Socialworker_account+"&pwd="+Socialworker_password, code=302)

def recommend(uid,topic):
    if topic=='工作':
        topic = 0
    elif topic=='感情':
        topic = 1
    else:
        topic = 2
        
    cursor.execute('SELECT * FROM ShortFeedback WHERE Assist = %(name1)s' , {'name1': topic})
    S_ID=[]
    for row in cursor:
        if row['Socialworker_Id'] not in S_ID:
            S_ID.append(row['Socialworker_Id'])
    
    cursor.execute('SELECT * FROM ShortFeedback')
    idf_on = 0
    for row in cursor:
        idf_on = idf_on + 1
    
    for i in range(len(S_ID)):
        tf_on = 0
        tf_under = 0
        final_tfidf = 0
        final_S_ID = 0
    
        cursor.execute('SELECT * FROM ShortFeedback WHERE Socialworker_Id = %(name1)s AND Assist = %(name2)s AND Judgment_Score = 1' , {'name1': S_ID[i] , 'name2': topic})
        for row in cursor:
            tf_on = tf_on + 1
        
        cursor.execute('SELECT * FROM ShortFeedback WHERE Socialworker_Id = %(name1)s AND Assist = %(name2)s' , {'name1': S_ID[i] , 'name2': topic})
        for row in cursor:
            tf_under = tf_under + 1
        
        cursor.execute('SELECT * FROM ShortFeedback WHERE Socialworker_Id = %(name1)s' , {'name1': S_ID[i]})
        idf_under = 0
        for row in cursor:
            idf_under = idf_under + 1
        
        cursor.execute('SELECT * FROM ShortFeedback WHERE Assist = %(name1)s' , {'name1': topic})
        tf1_under = 0
        for row in cursor:
            tf1_under = tf1_under + 1
        
        tf1 = float(tf_under / tf1_under)
        idf1 = float('%.5f' % ((math.log(idf_on / idf_under)/math.log(10))))
        
        tf2 = float(tf_on / tf_under)
        idf2 = float('%.5f' % ((math.log(idf_on / idf_under)/math.log(10))))
        #print(tf,idf)
        tfidf1 = tf1 * idf1
        tfidf2 = tf2 * idf2
        print(tfidf1,tfidf2)
        current_tfidf = tfidf1 * tfidf2
        
        if current_tfidf > final_tfidf:
            final_tfidf = current_tfidf
            final_S_ID = S_ID[i]
        
    print(final_S_ID,final_tfidf)

    return final_S_ID,round(final_tfidf,5)

@app.route('/shortbeek', methods=['post','get']) 
def shortbeek():
    uid = request.args.get('uid')
    short = request.args.get('short')
    
    if short=='1':
        line_bot_api.push_message(uid, TextSendMessage(text="感謝您的填報，讓我們的系統可以更加完善。"))
    else:
        line_bot_api.push_message(uid, TextSendMessage(text="您在這次的服務中已經填報過了。"))
    #return jsonify({'t': [uid]})
    return redirect("http://line.me/ti/p/"+Bot_Basic_id, code=302)

@handler.add(FollowEvent)
def handle_follow(event):
    print(event)
    # do something

if __name__ == "__main__":
    app.run()