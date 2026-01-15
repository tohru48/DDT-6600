package ddt.view.caddyII.reader
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatNamePanel;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import im.IMController;
   import im.IMView;
   
   public class AwardsItem extends Sprite implements Disposeable
   {
      
      public static const GOODSCLICK:String = "goods_click_awardsItem";
      
      private var _contentField:TextField;
      
      private var _info:AwardsInfo;
      
      private var _nameTip:ChatNamePanel;
      
      public function AwardsItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._contentField = ComponentFactory.Instance.creatCustomObject("caddy.readAward.ContentField");
         this._contentField.defaultTextFormat = ComponentFactory.Instance.model.getSet("caddy.readAward.ContentFieldTF");
         this._contentField.filters = [ComponentFactory.Instance.model.getSet("timebox.GF_22")];
         this._contentField.styleSheet = ChatFormats.styleSheet;
         addChild(this._contentField);
      }
      
      private function initEvents() : void
      {
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function removeEvents() : void
      {
         this._contentField.removeEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function createMessage() : void
      {
         var buff:String = null;
         var goods:String = null;
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.TemplateId);
         var data:ChatData = new ChatData();
         var dian:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsPoint") + " ";
         var gong:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsGong");
         var name:String = " <font color=\'#ffffff\'>" + ChatFormats.creatBracketsTag("[" + this._info.name + "] ",ChatFormats.CLICK_USERNAME) + "</font>";
         var have:String = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
         var card:String = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.card");
         if(CaddyModel.instance.type == CaddyModel.CARD_TYPE || CaddyModel.instance.type == CaddyModel.MY_CARDBOX || CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX)
         {
            if(this._info.zoneID == 0)
            {
               data.htmlMessage = " <font color=\'#ffad1b\'>" + dian + gong + have + this._info.name;
               if(this._info.channel == 1)
               {
                  data.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.jin") + card;
               }
               else if(this._info.channel == 2)
               {
                  data.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.yin") + card;
               }
               else if(this._info.channel == 4)
               {
                  data.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.baijin") + card;
               }
               else
               {
                  data.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.tong") + card;
               }
               data.htmlMessage += "</font>";
            }
            else
            {
               data.htmlMessage = dian + have + "(" + this._info.zoneID + ")" + LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText1");
            }
         }
         else
         {
            if(CaddyModel.instance.type == CaddyModel.BEAD_TYPE)
            {
               if(int(itemInfo.Property2) == 1)
               {
                  buff = LanguageMgr.GetTranslation("tank.view.award.Attack");
               }
               else if(int(itemInfo.Property2) == 2)
               {
                  buff = LanguageMgr.GetTranslation("tank.view.award.Defense");
               }
               else
               {
                  buff = LanguageMgr.GetTranslation("tank.view.award.Attribute");
               }
            }
            else
            {
               buff = CaddyModel.instance.AwardsBuff;
            }
            goods = " " + ChatFormats.creatGoodTag("[" + itemInfo.Name + "]",ChatFormats.CLICK_GOODS,itemInfo.TemplateID,itemInfo.Quality,true,data);
            if(this._info.isLong)
            {
               data.htmlMessage = dian + gong + LanguageMgr.GetTranslation("tank.view.award.Player") + name + buff + goods + "x" + this._info.count + "(" + this._info.zone + ")";
            }
            else
            {
               data.htmlMessage = dian + gong + name + buff + goods + "x" + this._info.count;
            }
         }
         this.setChats(data);
      }
      
      private function setChats(chatData:ChatData) : void
      {
         var resultHtmlText:String = "";
         resultHtmlText += Helpers.deCodeString(chatData.htmlMessage);
         this._contentField.htmlText = "<a>" + resultHtmlText + "</a>";
      }
      
      private function __onTextClicked(event:TextEvent) : void
      {
         var tipPos:Point = null;
         var props:Array = null;
         var selfZone:int = 0;
         var other:int = 0;
         var pattern:RegExp = null;
         var str:String = null;
         var result:Object = null;
         var newChannel:String = null;
         var startIdx:int = 0;
         var endIdx:int = 0;
         var pos:Point = null;
         var legalIdx:int = 0;
         var rect:Rectangle = null;
         var nameTipPos:Point = null;
         var itemInfo:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         var data:Object = {};
         var allProperties:Array = event.text.split("|");
         for(var i:int = 0; i < allProperties.length; i++)
         {
            if(Boolean(allProperties[i].indexOf(":")))
            {
               props = allProperties[i].split(":");
               data[props[0]] = props[1];
            }
         }
         if(int(data.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = this._info.zoneID;
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,data.tagname));
            }
            else if(IMController.Instance.isFriend(String(data.tagname)))
            {
               IMEManager.enable();
               ChatManager.Instance.output.functionEnabled = true;
               ChatManager.Instance.privateChatTo(data.tagname);
            }
            else
            {
               if(this._nameTip == null)
               {
                  this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
               }
               pattern = new RegExp(String(data.tagname),"g");
               str = this._contentField.text;
               result = pattern.exec(str);
               while(result != null)
               {
                  startIdx = int(result.index);
                  endIdx = startIdx + String(data.tagname).length;
                  pos = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
                  legalIdx = this._contentField.getCharIndexAtPoint(pos.x,pos.y);
                  if(legalIdx >= startIdx && legalIdx <= endIdx)
                  {
                     this._contentField.setSelection(startIdx,endIdx);
                     rect = this._contentField.getCharBoundaries(endIdx);
                     nameTipPos = this._contentField.localToGlobal(new Point(rect.x,rect.y));
                     this._nameTip.x = nameTipPos.x + rect.width;
                     this._nameTip.y = nameTipPos.y - this._nameTip.getHeight;
                     break;
                  }
                  result = pattern.exec(str);
               }
               ChatManager.Instance.privateChatTo(data.tagname);
               this._nameTip.playerName = String(data.tagname);
               newChannel = ChatFormats.Channel_Set[int(data.channel)];
               if(newChannel == "null" || newChannel == null)
               {
                  this._nameTip.channel = " ";
               }
               else
               {
                  this._nameTip.channel = newChannel;
               }
               this._nameTip.message = String(data.message);
               this._nameTip.setVisible = true;
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_GOODS)
         {
            tipPos = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            itemInfo = ItemManager.Instance.getTemplateById(data.templeteIDorItemID);
            itemInfo.BindType = data.isBind == "true" ? 0 : 1;
            this._showLinkGoodsInfo(itemInfo);
         }
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      private function _showLinkGoodsInfo(info:ItemTemplateInfo) : void
      {
         var tipPos:Point = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
         var event:CaddyEvent = new CaddyEvent(AwardsItem.GOODSCLICK);
         event.itemTemplateInfo = info;
         event.point = tipPos;
         dispatchEvent(event);
      }
      
      public function set info(itemInfo:AwardsInfo) : void
      {
         this._info = itemInfo;
         this.createMessage();
      }
      
      public function get info() : AwardsInfo
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this._contentField.textHeight + 5;
      }
      
      public function setTextFieldWidth(width:int) : void
      {
         this._contentField.width = width;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._info = null;
         if(Boolean(this._contentField))
         {
            ObjectUtils.disposeObject(this._contentField);
         }
         this._contentField = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

