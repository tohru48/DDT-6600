package game.view.card
{
   import bagAndInfo.cell.BagCell;
   import beadSystem.model.BeadInfo;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import game.GameManager;
   import game.model.Player;
   import room.RoomManager;
   import room.model.RoomInfo;
   import vip.VipController;
   
   public class LuckyCard extends Sprite implements Disposeable
   {
      
      public static const AFTER_GAME_CARD:int = 0;
      
      public static const WITHIN_GAME_CARD:int = 1;
      
      public var allowClick:Boolean;
      
      public var msg:String;
      
      public var isPayed:Boolean;
      
      private var _idx:int;
      
      private var _cardType:int;
      
      private var _luckyCardMc:MovieClip;
      
      private var _info:Player;
      
      private var _templateID:int;
      
      private var _count:int;
      
      private var _isVip:Boolean;
      
      private var _nickName:FilterFrameText;
      
      private var _itemName:FilterFrameText;
      
      private var _vipNameTxt:GradientText;
      
      private var _itemCell:BagCell;
      
      private var _itemGoldTxt:Bitmap;
      
      private var _itemBitmap:Bitmap;
      
      private var _goldTxt:FilterFrameText;
      
      private var _overShape:Sprite;
      
      private var _overEffect:GlowFilter;
      
      private var _overEffectPoint:Point;
      
      private var _payAlert:BaseAlerFrame;
      
      private var _NickName:String;
      
      private var tPrice:int;
      
      public function LuckyCard(idx:int, cardType:int)
      {
         super();
         this._idx = idx;
         this._cardType = cardType;
         this.init();
      }
      
      private function init() : void
      {
         buttonMode = true;
         this._overShape = new Sprite();
         this._overShape.graphics.lineStyle(1.8,16777215);
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._overShape.graphics.drawRoundRect(1,2,109,148,15,15);
         }
         else
         {
            this._overShape.graphics.drawRoundRect(4,2,100,148,15,15);
         }
         this._overEffect = ComponentFactory.Instance.model.getSet("takeoutCard.LuckyCardOverFilter");
         this._overShape.filters = [this._overEffect];
         if(GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._luckyCardMc = ComponentFactory.Instance.creat("fightFootballTime.LuckyCard");
         }
         else
         {
            this._luckyCardMc = ComponentFactory.Instance.creat("asset.takeoutCard.LuckyCard");
         }
         this._luckyCardMc.addEventListener(Event.ENTER_FRAME,this.__checkMovie);
         addChild(this._luckyCardMc);
      }
      
      private function __checkMovie(event:Event) : void
      {
         if(this._luckyCardMc.numChildren == 5)
         {
            if(this._luckyCardMc.cardMc.totalFrames == 5)
            {
               this._luckyCardMc.removeEventListener(Event.ENTER_FRAME,this.__checkMovie);
               this._luckyCardMc.cardMc.addFrameScript(this._luckyCardMc.cardMc.totalFrames - 1,this.showResult);
            }
         }
      }
      
      public function set enabled(value:Boolean) : void
      {
         buttonMode = value;
         if(value)
         {
            this._overEffectPoint = new Point(y,y - 14);
            addEventListener(MouseEvent.CLICK,this.__onClick);
            addEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            addEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__onClick);
            removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
            this.__onRollOut();
         }
      }
      
      private function __onRollOver(event:MouseEvent = null) : void
      {
         if(!this._overEffectPoint)
         {
            return;
         }
         addChild(this._overShape);
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.3,{
            "y":this._overEffectPoint.y,
            "ease":Quint.easeOut
         });
      }
      
      private function __onRollOut(event:MouseEvent = null) : void
      {
         if(!this._overEffectPoint)
         {
            return;
         }
         if(contains(this._overShape))
         {
            removeChild(this._overShape);
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.3,{
            "y":this._overEffectPoint.x,
            "ease":Quint.easeOut
         });
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
         if(this.allowClick)
         {
            SoundManager.instance.play("008");
            if(this.isPayed)
            {
               if(GameManager.Instance.Current.selfGamePlayer.hasGardGet)
               {
                  GameInSocketOut.sendPaymentTakeCard(this._idx);
                  GameManager.Instance.Current.selfGamePlayer.hasGardGet = false;
                  this.enabled = false;
               }
               else
               {
                  this.payAlert();
               }
            }
            else
            {
               if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
               {
                  GameInSocketOut.sendBossTakeOut(this._idx);
               }
               else if(this._cardType == WITHIN_GAME_CARD)
               {
                  GameInSocketOut.sendBossTakeOut(this._idx);
               }
               else if(GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
               {
                  GameInSocketOut.sendFightFootballTimeTakeOut(this._idx);
               }
               else
               {
                  GameInSocketOut.sendGameTakeOut(this._idx);
               }
               this.enabled = false;
            }
         }
         else
         {
            MessageTipManager.getInstance().show(this.msg);
         }
      }
      
      private function payAlert() : void
      {
         var content:String = null;
         var takeCardDiscount:int = int(ServerConfigManager.instance.VIPTakeCardDisCount[PlayerManager.Instance.Self.VIPLevel - 1]);
         var actualPrice:int = 0;
         actualPrice = Math.floor(takeCardDiscount / 100 * ServerConfigManager.instance.TakeCardMoney);
         if(takeCardDiscount == 100 || takeCardDiscount == 0)
         {
            content = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentCommonNoDiscount",ServerConfigManager.instance.TakeCardMoney);
            this.tPrice = ServerConfigManager.instance.TakeCardMoney;
         }
         else if(PlayerManager.Instance.Self.IsVIP)
         {
            this.tPrice = ServerConfigManager.instance.TakeCardMoney - actualPrice;
            content = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentVip",actualPrice,ServerConfigManager.instance.TakeCardMoney - actualPrice);
            actualPrice = Math.round(takeCardDiscount / 100 * ServerConfigManager.instance.TakeCardMoney);
            content = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentVip",actualPrice,ServerConfigManager.instance.TakeCardMoney - actualPrice);
         }
         else
         {
            content = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentCommon",ServerConfigManager.instance.TakeCardMoney,ServerConfigManager.instance.TakeCardMoney - Math.floor(takeCardDiscount / 100 * ServerConfigManager.instance.TakeCardMoney));
            this.tPrice = ServerConfigManager.instance.TakeCardMoney - actualPrice;
         }
         this._payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.gameover.payConfirm.title"),content,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",50,true);
         if(Boolean(this._payAlert.parent))
         {
            this._payAlert.parent.removeChild(this._payAlert);
         }
         LayerManager.Instance.addToLayer(this._payAlert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._payAlert.addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this.__onRollOut();
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(BuriedManager.Instance.checkMoney(this._payAlert.isBand,this.tPrice))
            {
               return;
            }
            GameInSocketOut.sendPaymentTakeCard(this._idx,this._payAlert.isBand);
            this.enabled = false;
         }
         this._payAlert.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         ObjectUtils.disposeObject(this._payAlert);
         this._payAlert = null;
      }
      
      public function play(info:Player, tid:int, count:int, isVip:Boolean) : void
      {
         this._info = info;
         this._templateID = tid;
         this._count = count;
         this._isVip = isVip;
         if(!info || !this._info.isSelf)
         {
            this._luckyCardMc.lightFrame.visible = false;
            this._luckyCardMc.vipLightFrame.visible = false;
            this._luckyCardMc.starMc.visible = false;
         }
         SoundManager.instance.play("048");
         if(isVip)
         {
            this.openVipCard();
         }
         else
         {
            this.openNormalCard();
         }
         this.enabled = false;
         if(Boolean(this._info))
         {
            this._NickName = Boolean(this._info.playerInfo) ? this._info.playerInfo.NickName : "";
         }
      }
      
      private function openNormalCard() : void
      {
         this._luckyCardMc["lightFrame"].gotoAndPlay(2);
         this._luckyCardMc["cardMc"].gotoAndPlay(2);
         this._luckyCardMc["vipLightFrame"].gotoAndStop(1);
         this._luckyCardMc["vipCardMc"].gotoAndStop(1);
         this._luckyCardMc["starMc"].gotoAndPlay(2);
      }
      
      private function openVipCard() : void
      {
         this._luckyCardMc["lightFrame"].gotoAndStop(1);
         this._luckyCardMc["cardMc"].gotoAndPlay(2);
         this._luckyCardMc["vipLightFrame"].gotoAndPlay(2);
         this._luckyCardMc["vipCardMc"].gotoAndPlay(2);
         this._luckyCardMc["starMc"].gotoAndPlay(2);
      }
      
      private function showResult() : void
      {
         var textFormat:TextFormat = null;
         var tempInfo:ItemTemplateInfo = null;
         var beadInfo:BeadInfo = null;
         try
         {
            this._luckyCardMc["cardMc"].stop();
         }
         catch(e:Error)
         {
         }
         finally
         {
            if(Boolean(this._info))
            {
               this._nickName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.PlayerItemNameTxt");
               if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
               {
                  PositionUtils.setPos(this._nickName,"fightFootballTime.expView.nickNamePos");
               }
               this._nickName.text = Boolean(this._info.playerInfo) ? this._info.playerInfo.NickName : this._NickName;
               if(Boolean(this._info.playerInfo) && this._info.playerInfo.IsVIP)
               {
                  this._vipNameTxt = VipController.instance.getVipNameTxt(90,this._info.playerInfo.typeVIP);
                  this._vipNameTxt.x = this._nickName.x;
                  this._vipNameTxt.y = this._nickName.y + 1;
                  textFormat = new TextFormat();
                  textFormat.align = "center";
                  textFormat.bold = true;
                  this._vipNameTxt.textField.defaultTextFormat = textFormat;
                  this._vipNameTxt.text = this._nickName.text;
                  addChild(this._vipNameTxt);
               }
               else
               {
                  addChild(this._nickName);
               }
            }
            if(this._templateID > 0)
            {
               this._itemCell = new BagCell(0);
               this._itemCell.BGVisible = false;
               this._itemName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.CardItemNameTxt");
               tempInfo = ItemManager.Instance.getTemplateById(this._templateID);
               if(Boolean(tempInfo) && Boolean(this._itemCell))
               {
                  this._itemCell.info = tempInfo;
                  if(tempInfo.Property1 != "31")
                  {
                     this._itemName.text = tempInfo.Name;
                  }
                  else
                  {
                     beadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(tempInfo.TemplateID);
                     if(beadInfo != null)
                     {
                        this._itemName.text = beadInfo.Name + "Lv" + beadInfo.BaseLevel;
                     }
                  }
                  this._itemCell.x = 32;
                  this._itemCell.y = 57;
                  this._itemCell.mouseChildren = false;
                  this._itemCell.mouseEnabled = false;
                  if(this._itemName.numLines > 1)
                  {
                     this._itemName.y -= 9;
                  }
                  addChild(this._itemCell);
                  addChild(this._itemName);
               }
            }
            else if(this._templateID == -100)
            {
               this._itemGoldTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldTxt");
               this._itemBitmap = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldBitmap");
               this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.GoldTxt");
               this._goldTxt.text = this._count.toString();
               addChild(this._itemGoldTxt);
               addChild(this._itemBitmap);
               addChild(this._goldTxt);
               if(Boolean(this._info) && this._info.isSelf)
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.takecard.getgold",this._count));
               }
            }
            else if(this._templateID != -200)
            {
               if(this._templateID == -300)
               {
                  this._itemName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.CardItemNameTxt");
                  this._itemName.text = LanguageMgr.GetTranslation("gift");
                  this._itemBitmap = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.isBindBitmap");
                  this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.GoldTxt");
                  this._goldTxt.text = this._count.toString();
                  addChild(this._itemName);
                  addChild(this._itemBitmap);
                  addChild(this._goldTxt);
                  if(Boolean(this._info) && this._info.isSelf)
                  {
                     ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.takecard.getIsBind",this._count));
                  }
               }
            }
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._payAlert))
         {
            this._payAlert.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         }
         removeEventListener(MouseEvent.CLICK,this.__onClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
         ObjectUtils.disposeObject(this._luckyCardMc);
         this._luckyCardMc = null;
         ObjectUtils.disposeObject(this._nickName);
         this._nickName = null;
         ObjectUtils.disposeObject(this._itemName);
         this._itemName = null;
         ObjectUtils.disposeObject(this._vipNameTxt);
         this._vipNameTxt = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._itemGoldTxt);
         this._itemGoldTxt = null;
         ObjectUtils.disposeObject(this._itemBitmap);
         this._itemBitmap = null;
         ObjectUtils.disposeObject(this._goldTxt);
         this._goldTxt = null;
         ObjectUtils.disposeObject(this._payAlert);
         this._payAlert = null;
         if(Boolean(this._overShape) && Boolean(this._overShape.parent))
         {
            this._overShape.parent.removeChild(this._overShape);
         }
         this._overShape = null;
         this._overEffect = null;
         this._overEffectPoint = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

