package equipretrieve.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import equipretrieve.effect.MovieClipControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.StoreCell;
   
   public class RetrieveBgView extends Sprite implements Disposeable
   {
      
      private var _retrieveBt:SelectedButton;
      
      private var _helpBt:SelectedButton;
      
      private var _needGoldText:FilterFrameText;
      
      private var _GoldBitmap:Bitmap;
      
      private var _background:MovieImage;
      
      private var _dropArea:RetrieveDragInArea;
      
      private var _pointArray:Vector.<Point>;
      
      private var _cells:Vector.<StoreCell>;
      
      private var _moveCells:Vector.<StoreCell>;
      
      private var _tweenInt:int = 0;
      
      private var _retrieveBtLightBoo:Boolean;
      
      private var _startStrthTip:MutipleImage;
      
      private var _trieveShine:MovieImage;
      
      private var _retrieveffect:IEffect;
      
      private var _effectMcArr:Vector.<MovieImage>;
      
      private var _titleBg:Bitmap;
      
      private var _needMoneyIcon:Bitmap;
      
      public function RetrieveBgView()
      {
         super();
         this._initView();
         this.addEvt();
      }
      
      public function _initView() : void
      {
         this._retrieveBt = ComponentFactory.Instance.creatComponentByStylename("retrieve.retrieveBt");
         this._trieveShine = ComponentFactory.Instance.creatComponentByStylename("retrieve.trieveBtShine");
         this._trieveShine.mouseEnabled = false;
         this._trieveShine.mouseChildren = false;
         this._needGoldText = ComponentFactory.Instance.creatComponentByStylename("retrieve.needGold");
         this._GoldBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcore.Gold");
         this._helpBt = ComponentFactory.Instance.creatComponentByStylename("retrieve.helpBt");
         this._dropArea = new RetrieveDragInArea(this._cells);
         this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("trieve.ArrowHeadTip");
         this._needMoneyIcon = ComponentFactory.Instance.creatBitmap("asset.retrieveFrame.needMoneyIcon");
         this._getCellsPoint();
         this._buildCell();
         addChild(this._trieveShine);
         addChild(this._retrieveBt);
         addChild(this._helpBt);
         addChild(this._needGoldText);
         addChild(this._needMoneyIcon);
         addChild(this._GoldBitmap);
         addChild(this._startStrthTip);
         this._retrieveBtLightBoo = false;
         this.hideArr();
      }
      
      private function _getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 5; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("equipretrieve.cellPoint" + i);
            this._pointArray.push(point);
         }
      }
      
      private function _buildCell() : void
      {
         var i:int = 0;
         var _cell:StoreCell = null;
         var _moveCell:StoreCell = null;
         this._cells = new Vector.<StoreCell>();
         this._moveCells = new Vector.<StoreCell>();
         for(i = 0; i < 5; i++)
         {
            if(i == 0)
            {
               _cell = new RetrieveResultCell(i);
               _moveCell = new RetrieveResultCell(i);
               addChild(_cell);
               addChild(_moveCell);
               addChild(this._dropArea);
            }
            else
            {
               _cell = new RetrieveCell(i);
               _moveCell = new RetrieveCell(i);
               addChild(_cell);
               addChild(_moveCell);
            }
            _moveCell.x = _cell.x = this._pointArray[i].x;
            _moveCell.y = _cell.y = this._pointArray[i].y;
            this._cells[i] = _cell;
            _moveCell.visible = false;
            _moveCell.BGVisible = false;
            this._moveCells[i] = _moveCell;
            RetrieveModel.Instance.setSaveCells(_cell,i);
         }
      }
      
      public function startShine() : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            this._cells[i].startShine();
         }
      }
      
      public function stopShine() : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            this._cells[i].stopShine();
         }
      }
      
      private function addEvt() : void
      {
         this._helpBt.addEventListener(MouseEvent.CLICK,this.clickHelpBt);
         this._retrieveBt.addEventListener(MouseEvent.CLICK,this.executeRetrieve);
      }
      
      private function removeEvt() : void
      {
         this._helpBt.removeEventListener(MouseEvent.CLICK,this.clickHelpBt);
         this._retrieveBt.removeEventListener(MouseEvent.CLICK,this.executeRetrieve);
      }
      
      private function clickHelpBt(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpInfoFrame:RetrieveHelpFrame = ComponentFactory.Instance.creatComponentByStylename("retrieve.helpFrame");
         LayerManager.Instance.addToLayer(helpInfoFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function showArr() : void
      {
         this._startStrthTip.visible = true;
         this._trieveShine.visible = true;
         this._trieveShine.movie.gotoAndPlay(1);
      }
      
      private function hideArr() : void
      {
         this._trieveShine.visible = false;
         this._trieveShine.movie.stop();
         this._startStrthTip.visible = false;
      }
      
      private function executeRetrieve(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var alert1:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         for(var i:int = 1; i < this._cells.length; i++)
         {
            if(this._cells[i].info == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.equipretrieve.countlack"));
               return;
            }
         }
         if(int(this._needGoldText.text) > PlayerManager.Instance.Self.Gold)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         var count:int = 0;
         for(var j:int = 1; j < this._cells.length; j++)
         {
            if(this._cells[j].itemInfo.IsBinds == true)
            {
               count++;
            }
         }
         if(count > 0 && count < 4)
         {
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.info.enableHtml = true;
            alert1.info.mutiline = true;
            alert1.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
            return;
         }
         RetrieveController.Instance.viewMouseEvtBoolean = false;
         SocketManager.Instance.out.sendEquipRetrieve();
      }
      
      private function _bingResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            RetrieveController.Instance.viewMouseEvtBoolean = false;
            SocketManager.Instance.out.sendEquipRetrieve();
         }
         ObjectUtils.disposeObject(alert);
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         for(place in items)
         {
            if(place != "0")
            {
               itemPlace = int(place);
               this._cells[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[place];
               if(!PlayerManager.Instance.Self.StoreBag.items["0"])
               {
                  RetrieveModel.Instance.setSaveInfo(PlayerManager.Instance.Self.StoreBag.items[place],itemPlace);
               }
            }
         }
         if(Boolean(this._cells["1"].info) && Boolean(this._cells["2"].info) && Boolean(this._cells["3"].info) && Boolean(this._cells["4"].info))
         {
            this.showArr();
         }
         else
         {
            this.hideArr();
         }
         if(Boolean(items["0"]) && Boolean(PlayerManager.Instance.Self.StoreBag.items["0"]))
         {
            this._moveCells[0].info = items["0"];
            RetrieveModel.Instance.setSaveInfo(this._moveCells[0].itemInfo,0);
            if(Boolean(this._moveCells[0].info) && EquipType.isEquipBoolean(this._moveCells[0].info))
            {
               RetrieveController.Instance.retrieveType = 0;
            }
            else
            {
               RetrieveController.Instance.retrieveType = 1;
            }
            this._cellslightMovie();
         }
      }
      
      public function cellDoubleClick(cell:RetrieveBagcell) : void
      {
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         for(var i:int = 1; i < this._cells.length; i++)
         {
            if(this._cells[i].info == null)
            {
               SocketManager.Instance.out.sendMoveGoods(cell.bagType,info.Place,BagInfo.STOREBAG,i);
               RetrieveModel.Instance.setSavePlaceType(info,i);
               return;
            }
         }
         SocketManager.Instance.out.sendMoveGoods(cell.bagType,info.Place,BagInfo.STOREBAG,1);
         RetrieveModel.Instance.setSaveInfo(info,1);
         RetrieveModel.Instance.setSavePlaceType(info,1);
      }
      
      public function returnBag() : void
      {
         var place:String = null;
         for(place in this._cells)
         {
            if(Boolean(this._cells[place].info))
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,int(place),int(!EquipType.isEquipBoolean(this._cells[place].info)),-1);
            }
         }
      }
      
      private function _cellslightMovie() : void
      {
         var animation:GlowFilterAnimation = null;
         if(!this._moveCells)
         {
            return;
         }
         var animationControl:AnimationControl = new AnimationControl();
         animationControl.addEventListener(Event.COMPLETE,this._cellslightMovieOver);
         for(var i:int = 1; i < this._moveCells.length; i++)
         {
            this._moveCells[i].info = RetrieveModel.Instance.getSaveCells(i).info;
            this._moveCells[i].visible = true;
            animation = new GlowFilterAnimation();
            animation.start(this._moveCells[i]);
            animation.addMovie(0,0,4);
            animation.addMovie(15,15,4);
            animation.addMovie(15,15,2);
            animation.addMovie(0,0,4);
            animation.addMovie(0,0,2);
            animation.addMovie(15,15,4);
            animation.addMovie(15,15,2);
            animation.addMovie(0,0,4);
            animationControl.addMovies(animation);
         }
         SoundManager.instance.play("147");
         animationControl.startMovie();
      }
      
      private function _cellslightMovieOver(e:Event) : void
      {
         e.currentTarget.removeEventListener(Event.COMPLETE,this._cellslightMovieOver);
         this._cellsMove();
      }
      
      private function _cellsMove() : void
      {
         if(!this._moveCells)
         {
            return;
         }
         var tweenline:TimelineLite = new TimelineLite({"onComplete":this._tweenlineComplete});
         var arrAct0:Array = new Array();
         var arrAct1:Array = new Array();
         for(var i:int = 1; i < this._moveCells.length; i++)
         {
            arrAct0.push(TweenLite.to(this._moveCells[i],0.3,{
               "x":this._moveCells[0].x + 12,
               "y":this._moveCells[0].y + 12
            }));
            arrAct1.push(TweenLite.to(this._moveCells[i],0.2,{
               "scaleX":0.5,
               "scaleY":0.5,
               "x":this._moveCells[0].x + 30,
               "y":this._moveCells[0].y + 30
            }));
         }
         tweenline.appendMultiple(arrAct0);
         tweenline.appendMultiple(arrAct1);
      }
      
      private function _tweenlineComplete() : void
      {
         var i:int = 0;
         var centerX:Number = NaN;
         var centerY:Number = NaN;
         var moveToY:Number = NaN;
         if(!this._moveCells)
         {
            return;
         }
         for(i = 1; i < this._moveCells.length; i++)
         {
            this._moveCells[i].x = RetrieveModel.Instance.getSaveCells(i).oldx;
            this._moveCells[i].y = RetrieveModel.Instance.getSaveCells(i).oldy;
            this._moveCells[i].scaleX = this._moveCells[i].scaleY = 1;
            this._moveCells[i].visible = false;
         }
         var effectMc0:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc0"));
         var effectMc1:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc1"));
         var effectMc2:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc2"));
         var effectMc3:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc3"));
         var effectMc4:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc4"));
         var movieControl:MovieClipControl = new MovieClipControl(45);
         addChild(effectMc0);
         addChild(effectMc1);
         addChild(effectMc2);
         addChild(this._moveCells[0]);
         addChild(effectMc3);
         addChild(effectMc4);
         this._effectMcArr = new Vector.<MovieImage>();
         this._effectMcArr.push(effectMc0);
         this._effectMcArr.push(effectMc1);
         this._effectMcArr.push(effectMc2);
         this._effectMcArr.push(effectMc3);
         this._effectMcArr.push(effectMc4);
         movieControl.addMovies(effectMc0.movie,1,effectMc0.movie.totalFrames);
         movieControl.addMovies(effectMc1.movie,1,effectMc1.movie.totalFrames);
         movieControl.addMovies(effectMc2.movie,1,effectMc2.movie.totalFrames);
         movieControl.addMovies(effectMc3.movie,2,effectMc3.movie.totalFrames);
         movieControl.addMovies(effectMc4.movie,5,effectMc4.movie.totalFrames);
         movieControl.startMovie();
         var tweenline:TimelineLite = new TimelineLite({"onComplete":this._tweenline1Complete});
         this._moveCells[0].info = RetrieveModel.Instance.getSaveCells(0).info;
         this._moveCells[0].visible = true;
         this._moveCells[0].scaleX = this._moveCells[0].scaleY = 0.2;
         centerX = this._moveCells[0].x + this._moveCells[0].width / 2;
         centerY = this._moveCells[0].y + this._moveCells[0].height / 2;
         var oldWidth:Number = this._moveCells[0].width / 2;
         var oldHeight:Number = this._moveCells[0].height / 2;
         var moveToX:Number = RetrieveModel.Instance.getresultCell().point.x - this.localToGlobal(new Point(this._moveCells[0].x,this._moveCells[0].y)).x + this._moveCells[0].x;
         moveToY = RetrieveModel.Instance.getresultCell().point.y - this.localToGlobal(new Point(this._moveCells[0].x,this._moveCells[0].y)).y + this._moveCells[0].y;
         this._moveCells[0].scaleX = this._moveCells[0].scaleY = 0.2;
         this._moveCells[0].x = centerX - 0.2 * oldWidth;
         this._moveCells[0].y = centerY - 0.2 * oldHeight;
         tweenline.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":0.2,
            "scaleY":0.2,
            "x":centerX - 0.2 * oldWidth,
            "y":centerY - 0.2 * oldHeight
         }));
         tweenline.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":0.8,
            "scaleY":0.8,
            "x":centerX - 0.8 * oldWidth,
            "y":centerY - 0.8 * oldHeight
         }));
         tweenline.append(TweenLite.to(this._moveCells[0],1.3,{
            "scaleX":0.8,
            "scaleY":0.8,
            "x":centerX - 0.8 * oldWidth,
            "y":centerY - 0.8 * oldHeight
         }));
         tweenline.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":1.2,
            "scaleY":1.2,
            "x":centerX - 1.2 * oldWidth,
            "y":centerY - 1.2 * oldHeight
         }));
         tweenline.append(TweenLite.to(this._moveCells[0],0.5,{
            "scaleX":0.5,
            "scaleY":0.5,
            "x":moveToX,
            "y":moveToY
         }));
      }
      
      private function _tweenline1Complete() : void
      {
         for(var i:int = 0; i < this._effectMcArr.length; i++)
         {
            if(Boolean(this._effectMcArr[i]))
            {
               ObjectUtils.disposeObject(this._effectMcArr[i]);
            }
            this._effectMcArr[i] = null;
         }
         if(!this._moveCells)
         {
            return;
         }
         this._moveCells[0].x = RetrieveModel.Instance.getSaveCells(0).oldx;
         this._moveCells[0].y = RetrieveModel.Instance.getSaveCells(0).oldy;
         this._moveCells[0].scaleY = 1;
         this._moveCells[0].scaleX = 1;
         this._moveCells[0].visible = false;
         if(RetrieveModel.Instance.isFull == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.equipretrieve.success"));
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,0,RetrieveModel.Instance.getresultCell().bagType,-1);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,0,RetrieveModel.Instance.getresultCell().bagType,-1);
         }
         RetrieveController.Instance.viewMouseEvtBoolean = true;
      }
      
      public function clearCellInfo() : void
      {
         if(!this._cells)
         {
            return;
         }
         var tmp:int = int(this._cells.length);
         for(var i:int = 1; i < 5; i++)
         {
            if(Boolean(this._cells[i]))
            {
               this._cells[i].info = null;
            }
         }
         this.hideArr();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._titleBg))
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         if(Boolean(this._retrieveBt))
         {
            ObjectUtils.disposeObject(this._retrieveBt);
         }
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         if(Boolean(this._dropArea))
         {
            ObjectUtils.disposeObject(this._dropArea);
         }
         if(Boolean(this._helpBt))
         {
            ObjectUtils.disposeObject(this._helpBt);
         }
         if(Boolean(this._startStrthTip))
         {
            ObjectUtils.disposeObject(this._startStrthTip);
         }
         if(Boolean(this._trieveShine))
         {
            ObjectUtils.disposeObject(this._trieveShine);
         }
         if(Boolean(this._needGoldText))
         {
            ObjectUtils.disposeObject(this._needGoldText);
         }
         if(Boolean(this._GoldBitmap))
         {
            ObjectUtils.disposeObject(this._GoldBitmap);
         }
         if(Boolean(this._needMoneyIcon))
         {
            ObjectUtils.disposeObject(this._needMoneyIcon);
         }
         this._needGoldText = null;
         this._trieveShine = null;
         this._startStrthTip = null;
         this._pointArray = null;
         this._retrieveBt = null;
         this._helpBt = null;
         this._dropArea = null;
         this._background = null;
         this._GoldBitmap = null;
         this._needMoneyIcon = null;
         this.returnBag();
         for(var place:int = 0; place < this._cells.length; place++)
         {
            if(Boolean(this._cells[place]))
            {
               ObjectUtils.disposeObject(this._cells[place]);
            }
            if(Boolean(this._moveCells[place]))
            {
               ObjectUtils.disposeObject(this._moveCells[place]);
            }
            this._moveCells[place] = null;
            this._cells[place] = null;
         }
         this._cells = null;
         this._moveCells = null;
      }
   }
}

