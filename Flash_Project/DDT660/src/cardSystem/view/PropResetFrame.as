package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class PropResetFrame extends BaseAlerFrame
   {
      
      private var _cardInfo:CardInfo;
      
      private var _cardCell:ResetCardCell;
      
      private var _newProperty:Bitmap;
      
      private var _oldProperty:Bitmap;
      
      private var _inputSmallBg1:Vector.<ScaleLeftRightImage>;
      
      private var _inputSmallBg2:Vector.<ScaleLeftRightImage>;
      
      private var _basicPropVec1:Vector.<FilterFrameText>;
      
      private var _oldPropVec:Vector.<FilterFrameText>;
      
      private var _newPropVec:Vector.<FilterFrameText>;
      
      private var _upAndDownVec:Vector.<ScaleFrameImage>;
      
      private var _smallinputPropContainer1:VBox;
      
      private var _smallinputPropContainer2:VBox;
      
      private var _basePropContainer1:VBox;
      
      private var _oldPropContainer:VBox;
      
      private var _newPropContainer:VBox;
      
      private var _upAndDownContainer:VBox;
      
      private var _canReplace:Boolean;
      
      private var _isFirst:Boolean = true;
      
      private var _headBg1:ScaleBitmapImage;
      
      private var _headBg2:ScaleBitmapImage;
      
      private var _headTextBg1:ScaleLeftRightImage;
      
      private var _headTextBg2:ScaleLeftRightImage;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bg4:ScaleBitmapImage;
      
      private var _resetArrow:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _helpButton:BaseButton;
      
      private var _needSoul:FilterFrameText;
      
      private var _needSoulText:FilterFrameText;
      
      private var _ownSoul:FilterFrameText;
      
      private var _ownSoulText:FilterFrameText;
      
      private var _resetAlert:BaseAlerFrame;
      
      private var _cancelAlert:BaseAlerFrame;
      
      private var _propertyPool:Object = new Object();
      
      private var _strArray:Object = new Object();
      
      private var _newArray:Array = new Array();
      
      private var _propertys:Vector.<PropertyEmu>;
      
      private var _sendReplace:Boolean = false;
      
      private var _resetNeedSoul:int;
      
      public function PropResetFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var k:int = 0;
         var preTextBg1:ScaleLeftRightImage = null;
         var preTextBg2:ScaleLeftRightImage = null;
         var upAndDownImg:ScaleFrameImage = null;
         var text:FilterFrameText = null;
         this._headBg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.headBG1");
         this._headBg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.headBG2");
         addToContent(this._headBg1);
         addToContent(this._headBg2);
         this._headTextBg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.numBg1");
         addToContent(this._headTextBg1);
         this._headTextBg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.numBg2");
         addToContent(this._headTextBg2);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG3");
         this._bg4 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG4");
         addToContent(this._bg1);
         addToContent(this._bg2);
         addToContent(this._bg3);
         addToContent(this._bg4);
         this._resetArrow = ComponentFactory.Instance.creatBitmap("asset.cardSystem.resetArrow");
         addToContent(this._resetArrow);
         this._helpButton = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.Help");
         addToContent(this._helpButton);
         this._oldProperty = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.oldProperty");
         addToContent(this._oldProperty);
         this._newProperty = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.newProperty");
         addToContent(this._newProperty);
         this._needSoul = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.needSoul");
         this._needSoul.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.needSoul");
         addToContent(this._needSoul);
         this._needSoulText = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.needSoulText");
         this._needSoulText.text = ServerConfigManager.instance.CardRestSoulValue;
         addToContent(this._needSoulText);
         this._ownSoul = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.ownSoul");
         this._ownSoul.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.ownSoul");
         addToContent(this._ownSoul);
         this._ownSoulText = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.ownSoulText");
         this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
         addToContent(this._ownSoulText);
         escEnable = true;
         this._inputSmallBg1 = new Vector.<ScaleLeftRightImage>(4);
         this._inputSmallBg2 = new Vector.<ScaleLeftRightImage>(4);
         this._basicPropVec1 = new Vector.<FilterFrameText>(4);
         this._oldPropVec = new Vector.<FilterFrameText>(4);
         this._newPropVec = new Vector.<FilterFrameText>(4);
         this._upAndDownVec = new Vector.<ScaleFrameImage>(4);
         this._cardCell = ComponentFactory.Instance.creatCustomObject("PropResetCell");
         this._smallinputPropContainer1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.smallinputPropContainer1");
         this._smallinputPropContainer2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.smallinputPropContainer2");
         this._basePropContainer1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.basePropContainer1");
         this._oldPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.oldPropContainer");
         this._newPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.newPropContainer");
         this._upAndDownContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.upAndDownContainer");
         for(var j:int = 0; j < 4; j++)
         {
            preTextBg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.preNumBg");
            this._inputSmallBg1[j] = preTextBg1;
            this._smallinputPropContainer1.addChild(this._inputSmallBg1[j]);
         }
         for(k = 0; k < 4; k++)
         {
            preTextBg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.newNumBg");
            this._inputSmallBg2[k] = preTextBg2;
            this._smallinputPropContainer2.addChild(this._inputSmallBg2[k]);
            upAndDownImg = ComponentFactory.Instance.creatComponentByStylename("asset.cardSystem.upAndDown");
            upAndDownImg.setFrame(1);
            upAndDownImg.visible = false;
            this._upAndDownVec[k] = upAndDownImg;
            this._upAndDownContainer.addChild(this._upAndDownVec[k]);
         }
         for(var i:int = 0; i < 12; i++)
         {
            text = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.PropText");
            if(i < 4)
            {
               this._basicPropVec1[i] = text;
               this._basePropContainer1.addChild(this._basicPropVec1[i]);
            }
            else if(i < 8)
            {
               this._oldPropVec[i % 4] = text;
               this._oldPropContainer.addChild(this._oldPropVec[i % 4]);
            }
            else
            {
               this._newPropVec[i % 4] = text;
               this._newPropContainer.addChild(this._newPropVec[i % 4]);
            }
         }
         addToContent(this._cardCell);
         addToContent(this._smallinputPropContainer1);
         addToContent(this._smallinputPropContainer2);
         addToContent(this._basePropContainer1);
         addToContent(this._oldPropContainer);
         addToContent(this._newPropContainer);
         addToContent(this._upAndDownContainer);
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.title");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.reset");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.replace");
         this._alertInfo.moveEnable = false;
         this._alertInfo.enterEnable = false;
         this._alertInfo.cancelEnabled = false;
         info = this._alertInfo;
         this.checkSoul();
      }
      
      public function checkSoul() : void
      {
         if(PlayerManager.Instance.Self.CardSoul < int(ServerConfigManager.instance.CardRestSoulValue))
         {
            this._alertInfo.submitEnabled = false;
         }
      }
      
      public function show(card:CardInfo) : void
      {
         var j:int = 0;
         this._cardInfo = card;
         this._cardCell.cardInfo = this._cardInfo;
         this._cardCell.Visibles = false;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
         for(var i:int = 0; i < this._propertys.length; i++)
         {
            this._basicPropVec1[i].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[i].key + "1");
         }
         this.UpdateStrArray();
         if(this._strArray != null)
         {
            for(j = 0; j < this._propertys.length; j++)
            {
               this._oldPropVec[j].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._strArray[this._propertys[j].key] == null || this._strArray[this._propertys[j].key] == "" ? "0" : this._strArray[this._propertys[j].key]);
            }
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function UpdateStrArray() : void
      {
         var cardTempleInfo:CardTemplateInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(this._cardInfo.TemplateID),String(this._cardInfo.CardType));
         var Attackstr:String = this._cardInfo.Attack.toString();
         var Defencestr:String = this._cardInfo.Defence.toString();
         var Agilitystr:String = this._cardInfo.Agility.toString();
         var Luckystr:String = this._cardInfo.Luck.toString();
         var Damagestr:String = this._cardInfo.Damage.toString();
         var Guardstr:String = this._cardInfo.Guard.toString();
         this._strArray = {
            "Attack":Attackstr,
            "Defence":Defencestr,
            "Agility":Agilitystr,
            "Luck":Luckystr
         };
      }
      
      public function set cardInfo(value:CardInfo) : void
      {
         this._cardInfo = value;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         CardControl.Instance.model.addEventListener(CardEvent.CHANGE_SOUL,this.__changeSoul);
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.addEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      private function __response(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               this.__resethandler(null);
               break;
            case FrameEvent.CANCEL_CLICK:
               this.__replaceHandler(null);
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._alertInfo.cancelEnabled == true)
               {
                  this.__cancelHandel();
               }
               else
               {
                  this.dispose();
               }
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         CardControl.Instance.model.removeEventListener(CardEvent.CHANGE_SOUL,this.__changeSoul);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.removeEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      protected function __replaceHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var msg:String = LanguageMgr.GetTranslation("tank.view.card.resetAlertMsg");
         this._resetAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._resetAlert.moveEnable = false;
         this._resetAlert.addEventListener(FrameEvent.RESPONSE,this.__replaceAlert);
      }
      
      private function __replaceAlert(event:FrameEvent) : void
      {
         if(Boolean(this._resetAlert))
         {
            this._resetAlert.removeEventListener(FrameEvent.RESPONSE,this.__replaceAlert);
         }
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submitReplace();
         }
         this._resetAlert.dispose();
         if(Boolean(this._resetAlert.parent))
         {
            this._resetAlert.parent.removeChild(this._resetAlert);
         }
         this._resetAlert = null;
      }
      
      private function submitReplace() : void
      {
         SoundManager.instance.play("008");
         if(this._canReplace)
         {
            SocketManager.Instance.out.sendReplaceCardProp(this._cardInfo.Place);
            this.setReplaceAbled(false);
            this._alertInfo.cancelEnabled = false;
            this._sendReplace = true;
            this.updateText();
         }
      }
      
      private function __changeSoul(event:CardEvent) : void
      {
         this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
      }
      
      private function updateText() : void
      {
         var i:int = 0;
         var j:int = 0;
         if(this._sendReplace)
         {
            this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
            if(this._strArray != null)
            {
               for(j = 0; j < this._propertys.length; j++)
               {
                  this._oldPropVec[j].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._newArray[j].toString());
                  this._strArray[this._propertys[j].key] = this._newArray[j];
               }
            }
            for(i = 0; i < this._newPropVec.length; i++)
            {
               this._upAndDownVec[i].visible = false;
               this._newPropVec[i].text = "";
            }
            this._sendReplace = false;
            this._alertInfo.submitEnabled = true;
            this.checkSoul();
         }
      }
      
      protected function __resethandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.CardSoul -= int(ServerConfigManager.instance.CardRestSoulValue);
         CardControl.Instance.model.dispatchEvent(new CardEvent(CardEvent.CHANGE_SOUL));
         SocketManager.Instance.out.sendCardReset(this._cardInfo.Place);
         this.setReplaceAbled(true);
         this.checkSoul();
      }
      
      private function __cancelHandel() : void
      {
         SoundManager.instance.play("008");
         var msg:String = LanguageMgr.GetTranslation("tank.view.card.cancelAlertMsg");
         this._cancelAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._cancelAlert.moveEnable = false;
         this._cancelAlert.addEventListener(FrameEvent.RESPONSE,this.__cancelResponse);
      }
      
      private function __cancelResponse(event:FrameEvent) : void
      {
         if(Boolean(this._cancelAlert))
         {
            this._cancelAlert.removeEventListener(FrameEvent.RESPONSE,this.__cancelResponse);
         }
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               if(Boolean(this._cancelAlert))
               {
                  ObjectUtils.disposeObject(this._cancelAlert);
               }
               this._cancelAlert = null;
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.dispose();
         }
      }
      
      private function setReplaceAbled(val:Boolean) : void
      {
         this._alertInfo.cancelEnabled = val;
      }
      
      private function __reset(event:CrazyTankSocketEvent) : void
      {
         this._newArray = new Array();
         var pkg:PackageIn = event.pkg;
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            this._newArray.push(pkg.readInt());
         }
         for(var j:int = 0; j < this._propertys.length; j++)
         {
            this._newPropVec[j].text = String(this._newArray[j]);
            if(this._newArray[j] != int(this._strArray[this._propertys[j].key]))
            {
               this._upAndDownVec[j].visible = true;
               if(this._newArray[j] < int(this._strArray[this._propertys[j].key]))
               {
                  this._upAndDownVec[j].setFrame(2);
               }
               else
               {
                  this._upAndDownVec[j].setFrame(1);
               }
            }
            else
            {
               this._upAndDownVec[j].visible = false;
            }
         }
         this._canReplace = true;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._cardCell))
         {
            this._cardCell.dispose();
         }
         this._cardCell = null;
         super.dispose();
         this.removeEvent();
         for(var i:int = 0; i < 6; i++)
         {
            this._basicPropVec1[i] = null;
            this._oldPropVec[i] = null;
            this._newPropVec[i] = null;
            this._inputSmallBg1[i] = null;
            this._inputSmallBg2[i] = null;
         }
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._headBg1 = null;
         this._headBg2 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bg4 = null;
         this._basePropContainer1 = null;
         this._oldPropContainer = null;
         this._newPropContainer = null;
         this._smallinputPropContainer1 = null;
         this._smallinputPropContainer2 = null;
         this._upAndDownContainer = null;
         this._helpButton = null;
         this._resetArrow = null;
         this._propertyPool = null;
         this._propertys = null;
         this._oldProperty = null;
         this._newProperty = null;
         this._upAndDownVec = null;
         this._needSoul = null;
         this._ownSoul = null;
         this._needSoulText = null;
         this._ownSoulText = null;
         if(Boolean(this._resetAlert))
         {
            ObjectUtils.disposeObject(this._resetAlert);
         }
         this._resetAlert = null;
         if(Boolean(this._cancelAlert))
         {
            ObjectUtils.disposeObject(this._cancelAlert);
         }
         this._cancelAlert = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __helpOpen(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBg:DisplayObject = ComponentFactory.Instance.creatComponentByStylename("Scale9CornerImage17");
         var helpContent:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.resetFrame.help");
         PositionUtils.setPos(helpContent,"resetFrame.help.contentPos");
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.help.title");
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.showCancel = false;
         alertInfo.moveEnable = false;
         var frame:BaseAlerFrame = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.HelpFrame");
         frame.info = alertInfo;
         frame.addToContent(helpBg);
         frame.addToContent(helpContent);
         frame.addEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         LayerManager.Instance.addToLayer(frame,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __helpResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         alert.dispose();
         SoundManager.instance.play("008");
         StageReferance.stage.focus = this;
      }
   }
}

class PropertyEmu
{
   
   public var key:String;
   
   public var idx:int;
   
   public function PropertyEmu(key:String, idx:int)
   {
      super();
      this.key = key;
      this.idx = idx;
   }
}
