package magicStone.stoneExploreView
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   
   public class StoneExploreNextView extends Sprite
   {
      
      private var ACTIVITYDUNGEONPOINTSNUM:String = "asset.game.nextView.count_";
      
      private var _numBitmapArray:Array;
      
      private var _cdData:Number = 0;
      
      private var _id:int;
      
      private var _bg:Bitmap;
      
      private var _nextBtn:BaseButton;
      
      private var _quitBtn:BaseButton;
      
      private var _hBox:HBox;
      
      private var _isNext:Boolean;
      
      private var _playerBlood:int;
      
      private var _quiTxt:FilterFrameText;
      
      private var _posStr:String = "333,-302|307,-302|277,-302|243,-302|210,-302|165,-302|127,-302";
      
      public function StoneExploreNextView(id:int, isNext:Boolean = false)
      {
         super();
         this._id = id;
         this._isNext = isNext;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         mouseChildren = true;
         this._playerBlood = PlayerManager.Instance.Self.Blood;
         this._bg = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.BG");
         addChild(this._bg);
         this._quitBtn = ComponentFactory.Instance.creat("magicStone.StoneExploreNextView.quitBtn");
         addChild(this._quitBtn);
         if(this._isNext)
         {
            this._nextBtn = ComponentFactory.Instance.creat("magicStone.StoneExploreNextView.nextBtn");
            addChild(this._nextBtn);
         }
         else
         {
            PositionUtils.setPos(this._quitBtn,"magicStone.StoneExploreNextView.quitBtnPos");
         }
      }
      
      public function setQuitPos() : void
      {
         this._quiTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.StoneExploreNextView.quiTxt");
         this._quiTxt.text = LanguageMgr.GetTranslation("magicStone.StoneExploreNextView.quiTxtLG");
         addChild(this._quiTxt);
      }
      
      private function initEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnHandler);
         }
         this._quitBtn.addEventListener(MouseEvent.CLICK,this.__quitBtnHandler);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __nextBtnHandler(evt:MouseEvent) : void
      {
         GameInSocketOut.sendGameMissionStart(this._isNext);
         this.dispose();
      }
      
      private function __quitBtnHandler(evt:MouseEvent) : void
      {
         GameManager.exploreOver = true;
         StateManager.setState(StateType.MAIN);
      }
      
      public function setData(info:Array) : void
      {
         var posArr:Array = null;
         var infoArr:Array = null;
         var arr:Array = null;
         var sprite:Sprite = null;
         var itemInfo:ItemTemplateInfo = null;
         var cell:BagCell = null;
         var cellBg:Bitmap = null;
         var obj:Object = new Object();
         if(info.length <= this._posStr.length)
         {
            posArr = this._posStr.split("|");
            infoArr = posArr[info.length - 1].toString().split(",");
            obj.x = int(infoArr[0]);
            obj.y = int(infoArr[1]);
         }
         else
         {
            obj.x = 130;
            obj.y = -302;
         }
         this._hBox = new HBox();
         this._hBox.spacing = 8;
         PositionUtils.setPos(this._hBox,obj);
         for(var i:int = 0; i < info.length; i++)
         {
            arr = info[i].toString().split(",");
            sprite = new Sprite();
            itemInfo = ItemManager.Instance.getTemplateById(arr[0]) as ItemTemplateInfo;
            itemInfo.Level = 1;
            cell = new BagCell(0,itemInfo,false);
            cell.setCount(arr[1]);
            cell.x = 5;
            cell.y = 5;
            cell.setBgVisible(false);
            cellBg = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.GoodsFrame");
            sprite.addChild(cellBg);
            sprite.addChild(cell);
            this._hBox.addChild(sprite);
         }
         addChild(this._hBox);
      }
      
      public function setBtnEnable() : void
      {
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.enable = false;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
            this._hBox = null;
         }
         if(Boolean(this._quiTxt))
         {
            ObjectUtils.disposeObject(this._quiTxt);
            this._quiTxt = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnHandler);
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._quitBtn))
         {
            this._quitBtn.removeEventListener(MouseEvent.CLICK,this.__quitBtnHandler);
            this._quitBtn.dispose();
            this._quitBtn = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
      
      public function get Id() : int
      {
         return this._id;
      }
   }
}

