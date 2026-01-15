package ddt.view.caddyII.celebration
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.LookTrophy;
   import ddt.view.caddyII.RightView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class CelebrationBoxView extends RightView
   {
      
      public static const SELECT_SCALE_NUMBER:Number = 0;
      
      private var _bg:ScaleBitmapImage;
      
      private var _gridBGI:MovieImage;
      
      private var _lookBtn:TextButton;
      
      private var _openBtn:BaseButton;
      
      private var _turnBG:ScaleFrameImage;
      
      private var _movie:MovieImage;
      
      private var _keyBtn:BaseButton;
      
      private var _boxBtn:BaseButton;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectCell:BaseCell;
      
      private var _keyNumberTxt:FilterFrameText;
      
      private var _boxNumberTxt:FilterFrameText;
      
      private var _lookTrophy:LookTrophy;
      
      private var _keyNumber:int;
      
      private var _boxNumber:int;
      
      private var _selectedCount:int;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _endFrame:int;
      
      private var _selectSprite:Sprite;
      
      private var _cellMC:MovieClip;
      
      public function CelebrationBoxView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function setType(val:int) : void
      {
         _type = val;
      }
      
      override public function set item(val:ItemTemplateInfo) : void
      {
         _item = val;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGI");
         var goldBorder:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("bead.rightGrid.goldBorder");
         var goodsNameBG:Image = ComponentFactory.Instance.creatComponentByStylename("caddy.GoodsNameBG");
         var openBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         var numberBG:Image = ComponentFactory.Instance.creatComponentByStylename("caddy.numberI");
         PositionUtils.setPos(numberBG,"celebration.boxNumberBGPos");
         var keyBG:Image = ComponentFactory.Instance.creatComponentByStylename("caddy.numberI");
         PositionUtils.setPos(keyBG,"celebration.keyNumberBGPos");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.LookBtn");
         this._lookBtn.text = LanguageMgr.GetTranslation("tank.view.caddy.lookTrophy");
         this._lookBtn.visible = false;
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._boxBtn = ComponentFactory.Instance.creatComponentByStylename("celebration.BoxBtn");
         this._boxBtn.addChild(this.creatShape());
         this._keyBtn = ComponentFactory.Instance.creatComponentByStylename("celebration.KeyBtn");
         this._keyBtn.addChild(this.creatShape());
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.goodsNameTxt");
         this._boxNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.boxNumberTxt");
         PositionUtils.setPos(this._boxNumberTxt,"celebration.boxNumberTxtPos");
         this._keyNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.keyNumberTxt");
         PositionUtils.setPos(this._keyNumberTxt,"celebration.keyNumberTxtPos");
         this._cellMC = ComponentFactory.Instance.creat("asset.celebration.boxCartoon");
         this._cellMC.gotoAndStop(1);
         PositionUtils.setPos(this._cellMC,"celebration.boxCartoonPos");
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         for(var i:int = 0; i < this._movie.movie.currentLabels.length; i++)
         {
            if(this._movie.movie.currentLabels[i].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[i].frame;
            }
         }
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         _autoCheck.selected = SharedManager.Instance.autoCelebration;
         var font:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.bagHavingTip");
         font.text = LanguageMgr.GetTranslation("tank.view.award.bagHaving");
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(openBG);
         addChild(goldBorder);
         addChild(goodsNameBG);
         addChild(this._goodsNameTxt);
         addChild(font);
         addChild(numberBG);
         addChild(keyBG);
         addChild(this._boxBtn);
         addChild(this._keyBtn);
         addChild(this._boxNumberTxt);
         addChild(this._keyNumberTxt);
         addChild(this._cellMC);
         addChild(_autoCheck);
         this.createSelectCell();
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         addChild(this._lookBtn);
         addChild(this._openBtn);
         var boxItemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.CELEBRATION_BOX);
         if(Boolean(boxItemInfo))
         {
            this._boxBtn.tipData = boxItemInfo.Name;
         }
         var keyItemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.CELEBRATION_KEY);
         if(Boolean(keyItemInfo))
         {
            this._keyBtn.tipData = keyItemInfo.Name;
         }
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CELEBRATION_BOX);
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CELEBRATION_KEY);
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openClick);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
         if(Boolean(this._lookBtn))
         {
            this._lookBtn.removeEventListener(MouseEvent.CLICK,this._look);
         }
         if(Boolean(this._openBtn))
         {
            this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openClick);
         }
         if(Boolean(this._movie) && Boolean(this._movie.movie))
         {
            this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         }
         if(Boolean(_autoCheck))
         {
            _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         }
      }
      
      private function createSelectCell() : void
      {
         var size:Point = ComponentFactory.Instance.creatCustomObject("bead.selectCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._selectCell = new BaseCell(shape);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChild(this._selectSprite);
         this._selectSprite.visible = false;
      }
      
      private function _bagUpdate(event:BagEvent) : void
      {
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CELEBRATION_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CELEBRATION_BOX);
      }
      
      private function _look(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __openClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function openImp() : void
      {
         if(CaddyModel.instance.bagInfo.itemNumber >= 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            return;
         }
         if(this.boxNumber < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.celebration.hasNotOpen",ItemManager.Instance.getTemplateById(EquipType.CELEBRATION_BOX).Name,1));
            return;
         }
         if(this.keyNumber < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.celebration.hasNotOpen",ItemManager.Instance.getTemplateById(EquipType.CELEBRATION_KEY).Name,10));
            return;
         }
         this._openBtn.enable = false;
         SocketManager.Instance.out.sendRouletteBox(BagInfo.CADDYBAG,-4,EquipType.CELEBRATION_BOX);
      }
      
      private function __selectedChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoCelebration = _autoCheck.selected;
      }
      
      private function creatShape(w:Number = 100, h:Number = 25) : Shape
      {
         var size:Point = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyBtn.ButtonSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         return shape;
      }
      
      private function __frameHandler(event:Event) : void
      {
         if(this._movie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectedGoodsInfo.Name;
            this.creatTweenSelectMagnify();
         }
      }
      
      private function creatTweenSelectMagnify() : void
      {
         TweenMax.from(this._selectSprite,0.7,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":320,
            "alpha":20,
            "onComplete":this._moveOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function _moveOk() : void
      {
         setTimeout(this._toMove,400);
      }
      
      private function _toMove() : void
      {
         dispatchEvent(new Event(RightView.START_MOVE_AFTER_TURN));
         if(Boolean(this._selectCell))
         {
            this._selectCell.info = null;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.visible = false;
         }
      }
      
      public function set keyNumber(value:int) : void
      {
         this._keyNumber = value;
         this._keyNumberTxt.text = String(this._keyNumber);
      }
      
      public function get keyNumber() : int
      {
         return this._keyNumber;
      }
      
      public function set boxNumber(value:int) : void
      {
         this._boxNumber = value;
         this._boxNumberTxt.text = String(this._boxNumber);
      }
      
      public function get boxNumber() : int
      {
         return this._boxNumber;
      }
      
      override public function again() : void
      {
         this._cellMC.visible = true;
         this._movie.visible = false;
         this._movie.movie.gotoAndStop(1);
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
         if(SharedManager.Instance.autoCelebration)
         {
            this.openImp();
         }
      }
      
      override public function setSelectGoodsInfo(info:InventoryItemInfo) : void
      {
         SoundManager.instance.play("139");
         this._selectedGoodsInfo = info;
         this._cellMC.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
         this._selectCell.info = this._selectedGoodsInfo;
         this._startTurn();
      }
      
      private function _startTurn() : void
      {
         var evt:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         evt.info = this._selectedGoodsInfo;
         dispatchEvent(evt);
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._selectSprite))
         {
            TweenMax.killTweensOf(this._selectSprite);
         }
         if(Boolean(this._cellMC))
         {
            this._cellMC.gotoAndStop(2);
         }
         this._selectedGoodsInfo = null;
         ObjectUtils.disposeObject(this._selectCell);
         this._selectCell = null;
         ObjectUtils.disposeObject(this._lookTrophy);
         this._lookTrophy = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._gridBGI = null;
         this._lookBtn = null;
         this._openBtn = null;
         this._turnBG = null;
         this._movie = null;
         this._keyBtn = null;
         this._boxBtn = null;
         this._goodsNameTxt = null;
         this._keyNumberTxt = null;
         this._boxNumberTxt = null;
         this._selectSprite = null;
         this._cellMC = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

