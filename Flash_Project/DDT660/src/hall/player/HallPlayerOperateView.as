package hall.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import hall.event.NewHallEvent;
   import hall.player.vo.PlayerVO;
   
   public class HallPlayerOperateView extends Sprite
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 150;
      
      private var _bg:Bitmap;
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headSprite:Sprite;
      
      private var _nickName:FilterFrameText;
      
      private var _operateSprite:Sprite;
      
      private var _operate:FilterFrameText;
      
      private var _upDownBtn:ScaleFrameImage;
      
      private var _playerTips:HallPlayerTips;
      
      private var _playerInfo:PlayerInfo;
      
      public function HallPlayerOperateView()
      {
         super();
         this.visible = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("hall.player.operate.bg");
         addChild(this._bg);
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("hall.playerOperate.nickNameTxt");
         addChild(this._nickName);
         this._operateSprite = new Sprite();
         PositionUtils.setPos(this._operateSprite,"hall.playerView.playerOperate.operateBtnPos");
         this._operateSprite.buttonMode = true;
         addChild(this._operateSprite);
         this._operate = ComponentFactory.Instance.creatComponentByStylename("hall.playerOperate.operateTxt");
         this._operate.text = LanguageMgr.GetTranslation("operate");
         this._operateSprite.addChild(this._operate);
         this._upDownBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerOperate.upDownBtn");
         this._operateSprite.addChild(this._upDownBtn);
         this._upDownBtn.setFrame(1);
         this._playerTips = new HallPlayerTips();
         PositionUtils.setPos(this._playerTips,"hall.playerView.playerOperate.tipPos");
         addChild(this._playerTips);
         this._playerTips.mouseEnabled = true;
         this._playerTips.mouseChildren = true;
         this._playerTips.visible = false;
      }
      
      public function loadHead() : void
      {
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         if(Boolean(this._headSprite))
         {
            ObjectUtils.disposeAllChildren(this._headSprite);
            this._headSprite = null;
         }
         this._headLoader = new SceneCharacterLoaderHead(this._playerInfo);
         this._headLoader.load(this.headLoaderCallBack);
      }
      
      private function initEvent() : void
      {
         this._operateSprite.addEventListener(MouseEvent.CLICK,this.__onClick);
         this._playerTips.addEventListener(MouseEvent.CLICK,this.__onTipsClick);
         PlayerManager.Instance.addEventListener(NewHallEvent.UPDATETIPSINFO,this.__onUpdateInfo);
      }
      
      protected function __onTipsClick(event:MouseEvent) : void
      {
         this._upDownBtn.setFrame(1);
      }
      
      protected function __onUpdateInfo(event:NewHallEvent) : void
      {
         var playerVo:PlayerVO = event.data[0];
         if(Boolean(playerVo))
         {
            this.visible = true;
            this._playerInfo = playerVo.playerInfo;
            this.loadHead();
            this._nickName.text = this._playerInfo.NickName;
            this._playerTips.setInfo(this._playerInfo.NickName,this._playerInfo.ID);
         }
         else
         {
            this._upDownBtn.setFrame(1);
            this._playerTips.visible = false;
            this.visible = false;
         }
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
         event.stopPropagation();
         if(this._upDownBtn.getFrame == 1)
         {
            this._upDownBtn.setFrame(2);
            this._playerTips.visible = true;
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick);
         }
         else
         {
            this._upDownBtn.setFrame(1);
            this._playerTips.visible = false;
         }
      }
      
      protected function __onStageClick(event:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick);
         this._upDownBtn.setFrame(1);
         this._playerTips.visible = false;
      }
      
      private function headLoaderCallBack(headLoader:SceneCharacterLoaderHead, isAllLoadSucceed:Boolean = true) : void
      {
         var headBitmap:Bitmap = null;
         var rectangle:Rectangle = null;
         var headBmp:BitmapData = null;
         var mask:Sprite = null;
         if(Boolean(headLoader))
         {
            this._headSprite = new Sprite();
            PositionUtils.setPos(this._headSprite,"hall.playerView.playerOperate.headPos");
            addChild(this._headSprite);
            headBitmap = new Bitmap();
            rectangle = new Rectangle(0,0,HeadWidth,HeadHeight);
            headBmp = new BitmapData(HeadWidth,HeadHeight,true,0);
            headBmp.copyPixels(headLoader.getContent()[0] as BitmapData,rectangle,new Point(0,0));
            headBitmap.bitmapData = headBmp;
            headLoader.dispose();
            headBitmap.rotationY = 180;
            headBitmap.scaleY = 0.8;
            headBitmap.scaleX = 0.8;
            mask = ComponentFactory.Instance.creat("hall.player.operate.mask");
            PositionUtils.setPos(mask,"hall.playerView.playerOperate.maskPos");
            this._headSprite.mask = mask;
            this._headSprite.addChild(headBitmap);
            this._headSprite.addChild(mask);
         }
      }
      
      private function removeEvent() : void
      {
         this._operateSprite.removeEventListener(MouseEvent.CLICK,this.__onClick);
         this._playerTips.removeEventListener(MouseEvent.CLICK,this.__onTipsClick);
         PlayerManager.Instance.removeEventListener(NewHallEvent.UPDATETIPSINFO,this.__onUpdateInfo);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._operateSprite))
         {
            ObjectUtils.disposeAllChildren(this._operateSprite);
            this._operateSprite = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

