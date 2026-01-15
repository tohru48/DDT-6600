package drgnBoatBuild.views
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import drgnBoatBuild.DrgnBoatBuildManager;
   import drgnBoatBuild.components.BuildProgress;
   import drgnBoatBuild.data.DrgnBoatBuildCellInfo;
   import drgnBoatBuild.data.DrgnBoatBuildEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DrgnBoatBuildLeftView extends Sprite implements Disposeable
   {
      
      private var _leftBg:Bitmap;
      
      private var _titleBmp:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _progress:BuildProgress;
      
      private var _staticBuilding:MovieClip;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _ownImg:Bitmap;
      
      private var _ownedBeard:FilterFrameText;
      
      private var _ownedWood:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _itemBg:Bitmap;
      
      private var _countTxt:FilterFrameText;
      
      private var _complete:Bitmap;
      
      private var _backBtn:SimpleBitmapButton;
      
      private var _cell:BagCell;
      
      private var _tipTouchArea:Component;
      
      private var _stage:int;
      
      private var _isSelf:Boolean = true;
      
      private var _userId:int;
      
      public function DrgnBoatBuildLeftView()
      {
         super();
         this.initView();
         this.initEvents();
         SocketManager.Instance.out.updateDrgnBoatBuildInfo();
      }
      
      private function initView() : void
      {
         this._leftBg = ComponentFactory.Instance.creat("drgnBoatBuild.leftViewBg");
         addChild(this._leftBg);
         this._titleBmp = ComponentFactory.Instance.creat("drgnBoatBuild.title");
         addChild(this._titleBmp);
         this._progress = new BuildProgress();
         PositionUtils.setPos(this._progress,"drgnBoatBuild.progressPos");
         addChild(this._progress);
         this._staticBuilding = ComponentFactory.Instance.creat("drgnBoatBuild.staticBuilding");
         addChild(this._staticBuilding);
         this._staticBuilding.x = 186;
         this._staticBuilding.y = 236;
         this._staticBuilding.scaleX = 0.8;
         this._staticBuilding.scaleY = 0.8;
         this._staticBuilding.gotoAndStop(1);
      }
      
      public function setView() : void
      {
         var configArr:Array = null;
         var temArr:Array = null;
         var count:int = 0;
         var item:InventoryItemInfo = null;
         var mc:MovieClip = null;
         this.removeEvents();
         this.clear();
         this._staticBuilding.gotoAndStop(this._stage + 1);
         if(this._stage != 0 && !DrgnBoatBuildManager.instance.isMcPlay)
         {
            mc = this._staticBuilding["boat" + this._stage] as MovieClip;
            mc.gotoAndStop(mc.totalFrames);
         }
         DrgnBoatBuildManager.instance.isMcPlay = false;
         if(!this._isSelf)
         {
            this._titleBmp.visible = false;
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.titleTxt");
            addChild(this._titleTxt);
            this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.descriptionTxt");
            addChild(this._descriptionTxt);
            this._descriptionTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.description");
            this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.helpBuildBtn");
            addChild(this._btn);
            this._backBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.backBtn");
            addChild(this._backBtn);
         }
         else
         {
            this._titleBmp.visible = true;
            switch(this._stage)
            {
               case 0:
                  this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.descriptionTxt");
                  addChild(this._descriptionTxt);
                  this._descriptionTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.description3");
                  this._ownImg = ComponentFactory.Instance.creat("drgnBoatBuild.ownImg");
                  addChild(this._ownImg);
                  this._ownedBeard = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.ownedTxt");
                  addChild(this._ownedBeard);
                  this._ownedWood = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.ownedTxt");
                  PositionUtils.setPos(this._ownedWood,"drgnBoatBuild.ownedTxtPos2");
                  addChild(this._ownedWood);
                  this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.commitBtn");
                  addChild(this._btn);
                  configArr = ServerConfigManager.instance.getDragonBoatBuildStage(0);
                  temArr = configArr[0].split(",");
                  count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(int(temArr[0]));
                  this._ownedWood.text = count + "/" + temArr[1];
                  temArr = configArr[1].split(",");
                  count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(int(temArr[0]));
                  this._ownedBeard.text = count + "/" + temArr[1];
                  break;
               case 1:
                  this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.descriptionTxt");
                  addChild(this._descriptionTxt);
                  PositionUtils.setPos(this._descriptionTxt,"drgnBoatBuild.descriptionTxtPos");
                  this._itemBg = ComponentFactory.Instance.creat("drgnBoatBuild.itemBg");
                  addChild(this._itemBg);
                  this._cell = new BagCell(0);
                  PositionUtils.setPos(this._cell,"drgnBoatBuild.cellPos");
                  addChild(this._cell);
                  this._cell.scaleX = 1.3;
                  this._cell.scaleY = 1.3;
                  this._countTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.countTxt");
                  addChild(this._countTxt);
                  this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.secondBuildBtn");
                  addChild(this._btn);
                  configArr = ServerConfigManager.instance.getDragonBoatBuildStage(1);
                  temArr = configArr[0].split(",");
                  count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(int(temArr[0]));
                  this._countTxt.text = count + "/" + temArr[1];
                  this._descriptionTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.description2",temArr[1]);
                  item = new InventoryItemInfo();
                  item.TemplateID = temArr[0];
                  item = ItemManager.fill(item);
                  item.BindType = 4;
                  this._cell.info = item;
                  this._cell.setCountNotVisible();
                  break;
               case 2:
                  this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.descriptionTxt");
                  addChild(this._descriptionTxt);
                  PositionUtils.setPos(this._descriptionTxt,"drgnBoatBuild.descriptionTxtPos");
                  this._itemBg = ComponentFactory.Instance.creat("drgnBoatBuild.itemBg");
                  addChild(this._itemBg);
                  this._cell = new BagCell(0);
                  PositionUtils.setPos(this._cell,"drgnBoatBuild.cellPos");
                  addChild(this._cell);
                  this._cell.scaleX = 1.3;
                  this._cell.scaleY = 1.3;
                  this._countTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.countTxt");
                  addChild(this._countTxt);
                  this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.thirdBuildBtn");
                  addChild(this._btn);
                  configArr = ServerConfigManager.instance.getDragonBoatBuildStage(2);
                  temArr = configArr[0].split(",");
                  count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(int(temArr[0]));
                  this._countTxt.text = count + "/" + temArr[1];
                  this._descriptionTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.description2",temArr[1]);
                  item = new InventoryItemInfo();
                  item.TemplateID = temArr[0];
                  item = ItemManager.fill(item);
                  item.BindType = 4;
                  this._cell.info = item;
                  this._cell.setCountNotVisible();
                  break;
               case 3:
                  this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.descriptionTxt");
                  addChild(this._descriptionTxt);
                  PositionUtils.setPos(this._descriptionTxt,"drgnBoatBuild.descriptionTxtPos");
                  this._itemBg = ComponentFactory.Instance.creat("drgnBoatBuild.itemBg");
                  addChild(this._itemBg);
                  this._cell = new BagCell(0);
                  PositionUtils.setPos(this._cell,"drgnBoatBuild.cellPos");
                  addChild(this._cell);
                  this._cell.scaleX = 1.3;
                  this._cell.scaleY = 1.3;
                  this._countTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.countTxt");
                  addChild(this._countTxt);
                  this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.finalBuildBtn");
                  addChild(this._btn);
                  configArr = ServerConfigManager.instance.getDragonBoatBuildStage(3);
                  temArr = configArr[0].split(",");
                  count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(int(temArr[0]));
                  this._countTxt.text = count + "/" + temArr[1];
                  this._descriptionTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.description2",temArr[1]);
                  item = new InventoryItemInfo();
                  item.TemplateID = temArr[0];
                  item = ItemManager.fill(item);
                  item.BindType = 4;
                  this._cell.info = item;
                  this._cell.setCountNotVisible();
                  break;
               case 4:
                  this._complete = ComponentFactory.Instance.creat("drgnBoatBuild.buildComplete");
                  addChild(this._complete);
            }
         }
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._backBtn))
         {
            this._backBtn.addEventListener(MouseEvent.CLICK,this.__backBtnClick);
         }
         DrgnBoatBuildManager.instance.addEventListener(DrgnBoatBuildEvent.UPDATE_VIEW,this.__update);
      }
      
      protected function __backBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.updateDrgnBoatBuildInfo();
      }
      
      protected function __btnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isSelf)
         {
            switch(this._stage)
            {
               case 0:
               case 1:
               case 2:
               case 3:
                  SocketManager.Instance.out.commitDrgnBoatMaterial(this._stage);
            }
         }
         else
         {
            SocketManager.Instance.out.helpToBuildDrgnBoat(this._userId);
         }
      }
      
      protected function __update(event:DrgnBoatBuildEvent) : void
      {
         var complete:int = 0;
         var info:DrgnBoatBuildCellInfo = event.info as DrgnBoatBuildCellInfo;
         this._progress.setData(info.progress,info.stage,1000);
         this._userId = info.id;
         this._isSelf = this._userId == PlayerManager.Instance.Self.ID;
         this._stage = info.stage;
         this.setView();
         ObjectUtils.disposeObject(this._tipTouchArea);
         this._tipTouchArea = null;
         if(!this._isSelf)
         {
            if(Boolean(info.playerinfo))
            {
               this._titleTxt.text = info.playerinfo.NickName;
            }
         }
         else
         {
            complete = 0;
            switch(info.stage)
            {
               case 1:
                  complete = 330;
                  break;
               case 2:
                  complete = 660;
                  break;
               case 3:
                  complete = 990;
            }
            if(info.progress < complete)
            {
               this._btn.enable = false;
               this.createTipArea();
            }
         }
      }
      
      private function createTipArea() : void
      {
         this._tipTouchArea = new Component();
         this._tipTouchArea.graphics.beginFill(0,0);
         this._tipTouchArea.graphics.drawRect(0,0,this._btn.width,this._btn.height);
         this._tipTouchArea.graphics.endFill();
         this._tipTouchArea.x = this._btn.x;
         this._tipTouchArea.y = this._btn.y;
         addChild(this._tipTouchArea);
         this._tipTouchArea.tipStyle = "ddt.view.tips.OneLineTip";
         this._tipTouchArea.tipDirctions = "5";
         this._tipTouchArea.tipData = LanguageMgr.GetTranslation("drgnBoatBuild.tipData");
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._backBtn))
         {
            this._backBtn.removeEventListener(MouseEvent.CLICK,this.__backBtnClick);
         }
         DrgnBoatBuildManager.instance.removeEventListener(DrgnBoatBuildEvent.UPDATE_VIEW,this.__update);
      }
      
      private function clear() : void
      {
         ObjectUtils.disposeObject(this._descriptionTxt);
         this._descriptionTxt = null;
         ObjectUtils.disposeObject(this._ownImg);
         this._ownImg = null;
         ObjectUtils.disposeObject(this._ownedBeard);
         this._ownedBeard = null;
         ObjectUtils.disposeObject(this._ownedWood);
         this._ownedWood = null;
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._complete);
         this._complete = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._backBtn);
         this._backBtn = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.clear();
         ObjectUtils.disposeObject(this._leftBg);
         this._leftBg = null;
         ObjectUtils.disposeObject(this._titleBmp);
         this._titleBmp = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._staticBuilding);
         this._staticBuilding = null;
         ObjectUtils.disposeObject(this._tipTouchArea);
         this._tipTouchArea = null;
      }
   }
}

