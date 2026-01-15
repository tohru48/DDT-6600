package room.transnational
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import shop.view.ShopItemCell;
   
   public class TransnationalRightView extends Sprite
   {
      
      private static var rightView:TransnationalRightView;
      
      private var _bg:Bitmap;
      
      private var _matchingTxt:Bitmap;
      
      private var _btnbg:Bitmap;
      
      private var _helpBtn:BaseButton;
      
      private var _startBtn:MovieClip;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _helpBG:Scale9CornerImage;
      
      private var _okBtn:TextButton;
      
      private var _content:MovieClip;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _weaponsContainer:HBox;
      
      private var _auxsContainer:HBox;
      
      private var _petsContainer:HBox;
      
      private var _weaponsVec:Vector.<ShopItemCell>;
      
      private var _auxsVec:Vector.<ShopItemCell>;
      
      private var _petsVec:Vector.<TransnationalPetCell>;
      
      private var _smallmap:Bitmap;
      
      private var _smarker:Sprite;
      
      public function TransnationalRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public static function get Instance() : TransnationalRightView
      {
         if(rightView == null)
         {
            rightView = new TransnationalRightView();
         }
         return rightView;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.TransnationalrightView.BG");
         this._matchingTxt = ComponentFactory.Instance.creatBitmap("asset.room.Transnational.matchingTxt");
         this._matchingTxt.visible = false;
         this._btnbg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.btnBg");
         PositionUtils.setPos(this._btnbg,"asset.ddtroom.transnationalstartbtnBg");
         this._smallmap = ComponentFactory.Instance.creatBitmap("asset.room.transnational.smalllmap");
         this._startBtn = ClassUtils.CreatInstance("asset.ddtroom.startMovie") as MovieClip;
         PositionUtils.setPos(this._startBtn,"asset.ddtroom.transnationalstartbtn");
         this._startBtn.buttonMode = true;
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.Transnational.CancelButton");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("ddtTransnational.HelpButton");
         this._weaponsContainer = ComponentFactory.Instance.creatComponentByStylename("Transnationalequipment.weaponsContainer");
         this._auxsContainer = ComponentFactory.Instance.creatComponentByStylename("Transnationalequipment.auxsContainer");
         this._petsContainer = ComponentFactory.Instance.creatComponentByStylename("Transnationalequipment.petsContainer");
         this._weaponsVec = new Vector.<ShopItemCell>();
         this._auxsVec = new Vector.<ShopItemCell>();
         this._petsVec = new Vector.<TransnationalPetCell>();
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.room.Transnational.timeTxt");
         this._timeTxt.text = "00";
         this._timeTxt.visible = false;
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._smarker = new Sprite();
         addChild(this._bg);
         addChild(this._smallmap);
         addChild(this._matchingTxt);
         addChild(this._btnbg);
         addChild(this._startBtn);
         addChild(this._helpBtn);
         addChild(this._cancelBtn);
         addChild(this._timeTxt);
         addChild(this._weaponsContainer);
         addChild(this._auxsContainer);
         addChild(this._petsContainer);
         this.updataCell();
      }
      
      private function updataCell() : void
      {
         var wea:ShopItemCell = null;
         var aux:ShopItemCell = null;
         var pets:TransnationalPetCell = null;
         var cellBg:Bitmap = null;
         for(var i:int = 0; i < TransnationalFightManager._weaponList.length; i++)
         {
            wea = this.creatItemCell();
            wea.buttonMode = true;
            wea.info = TransnationalFightManager._weaponList[i] as ItemTemplateInfo;
            wea.cellSize = 42;
            cellBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
            PositionUtils.setPos(cellBg,"Transnational.cellbackgroud.pos");
            wea.overBg = cellBg;
            this._weaponsVec.push(this._weaponsContainer.addChild(wea));
         }
         for(var j:int = 0; j < TransnationalFightManager._auxList.length; j++)
         {
            aux = this.creatItemCell();
            aux.buttonMode = true;
            aux.info = TransnationalFightManager._auxList[j] as ItemTemplateInfo;
            cellBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
            PositionUtils.setPos(cellBg,"Transnational.cellbackgroud.pos");
            aux.overBg = cellBg;
            aux.cellSize = 42;
            this._auxsVec.push(this._auxsContainer.addChild(aux));
         }
         for(var k:int = 0; k < TransnationalFightManager._petList.length; k++)
         {
            pets = new TransnationalPetCell();
            pets.Cellinfo = TransnationalFightManager._petList[k];
            pets.setSkill(TransnationalFightManager._petsSkill[pets.Cellinfo.TemplateID]);
            pets.cellSize = 42;
            this._petsVec.push(this._petsContainer.addChild(pets));
         }
      }
      
      private function __timer(evt:TimerEvent) : void
      {
         var sec:uint = this._timer.currentCount % 60;
         this._timeTxt.text = sec > 9 ? sec.toString() : "0" + sec;
      }
      
      private function initEvent() : void
      {
         var weaponCell:ShopItemCell = null;
         var auxCell:ShopItemCell = null;
         var petCell:TransnationalPetCell = null;
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__toStartMatch);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__toShowHelp);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClick);
         for each(weaponCell in this._weaponsVec)
         {
            weaponCell.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         for each(auxCell in this._auxsVec)
         {
            auxCell.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         for each(petCell in this._petsVec)
         {
            petCell.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __onClick(evt:MouseEvent) : void
      {
         var TemplateID:int = 0;
         var petItem:TransnationalPetCell = null;
         var petId:int = 0;
         if(this._startBtn.visible)
         {
            SoundManager.instance.play("008");
            if(evt.currentTarget is ShopItemCell)
            {
               TemplateID = (evt.currentTarget as ShopItemCell).info.TemplateID;
               GameInSocketOut.sendEquipmentTransnational(TemplateID);
            }
            else
            {
               petItem = evt.currentTarget as TransnationalPetCell;
               petId = petItem.Cellinfo.TemplateID;
               GameInSocketOut.sendEquipmentTransnational(petId);
            }
         }
      }
      
      private function removeEvent() : void
      {
         var weaponCell:ShopItemCell = null;
         var auxCell:ShopItemCell = null;
         var petCell:TransnationalPetCell = null;
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__toStartMatch);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__toShowHelp);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         for each(weaponCell in this._weaponsVec)
         {
            weaponCell.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         for each(auxCell in this._auxsVec)
         {
            auxCell.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         for each(petCell in this._petsVec)
         {
            petCell.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __toStartMatch(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._timeTxt.visible = this._matchingTxt.visible = this._cancelBtn.visible = this._cancelBtn.enable = true;
         this._smallmap.visible = this._startBtn.visible = this._startBtn.enabled = false;
         dispatchEvent(new TransnationalEvent(TransnationalEvent.SHOPENABLE,this._startBtn.visible));
         this._timer.start();
         this.startGame();
      }
      
      public function __cancelClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._timer.stop();
         this._timer.reset();
         this._timeTxt.text = "00";
         GameInSocketOut.sendCancelWait();
         this._timeTxt.visible = this._matchingTxt.visible = this._cancelBtn.visible = this._cancelBtn.enable = false;
         this._smallmap.visible = this._startBtn.visible = this._startBtn.enabled = true;
         dispatchEvent(new TransnationalEvent(TransnationalEvent.SHOPENABLE,this._startBtn.visible));
      }
      
      protected function startGame() : void
      {
         GameInSocketOut.sendSingleRoomBegin(TransnationalPackageType.ENTER_ROOM);
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(8,8,42,42);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      private function __toShowHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._helpFrame == null)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("asset.Transnational.helpFrame");
            this._helpBG = ComponentFactory.Instance.creatComponentByStylename("asset.Transnational.help.BG");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("asset.Transnational.helpFrame.OK");
            this._content = ComponentFactory.Instance.creat("asset.Transnational.helpConent");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("Transnational.help.Title");
            this._helpFrame.addToContent(this._okBtn);
            this._helpFrame.addToContent(this._helpBG);
            this._helpFrame.addToContent(this._content);
            this._okBtn.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      public function dispose() : void
      {
         var weaponCell:ShopItemCell = null;
         var auxCell:ShopItemCell = null;
         var petCell:TransnationalPetCell = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._btnbg);
         this._btnbg = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timer = null;
         ObjectUtils.disposeObject(this._smallmap);
         this._smallmap = null;
         if(Boolean(this._helpFrame))
         {
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
         }
         for each(weaponCell in this._weaponsVec)
         {
            weaponCell.dispose();
            ObjectUtils.disposeObject(weaponCell);
            weaponCell = null;
         }
         for each(auxCell in this._auxsVec)
         {
            auxCell.dispose();
            ObjectUtils.disposeObject(weaponCell);
            auxCell = null;
         }
         for each(petCell in this._petsVec)
         {
            petCell.dispose();
            ObjectUtils.disposeObject(petCell);
            petCell = null;
         }
         ObjectUtils.disposeAllChildren(this._weaponsContainer);
         this._weaponsContainer = null;
         ObjectUtils.disposeObject(this._weaponsVec);
         this._weaponsVec = null;
         ObjectUtils.disposeObject(this._auxsVec);
         this._auxsVec = null;
         ObjectUtils.disposeObject(this._petsVec);
         this._petsVec = null;
      }
   }
}

