package ddt.view.chat
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.Helpers;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import newTitle.NewTitleManager;
   import road7th.utils.StringHelper;
   
   public class ChatFormats
   {
      
      public static var hasYaHei:Boolean;
      
      private static var _formats:Dictionary;
      
      private static var _styleSheet:StyleSheet;
      
      private static var _gameStyleSheet:StyleSheet;
      
      private static var _styleSheetData:Dictionary;
      
      private static var _chatData:ChatData;
      
      public static const CHAT_COLORS:Array = [2358015,16751360,16740090,4970320,8423901,16777215,16776960,16776960,16776960,16777215,5035345,16724787,16777011,16777215,16711846,16711680,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215];
      
      public static const BIG_BUGGLE_COLOR:Array = [11408476,16635586,15987916,16514727,12053748];
      
      public static const BIG_BUGGLE_TYPE_STRING:Array = ["Çocuksu Aşk","Doğum Günü Kutsaması","Gerçek Kalp","Çılgın Bomba Adam","Ezici"];
      
      public static const TITLE_COLORS:Array = [11423743,54015,16731330,16743936];
      
      public static const CLICK_CHANNEL:int = 0;
      
      public static const CLICK_GOODS:int = 2;
      
      public static const CLICK_USERNAME:int = 1;
      
      public static const CLICK_DIFF_ZONE:int = 4;
      
      public static const CLICK_INVENTORY_GOODS:int = 3;
      
      public static const CLICK_EFFORT:int = 100;
      
      public static const CLICK_FASTINVITE:int = 101;
      
      public static const CLICK_ENTERHUIKUI_ACTIVITY:int = 102;
      
      public static const CLICK_INVITE_OLD_PLAYER:int = 103;
      
      public static const CLICK_LANTERN_BEGIN:int = 104;
      
      public static const CLICK_TIME_GIFTPACK:int = 105;
      
      public static const CLICK_NO_TIP:int = 106;
      
      public static const CLICK_SIMPLE_TOLINK:int = 99;
      
      public static const CLICK_FASTAUCTION:int = 107;
      
      public static const AVATAR_COLLECTION_TIP:int = 108;
      
      public static var CLICK_ACT_TIP:int = 1000;
      
      public static const NEWYEARFOOD:int = 888;
      
      public static const HORESRACE:int = 889;
      
      public static const CARD_CAO:int = 5;
      
      public static const CLICK_CARD_INFO:int = 6;
      
      public static const Channel_Set:Object = {
         0:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
         1:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.small"),
         2:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private"),
         3:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia"),
         4:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream"),
         5:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         9:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         12:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.cross"),
         13:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         15:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.crossBugle"),
         25:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current")
      };
      
      private static const unacceptableChar:Array = ["\"","\'","<",">"];
      
      private static const IN_GAME:uint = 1;
      
      private static const NORMAL:uint = 0;
      
      public function ChatFormats()
      {
         super();
      }
      
      public static function formatChatStyle(data:ChatData) : void
      {
         if(data.htmlMessage != "")
         {
            return;
         }
         data.msg = StringHelper.rePlaceHtmlTextField(data.msg);
         var channelTag:Array = getTagsByChannel(data);
         var channelClickTag:String = creatChannelTag(data.channel,data.bigBuggleType,data);
         var senderClickTag:String = creatSenderTag(data);
         var contentClickTag:String = creatContentTag(data);
         data.htmlMessage = channelTag[0] + channelClickTag + senderClickTag + contentClickTag + channelTag[1] + "<BR>";
      }
      
      public static function formatComplexChatStyle(data:ChatData) : void
      {
         if(data.htmlMessage != "")
         {
            return;
         }
         data.msg = StringHelper.rePlaceHtmlTextField(data.msg);
         var channelTag:Array = getTagsByChannel(data);
         var contentClickTag:String = creatContentTag(data);
         var contentArray:Array = contentClickTag.split("@@");
         for(var i:int = 0; i < contentArray.length; i++)
         {
            data.htmlMessage += channelTag[2 * i] + contentArray[i] + channelTag[2 * i + 1];
         }
         data.htmlMessage += "<BR>";
      }
      
      public static function creatBracketsTag(source:String, clickType:int, args:Array = null, data:ChatData = null) : String
      {
         var tmp:Array = null;
         var index:int = 0;
         var namesRec:RegExp = null;
         var srr:Array = null;
         var argString:String = null;
         var i:int = 0;
         var tagname:String = null;
         if(clickType == CLICK_FASTINVITE)
         {
            source = "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "|senderId:" + data.senderID + "|roomId:" + data.roomId + "|password:" + data.password + "\">" + source + "</a>" + "</u>";
         }
         if(clickType == NEWYEARFOOD)
         {
            if(data.senderID != PlayerManager.Instance.Self.ID)
            {
               source = "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "|senderId:" + data.senderID + "|roomId:" + data.roomId + "|password:" + data.password + "\">" + source + "</a>" + "</u>";
            }
            else
            {
               source = "【" + data.sender + "】" + LanguageMgr.GetTranslation("tank.newyearFood.view.bugleTxt");
            }
         }
         if(clickType == HORESRACE)
         {
            source = source.split("|")[0] + "@@" + "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "\">" + source.split("|")[1] + "</a>" + "</u>";
         }
         if(clickType == CLICK_FASTAUCTION)
         {
            source = "【" + data.sender + "】" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.bugleTxt",data.price,data.mouthful,data.auctionGoodName,data.itemCount);
            if(data.playerCharacterID != PlayerManager.Instance.Self.ID)
            {
               source += "，<u><a href=\"event:" + "clicktype:" + clickType.toString() + "|senderId:" + data.senderID + "|nickName:" + data.playerName + "|price:" + data.price + "|mouthful:" + data.mouthful + "|auctionID:" + data.auctionID + "\">" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.clickToBuy") + "</a></u>";
            }
         }
         else if(clickType == CLICK_ENTERHUIKUI_ACTIVITY || clickType == AVATAR_COLLECTION_TIP || clickType > CLICK_ACT_TIP)
         {
            source = source.split("|")[0] + "@@" + "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "|rewardType:" + data.actId + "\">" + source.split("|")[1] + "</a>" + "</u>";
         }
         else if(clickType == CLICK_INVITE_OLD_PLAYER)
         {
            tmp = source.split("|");
            source = tmp[0];
            if(data.receiver != PlayerManager.Instance.Self.NickName)
            {
               source = source.replace("[" + data.receiver + "]","<a href=\"event:clicktype:1|tagname:" + data.receiver + "|zoneID:-1\">" + Helpers.enCodeString("[" + data.receiver + "]") + "</a>");
            }
            if(tmp.length > 1)
            {
               source += "@@" + "<u>" + "<a href=\"event:" + "clicktype:" + clickType + "|tagname:" + data.receiver + "\">" + tmp[1] + "</a>" + "</u>";
            }
            else
            {
               source += "@@";
            }
         }
         else if(clickType == CLICK_LANTERN_BEGIN)
         {
            index = source.indexOf(".") + 1;
            source = source.slice(0,index) + "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "\">" + source.slice(index,source.length) + "</a></u>";
         }
         else if(clickType == CLICK_NO_TIP)
         {
            source += "<u>" + "<a href=\"event:" + "clicktype:" + clickType.toString() + "\"><FONT  COLOR=\'#8dff1e\'>" + LanguageMgr.GetTranslation("notAlertAgain") + "</FONT></a></u>";
         }
         else
         {
            namesRec = /\[([^\]]*)]*/g;
            srr = source.match(namesRec);
            argString = "";
            if(Boolean(args))
            {
               argString = args.join("|");
            }
            for(i = 0; i < srr.length; i++)
            {
               tagname = srr[i].substr(1,srr[i].length - 2);
               if(clickType != CLICK_USERNAME || tagname != PlayerManager.Instance.Self.NickName || tagname == PlayerManager.Instance.Self.NickName && data && data.zoneID != PlayerManager.Instance.Self.ZoneID)
               {
                  if(Boolean(data))
                  {
                     argString += "channel:" + data.channel;
                  }
                  if(Boolean(data) && data.channel == ChatInputView.CROSS_NOTICE)
                  {
                     source = source.replace("[" + tagname + "]","<a href=\"event:" + "clicktype:" + clickType.toString() + "|tagname:" + tagname + "|zoneID:" + String(data.zoneID) + "|zoneName:" + String(data.zoneName) + "|" + argString + "\">" + Helpers.enCodeString("[" + tagname + "]") + "</a>");
                  }
                  else if(tagname == Channel_Set[12])
                  {
                     source = "";
                  }
                  else if(Boolean(data))
                  {
                     source = source.replace("[" + tagname + "]","<a href=\"event:" + "clicktype:" + clickType.toString() + "|tagname:" + tagname + "|zoneID:" + String(data.zoneID) + "|zoneName:" + String(data.zoneName) + "|" + argString + "\">" + Helpers.enCodeString("[" + tagname + "]") + "</a>");
                  }
                  else
                  {
                     source = source.replace("[" + tagname + "]","<a href=\"event:" + "clicktype:" + clickType.toString() + "|tagname:" + tagname + "|" + argString + "\">" + Helpers.enCodeString("[" + tagname + "]") + "</a>");
                  }
               }
               else
               {
                  source = source.replace("[" + tagname + "]",Helpers.enCodeString("[" + tagname + "]"));
               }
            }
         }
         return source;
      }
      
      public static function creatGoodTag(source:String, clickType:int, templeteIDorItemID:int, quality:int, isBind:Boolean, data:ChatData = null, key:String = "", $type:int = -1) : String
      {
         var tagname:String = null;
         var qualityTag:Array = getTagsByQuality(quality);
         var namesRec:RegExp = /\[([^\]]*)]*/g;
         var srr:Array = source.match(namesRec);
         var zoneID:int = data.zoneID;
         for(var i:int = 0; i < srr.length; i++)
         {
            tagname = srr[i].substr(1,srr[i].length - 2);
            source = source.replace("[" + tagname + "]",qualityTag[0] + "<a href=\"event:" + "clicktype:" + clickType.toString() + "|type:" + $type + "|tagname:" + tagname + "|isBind:" + isBind.toString() + "|templeteIDorItemID:" + templeteIDorItemID.toString() + "|key:" + key + "|zoneID:" + zoneID + "\">" + Helpers.enCodeString("[" + tagname + "]") + "</a>" + qualityTag[1]);
         }
         return source;
      }
      
      public static function getColorByChannel(channel:int) : int
      {
         return CHAT_COLORS[channel];
      }
      
      public static function getColorByBigBuggleType(type:int) : int
      {
         return BIG_BUGGLE_COLOR[type];
      }
      
      public static function getTagsByChannel(data:ChatData) : Array
      {
         var ctArray:Array = null;
         var i:int = 0;
         if(data.channel != ChatInputView.COMPLEX_NOTICE)
         {
            return ["<CT" + data.channel.toString() + ">","</CT" + data.channel.toString() + ">"];
         }
         ctArray = [];
         for(i = 0; i < data.childChannelArr.length; i++)
         {
            ctArray.push("<CT" + data.childChannelArr[i].toString() + ">");
            ctArray.push("</CT" + data.childChannelArr[i].toString() + ">");
         }
         return ctArray;
      }
      
      public static function getTagsByQuality(quality:int) : Array
      {
         return ["<QT" + quality.toString() + ">","</QT" + quality.toString() + ">"];
      }
      
      public static function getTextFormatByChannel(channelid:int) : TextFormat
      {
         return _formats[channelid];
      }
      
      public static function setup() : void
      {
         setupFormat();
         setupStyle();
      }
      
      public static function get styleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      public static function get gameStyleSheet() : StyleSheet
      {
         return _gameStyleSheet;
      }
      
      private static function getBigBuggleTypeString(type:int) : String
      {
         return BIG_BUGGLE_TYPE_STRING[type - 1];
      }
      
      private static function creatChannelTag(channel:int, bigBuggleType:int = 0, chdata:ChatData = null) : String
      {
         var result:String = "";
         if(Boolean(Channel_Set[channel]) && channel != ChatInputView.PRIVATE)
         {
            if(bigBuggleType == 0)
            {
               if(channel != 15)
               {
                  result = creatBracketsTag("[" + Channel_Set[channel] + "]",CLICK_CHANNEL,["channel:" + channel.toString()]);
               }
               else
               {
                  result = creatBracketsTag("[" + Channel_Set[channel] + "]" + "&lt;" + chdata.zoneName + "&gt;",CLICK_CHANNEL,["channel:" + channel.toString()]);
               }
            }
            else
            {
               result = "[" + getBigBuggleTypeString(bigBuggleType) + Channel_Set[channel] + "]";
            }
         }
         return result;
      }
      
      private static function creatContentTag(data:ChatData) : String
      {
         var i:Object = null;
         var ItemID:Number = NaN;
         var TemplateID:int = 0;
         var info:ItemTemplateInfo = null;
         var key:String = null;
         var index:uint = 0;
         var tag:String = null;
         var result:String = data.msg;
         var offset:uint = 0;
         if(Boolean(data.link))
         {
            data.link.sortOn("index");
            for each(i in data.link)
            {
               ItemID = Number(i.ItemID);
               TemplateID = int(i.TemplateID);
               info = ItemManager.Instance.getTemplateById(TemplateID);
               key = i.key;
               index = i.index + offset;
               if(ItemID <= 0)
               {
                  if(info.CategoryID == 26)
                  {
                     tag = creatGoodTag("[" + info.Name + "]",CLICK_CARD_INFO,ItemID,info.Quality,true,data,key);
                  }
                  else
                  {
                     tag = creatGoodTag("[" + info.Name + "]",CLICK_GOODS,info.TemplateID,info.Quality,true,data);
                  }
               }
               else if(info == null)
               {
                  if(TemplateID == 0)
                  {
                     tag = creatGoodTag("[" + LanguageMgr.GetTranslation("tank.view.card.chatLinkText0") + "]",CARD_CAO,ItemID,2,true,data,key);
                  }
                  else
                  {
                     tag = creatGoodTag("[" + String(TemplateID) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText") + "]",CARD_CAO,ItemID,2,true,data,key);
                  }
               }
               else
               {
                  tag = creatGoodTag("[" + info.Name + "]",CLICK_INVENTORY_GOODS,ItemID,info.Quality,true,data,key);
               }
               result = result.substring(0,index) + tag + result.substring(index);
               offset += tag.length;
            }
         }
         if(data.type == CLICK_SIMPLE_TOLINK)
         {
            return StringHelper.reverseHtmlTextField(data.msg);
         }
         if(data.type == CLICK_EFFORT)
         {
            return creatBracketsTag(result,CLICK_EFFORT,null,data);
         }
         if(data.type == CLICK_LANTERN_BEGIN)
         {
            return creatBracketsTag(result,data.type,null,data);
         }
         if(data.type == CLICK_FASTINVITE)
         {
            return creatBracketsTag(result,CLICK_FASTINVITE,null,data);
         }
         if(data.type == NEWYEARFOOD)
         {
            return creatBracketsTag(result,NEWYEARFOOD,null,data);
         }
         if(data.type == HORESRACE)
         {
            return creatBracketsTag(result,HORESRACE,null,data);
         }
         if(data.type == CLICK_FASTAUCTION)
         {
            return creatBracketsTag(result,CLICK_FASTAUCTION,null,data);
         }
         if(data.type == CLICK_ENTERHUIKUI_ACTIVITY)
         {
            return creatBracketsTag(result,CLICK_ENTERHUIKUI_ACTIVITY,null,data);
         }
         if(data.type == CLICK_ENTERHUIKUI_ACTIVITY || data.type == AVATAR_COLLECTION_TIP)
         {
            return creatBracketsTag(result,data.type,null,data);
         }
         if(data.type == AVATAR_COLLECTION_TIP || data.type > CLICK_ACT_TIP)
         {
            return creatBracketsTag(result,data.type,null,data);
         }
         if(data.type == CLICK_INVITE_OLD_PLAYER)
         {
            return creatBracketsTag(result,CLICK_INVITE_OLD_PLAYER,null,data);
         }
         if(data.type == CLICK_LANTERN_BEGIN || data.type == CLICK_TIME_GIFTPACK)
         {
            return creatBracketsTag(result,data.type,null,data);
         }
         if(data.type == CLICK_NO_TIP)
         {
            return creatBracketsTag(result,data.type,null,data);
         }
         if(data.channel <= 5)
         {
            if(data.type == CLICK_USERNAME || data.type == CLICK_DIFF_ZONE)
            {
               return creatBracketsTag(result,CLICK_USERNAME,null,data);
            }
            return result;
         }
         return creatBracketsTag(result,CLICK_USERNAME,null,data);
      }
      
      private static function creatSenderTag(data:ChatData) : String
      {
         var result:String = "";
         if(data.sender == "")
         {
            return result;
         }
         if(data.channel == ChatInputView.PRIVATE)
         {
            if(data.zoneID <= 0 || !data.zoneName)
            {
               if(data.sender == PlayerManager.Instance.Self.NickName)
               {
                  result = creatBracketsTag(LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "[" + data.receiver + "]: ",CLICK_USERNAME,null,data);
               }
               else
               {
                  result = creatBracketsTag("[" + data.sender + "]" + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou"),CLICK_USERNAME,null,data);
               }
            }
            else if(data.sender == PlayerManager.Instance.Self.NickName && data.senderID == PlayerManager.Instance.Self.ID)
            {
               result = creatBracketsTag(LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "&lt;" + data.zoneName + "&gt;" + "[" + data.receiver + "]: ",CLICK_USERNAME,null,data);
            }
            else
            {
               result = creatBracketsTag("&lt;" + data.zoneName + "&gt;" + "[" + data.sender + "]" + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou"),CLICK_USERNAME,null,data);
            }
         }
         else if(data.zoneID == PlayerManager.Instance.Self.ZoneID || data.zoneID <= 0)
         {
            result = creatBracketsTag("[" + data.sender + "]: ",CLICK_USERNAME,null,data);
         }
         else
         {
            result = creatBracketsTag("[" + data.sender + "]: ",CLICK_DIFF_ZONE,null,data);
         }
         return result;
      }
      
      public static function replaceUnacceptableChar(source:String) : String
      {
         for(var i:int = 0; i < unacceptableChar.length; i++)
         {
            source = source.replace(unacceptableChar[i],"");
         }
         return source;
      }
      
      private static function creatStyleObject(color:int, type:uint = 0) : Object
      {
         var styleObject:Object = null;
         var fontSize:String = null;
         switch(type)
         {
            case NORMAL:
               fontSize = "12";
               break;
            case IN_GAME:
               fontSize = "12";
         }
         return {
            "color":"#" + color.toString(16),
            "leading":"4",
            "fontFamily":"Arial",
            "display":"inline",
            "fontSize":fontSize
         };
      }
      
      private static function setupFormat() : void
      {
         var format:TextFormat = null;
         _formats = new Dictionary();
         for(var i:int = 0; i < CHAT_COLORS.length; i++)
         {
            format = new TextFormat();
            format.font = "Arial";
            format.size = 13;
            format.color = CHAT_COLORS[i];
            _formats[i] = format;
         }
      }
      
      private static function setupStyle() : void
      {
         var ct:Object = null;
         var gct:Object = null;
         var ct1:Object = null;
         var gct1:Object = null;
         var ct2:Object = null;
         var gct2:Object = null;
         var ctID:String = null;
         _styleSheetData = new Dictionary();
         _styleSheet = new StyleSheet();
         _gameStyleSheet = new StyleSheet();
         for(var i:int = 0; i < QualityType.QUALITY_COLOR.length; i++)
         {
            ct = creatStyleObject(QualityType.QUALITY_COLOR[i]);
            gct = creatStyleObject(QualityType.QUALITY_COLOR[i],1);
            _styleSheetData["QT" + i] = ct;
            _styleSheet.setStyle("QT" + i,ct);
            _gameStyleSheet.setStyle("QT" + i,gct);
         }
         for(var j:int = 0; j <= CHAT_COLORS.length; j++)
         {
            ct1 = creatStyleObject(CHAT_COLORS[j]);
            gct1 = creatStyleObject(CHAT_COLORS[j],1);
            _styleSheetData["CT" + String(j)] = ct1;
            _styleSheet.setStyle("CT" + String(j),ct1);
            _gameStyleSheet.setStyle("CT" + String(j),gct1);
         }
         for(var k:int = 0; k <= TITLE_COLORS.length; k++)
         {
            ct2 = creatStyleObject(TITLE_COLORS[k]);
            gct2 = creatStyleObject(TITLE_COLORS[k],1);
            ctID = String(NewTitleManager.FIRST_TITLEID + k);
            _styleSheetData["CT" + ctID] = ct2;
            _styleSheet.setStyle("CT" + ctID,ct2);
            _gameStyleSheet.setStyle("CT" + ctID,gct2);
         }
      }
   }
}

