package store
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.StaticFormula;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class StoreTips extends Sprite implements Disposeable
   {
      
      public static const TRANSFER:int = 0;
      
      public static const EMBED:int = 1;
      
      public static const BEGIN_Y:int = 130;
      
      public static const SPACING:String = " ";
      
      public static const SPACINGII:String = " +";
      
      public static const SPACINGIII:String = " ";
      
      public static const Shield:int = 31;
      
      private var _timer:Timer;
      
      private var _successBit:Bitmap;
      
      private var _failBit:Bitmap;
      
      private var _fiveFailBit:Bitmap;
      
      private var _changeTxtI:FilterFrameText;
      
      private var _changeTxtII:FilterFrameText;
      
      private var _moveSprite:Sprite;
      
      public var isDisplayerTip:Boolean = true;
      
      private var _lastTipString:String = "";
      
      public function StoreTips()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._successBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIISuccessBitAsset");
         this._failBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIIFailBitAsset");
         this._fiveFailBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIIFiveFailBitAsset");
         this._changeTxtI = ComponentFactory.Instance.creatComponentByStylename("ddtstore.storeTipTxt");
         this._changeTxtII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.storeTipTxt");
         this._moveSprite = new Sprite();
         addChild(this._moveSprite);
         this._timer = new Timer(7500,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
      }
      
      private function createTween(onComplete:Function = null, completeParam:Array = null) : void
      {
         MessageTipManager.getInstance().kill();
         TweenMax.killTweensOf(this._moveSprite);
         TweenMax.from(this._moveSprite,0.4,{
            "y":BEGIN_Y,
            "alpha":0
         });
         TweenMax.to(this._moveSprite,0.4,{
            "delay":1.4,
            "y":BEGIN_Y * -1,
            "alpha":0,
            "onComplete":(onComplete == null ? this.removeTips : onComplete),
            "onCompleteParams":completeParam
         });
      }
      
      private function showPropertyChange(info:InventoryItemInfo) : String
      {
         var diff:Number = NaN;
         var str:String = "";
         var chatStr:String = "";
         if(EquipType.isArm(info))
         {
            diff = StaticFormula.getHertAddition(int(info.Property7),info.StrengthenLevel) - StaticFormula.getHertAddition(int(info.Property7),info.StrengthenLevel - 1);
            str = LanguageMgr.GetTranslation("store.storeTip.hurt",SPACING,SPACINGII,diff);
            chatStr = LanguageMgr.GetTranslation("store.storeTip.chatHurt",diff);
         }
         else if(int(info.Property3) == 32)
         {
            diff = StaticFormula.getRecoverHPAddition(int(info.Property7),info.StrengthenLevel) - StaticFormula.getRecoverHPAddition(int(info.Property7),info.StrengthenLevel - 1);
            str = LanguageMgr.GetTranslation("store.storeTip.AddHP",SPACING,SPACINGII,diff);
            chatStr = LanguageMgr.GetTranslation("store.storeTip.chatAddHP",diff);
         }
         else if(int(info.Property3) == Shield)
         {
            diff = StaticFormula.getDefenseAddition(int(info.Property7),info.StrengthenLevel) - StaticFormula.getDefenseAddition(int(info.Property7),info.StrengthenLevel - 1);
            str = LanguageMgr.GetTranslation("store.storeTip.subHurt",SPACING,SPACINGII,diff);
            chatStr = LanguageMgr.GetTranslation("store.storeTip.chatSubHurt",diff);
         }
         else if(EquipType.isEquip(info))
         {
            diff = StaticFormula.getDefenseAddition(int(info.Property7),info.StrengthenLevel) - StaticFormula.getDefenseAddition(int(info.Property7),info.StrengthenLevel - 1);
            str = LanguageMgr.GetTranslation("store.storeTip.Armor",SPACING,SPACINGII,diff);
            chatStr = LanguageMgr.GetTranslation("store.storeTip.chatArmor",diff);
         }
         this._lastTipString += str;
         return chatStr;
      }
      
      private function showHoleTip(info:InventoryItemInfo) : String
      {
         var arr:Array = null;
         var number:int = 0;
         this._changeTxtII.text = "";
         var str:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
         if(info.CategoryID == EquipType.HEAD || info.CategoryID == EquipType.CLOTH)
         {
            if(info.StrengthenLevel == 3 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12)
            {
               str += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty");
            }
            if(info.StrengthenLevel == 6)
            {
               str += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.clothOpenDefense");
            }
         }
         else if(info.CategoryID == EquipType.ARM)
         {
            if(info.StrengthenLevel == 6 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12)
            {
               str += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty");
            }
            if(info.StrengthenLevel == 3)
            {
               str += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenAttack");
            }
         }
         if((info.CategoryID == EquipType.HEAD || info.CategoryID == EquipType.CLOTH || info.CategoryID == EquipType.ARM) && (info.StrengthenLevel == 3 || info.StrengthenLevel == 6 || info.StrengthenLevel == 9 || info.StrengthenLevel == 12))
         {
            arr = info.Hole.split("|");
            number = info.StrengthenLevel / 3;
            if(arr[number - 1].split(",")[1] > 0 && info["Hole" + number] >= 0)
            {
               this._lastTipString += "\n" + str;
               return "";
            }
         }
         return null;
      }
      
      private function showOpenHoleTip(info:InventoryItemInfo) : String
      {
         var str:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
         return str + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty"));
      }
      
      public function showSuccess(type:int = -1) : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
         switch(type)
         {
            case TRANSFER:
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Transfer.Succes.ChatSay"));
               break;
            case EMBED:
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Embed.Succes.ChatSay"));
         }
      }
      
      public function showStrengthSuccess(info:InventoryItemInfo, isShowHoleTip:Boolean) : void
      {
         var propertyString:String = null;
         var holeString:String = null;
         this._lastTipString = "";
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            propertyString = this.showPropertyChange(info);
            holeString = isShowHoleTip ? this.showHoleTip(info) : null;
            if(Boolean(holeString))
            {
               propertyString = propertyString.replace("!",",");
               propertyString += holeString;
            }
            this.createTween(this.strengthTweenComplete,[propertyString]);
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + propertyString);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
      }
      
      private function strengthTweenComplete(content:String) : void
      {
         if(Boolean(content))
         {
            MessageTipManager.getInstance().show(content);
         }
         this.removeTips();
      }
      
      public function showEmbedSuccess(info:InventoryItemInfo) : void
      {
         var openHoleString:String = null;
         this._lastTipString = "";
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            openHoleString = this.showOpenHoleTip(info);
            this.createTween(this.embedTweenComplete);
            this._lastTipString = openHoleString;
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + this._lastTipString);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
      }
      
      private function embedTweenComplete() : void
      {
         MessageTipManager.getInstance().show(this._lastTipString);
         this.removeTips();
      }
      
      public function showFail() : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._failBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("064",false,false);
         this._timer.start();
      }
      
      public function showFiveFail() : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._failBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("064",false,false);
         this._timer.start();
      }
      
      private function __timerComplete(evt:TimerEvent) : void
      {
         this._timer.reset();
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
      }
      
      private function removeTips() : void
      {
         if(Boolean(this._moveSprite) && Boolean(this._moveSprite.parent))
         {
            while(Boolean(this._moveSprite.numChildren))
            {
               this._moveSprite.removeChildAt(0);
            }
            TweenMax.killTweensOf(this._moveSprite);
            this._moveSprite.parent.removeChild(this._moveSprite);
            this._moveSprite = null;
         }
      }
      
      public function dispose() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer.stop();
         this._timer = null;
         TweenMax.killTweensOf(this._moveSprite);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         this.removeTips();
         if(Boolean(this._successBit))
         {
            ObjectUtils.disposeObject(this._successBit);
         }
         this._successBit = null;
         if(Boolean(this._failBit))
         {
            ObjectUtils.disposeObject(this._failBit);
         }
         this._failBit = null;
         if(Boolean(this._fiveFailBit))
         {
            ObjectUtils.disposeObject(this._fiveFailBit);
         }
         this._fiveFailBit = null;
         if(Boolean(this._moveSprite))
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         if(Boolean(this._changeTxtI))
         {
            ObjectUtils.disposeObject(this._changeTxtI);
         }
         this._changeTxtI = null;
         if(Boolean(this._changeTxtII))
         {
            ObjectUtils.disposeObject(this._changeTxtII);
         }
         this._changeTxtII = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

