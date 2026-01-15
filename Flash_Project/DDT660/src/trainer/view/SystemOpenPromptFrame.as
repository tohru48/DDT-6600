package trainer.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import trainer.controller.SystemOpenPromptManager;
   
   public class SystemOpenPromptFrame extends Frame
   {
      
      private var _iconTxtBg:Bitmap;
      
      private var _btnBg:Bitmap;
      
      private var _tipTxt:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _icon:Bitmap;
      
      private var _equipCell:BagCell;
      
      private var _toPlace:int;
      
      private var _callback:Function;
      
      private var _type:int;
      
      private var _image:ScaleFrameImage;
      
      public function SystemOpenPromptFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._iconTxtBg = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.iconTxtBg");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("systemOpenPrompt.frame.txt");
         this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.tipTxt");
         this._btnBg = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.btnBg");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("systemOpenPrompt.frame.btn");
         addToContent(this._iconTxtBg);
         addToContent(this._tipTxt);
         addToContent(this._btnBg);
         addToContent(this._btn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnClickHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function btnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._type == SystemOpenPromptManager.GET_NEW_EQUIP_TIP)
         {
            this._callback(this._equipCell);
         }
         else
         {
            this._callback(this._type);
         }
         this.dispose();
      }
      
      public function show(type:int, callback:Function, item:InventoryItemInfo = null, toPlace:int = 0) : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER);
         this._toPlace = toPlace;
         this._type = type;
         this._callback = callback;
         switch(type)
         {
            case SystemOpenPromptManager.TOTEM:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.totemIcon");
               break;
            case SystemOpenPromptManager.GEMSTONE:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.gemstone");
               break;
            case SystemOpenPromptManager.GET_AWARD:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.getAwardIcon");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.getAwardTxt");
               break;
            case SystemOpenPromptManager.SIGN:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.signIcon");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.signTxt");
               break;
            case SystemOpenPromptManager.TREASURE:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.treasureIcon");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.treasure");
               break;
            case SystemOpenPromptManager.CONSORTIA_BOSS_OPEN:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.consortiaBossOpen");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.consortiaBossOpenTxt");
               this._btn.backStyle = "asset.systemOpenPrompt.goBtn";
               break;
            case SystemOpenPromptManager.BATTLE_GROUND_OPEN:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.battle.iconpic");
               this._icon.x = 10;
               this._icon.y = 9;
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.battleGroundOpenTxt");
               this._btn.backStyle = "asset.systemOpenPrompt.goBtn";
               break;
            case SystemOpenPromptManager.FARM_CROP_RIPE:
               this._image = ComponentFactory.Instance.creatComponentByStylename("systemOpenPrompt.frame.farmimage");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.farmCropRipe");
               addToContent(this._image);
               break;
            case SystemOpenPromptManager.SEVEN_DOUBLE_DUNGEON:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.sevenDoubleDungeon");
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.sevenDoubleDungeon");
               this._btn.backStyle = "asset.systemOpenPrompt.goBtn";
               break;
            case SystemOpenPromptManager.GET_NEW_EQUIP_TIP:
               this._equipCell = new BagCell(0,item);
               this._equipCell.x = 28;
               this._equipCell.y = 23;
               this._equipCell.setBgVisible(false);
               this._tipTxt.text = LanguageMgr.GetTranslation("ddt.systemOpenPrompt.getNewEquip");
               this._btn.backStyle = "asset.systemOpenPrompt.equipBtn";
               break;
            case SystemOpenPromptManager.ENCHANT:
               this._icon = ComponentFactory.Instance.creatBitmap("asset.systemOpenPrompt.enchant");
               this._btn.backStyle = "asset.systemOpenPrompt.goBtn";
               break;
            default:
               this._icon = new Bitmap();
         }
         if(Boolean(this._icon))
         {
            addToContent(this._icon);
         }
         if(Boolean(this._equipCell))
         {
            addToContent(this._equipCell);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.btnClickHandler);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._callback = null;
         ObjectUtils.disposeObject(this._iconTxtBg);
         this._iconTxtBg = null;
         ObjectUtils.disposeObject(this._tipTxt);
         this._tipTxt = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         super.dispose();
      }
   }
}

