package fightLib.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FightLibAlertView extends Sprite implements Disposeable
   {
      
      private static const ButtonToCenter:int = 8;
      
      private var _background:DisplayObject;
      
      private var _girlImage:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _infoStr:String;
      
      private var _okLabel:String = LanguageMgr.GetTranslation("ok");
      
      private var _okBtn:TextButton;
      
      private var _okFun:Function;
      
      private var _cancelLabel:String = LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain");
      
      private var _cancelBtn:TextButton;
      
      private var _cancelFun:Function;
      
      private var _showOkBtn:Boolean;
      
      private var _showCancelBtn:Boolean;
      
      private var _centerPosition:Point;
      
      private var _WeaponCellArr:Array;
      
      public function FightLibAlertView(infoString:String, okLabel:String = null, okFun:Function = null, cancelLabel:String = null, cancelFun:Function = null, showOkBtn:Boolean = true, showCancelBtn:Boolean = false, weaponArr:Array = null)
      {
         super();
         this._infoStr = infoString;
         if(Boolean(okLabel))
         {
            this._okLabel = okLabel;
         }
         this._okFun = okFun;
         if(Boolean(cancelLabel))
         {
            this._cancelLabel = cancelLabel;
         }
         this._cancelFun = cancelFun;
         this._showOkBtn = showOkBtn;
         this._showCancelBtn = showCancelBtn;
         this.configUI();
         this.addEvent();
         if(!this._showCancelBtn)
         {
            this._okBtn.x = this._centerPosition.x - this._okBtn.width / 2;
         }
         else
         {
            this._okBtn.x = this._centerPosition.x - this._okBtn.width - ButtonToCenter;
            this._cancelBtn.x = this._centerPosition.x + ButtonToCenter;
         }
         this._okBtn.y = this._cancelBtn.y = this._centerPosition.y;
         this._okBtn.visible = this._showOkBtn;
         this._cancelBtn.visible = this._showCancelBtn;
         if(weaponArr != null)
         {
            this.ShowWeaponIcon(weaponArr);
         }
      }
      
      private function ShowWeaponIcon(_arr:Array) : void
      {
         var cardTempInfo:ItemTemplateInfo = null;
         var i:int = 0;
         var s:Sprite = null;
         var cell:BaseCell = null;
         var _NameTxt:String = null;
         var _WeaponNameField:FilterFrameText = null;
         this._WeaponCellArr = new Array();
         var Max:int = int(_arr.length);
         for(i = 0; i < Max; i++)
         {
            s = new Sprite();
            s.graphics.beginFill(16777215,0);
            s.graphics.drawRect(0,0,60,60);
            s.graphics.endFill();
            cardTempInfo = ItemManager.Instance.getTemplateById(_arr[i]);
            cell = new BaseCell(s,cardTempInfo,true,false);
            cell.x = 30 + i * 70;
            cell.y = 67;
            addChild(cell);
            this._WeaponCellArr.push(cell);
            _NameTxt = cardTempInfo.Name.slice(2);
            _WeaponNameField = ComponentFactory.Instance.creatComponentByStylename("fightLib.WeaponNameField");
            _WeaponNameField.x = 58 + i * 70;
            _WeaponNameField.y = 119;
            _WeaponNameField.text = _NameTxt;
            addChild(_WeaponNameField);
         }
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         this.removeEvent();
         if(this._WeaponCellArr != null)
         {
            for(i = 0; i < this._WeaponCellArr.length; i++)
            {
               this._WeaponCellArr[i].dispose();
            }
         }
         ObjectUtils.disposeAllChildren(this);
         this._background = null;
         this._girlImage = null;
         this._cancelBtn = null;
         this._cancelFun = null;
         this._okBtn = null;
         this._okFun = null;
         this._txt = null;
         this._WeaponCellArr = null;
      }
      
      public function show() : void
      {
         x = StageReferance.stageWidth - width >> 1;
         y = StageReferance.stageHeight - height >> 1;
         this._txt.text = this._infoStr;
         this.updataWeaponIcon();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER);
      }
      
      private function updataWeaponIcon() : void
      {
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set alert(val:String) : void
      {
         this._txt.text = val;
      }
      
      public function get alert() : String
      {
         return this._txt.text;
      }
      
      private function configUI() : void
      {
         this._centerPosition = ComponentFactory.Instance.creatCustomObject("fithtLib.Alert.CenterPosition");
         this._background = ComponentFactory.Instance.creatComponentByStylename("fightLib.Game.GirlGuildBack");
         addChild(this._background);
         this._girlImage = ComponentFactory.Instance.creatBitmap("fightLib.Game.GirlGuild.Girl");
         this._girlImage.scaleX = -0.6;
         this._girlImage.scaleY = 0.6;
         addChild(this._girlImage);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.AlertField");
         addChild(this._txt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.SubmitButton");
         if(this._okLabel != null)
         {
            this._okBtn.text = this._okLabel;
         }
         else
         {
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
         }
         addChild(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.CancelButton");
         if(this._cancelLabel != null)
         {
            this._cancelBtn.text = this._cancelLabel;
         }
         else
         {
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         }
         addChild(this._cancelBtn);
      }
      
      private function addEvent() : void
      {
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__submitClicked);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClicked);
      }
      
      private function __cancelClicked(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._cancelFun != null)
         {
            this._cancelFun();
         }
      }
      
      private function __submitClicked(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._okFun != null)
         {
            this._okFun();
         }
      }
      
      private function removeEvent() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__submitClicked);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClicked);
      }
   }
}

