package rescue.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hall.hallInfo.playerInfo.ImgNumConverter;
   import rescue.data.RescueRoomInfo;
   
   public class RescueRoomItemView extends Sprite implements Disposeable
   {
      
      private var _openSp:Sprite;
      
      private var _closeSp:Sprite;
      
      private var _openBg:Bitmap;
      
      private var _closeBg:Bitmap;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _sceneImg:Bitmap;
      
      private var _scoreTxt:Sprite;
      
      private var _arrowTxt:Sprite;
      
      private var _arrowTxt2:Sprite;
      
      private var _bloodBagTxt:Sprite;
      
      private var _sceneId:int = -1;
      
      public function RescueRoomItemView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._openSp = new Sprite();
         addChild(this._openSp);
         this._closeSp = new Sprite();
         addChild(this._closeSp);
         this._closeSp.visible = false;
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("rescue.room.closeBtn");
         this._openSp.addChild(this._closeBtn);
         this._openBg = ComponentFactory.Instance.creat("rescue.roomInfo.openBg");
         this._openSp.addChild(this._openBg);
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("rescue.room.openBtn");
         this._closeSp.addChild(this._openBtn);
         this._closeBg = ComponentFactory.Instance.creat("rescue.roomInfo.closeBg");
         this._closeSp.addChild(this._closeBg);
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         this._scoreTxt = ImgNumConverter.instance.convertToImg(0,"rescue.room.num",11);
         PositionUtils.setPos(this._scoreTxt,"rescue.room.scoreTxtPos");
         this._openSp.addChild(this._scoreTxt);
         ObjectUtils.disposeObject(this._arrowTxt);
         this._arrowTxt = null;
         this._arrowTxt = ImgNumConverter.instance.convertToImg(0,"rescue.room.num",11);
         PositionUtils.setPos(this._arrowTxt,"rescue.room.arrowTxtPos");
         this._openSp.addChild(this._arrowTxt);
         ObjectUtils.disposeObject(this._arrowTxt2);
         this._arrowTxt2 = null;
         this._arrowTxt2 = ImgNumConverter.instance.convertToImg(0,"rescue.room.num",11);
         PositionUtils.setPos(this._arrowTxt2,"rescue.room.arrowTxt2Pos");
         this._openSp.addChild(this._arrowTxt2);
         ObjectUtils.disposeObject(this._bloodBagTxt);
         this._bloodBagTxt = null;
         this._bloodBagTxt = ImgNumConverter.instance.convertToImg(0,"rescue.room.num",11);
         PositionUtils.setPos(this._bloodBagTxt,"rescue.room.bloodBagTxtPos");
         this._openSp.addChild(this._bloodBagTxt);
      }
      
      private function initEvents() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openBtnClick);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeBtnClick);
      }
      
      protected function __closeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._openSp.visible = false;
         this._closeSp.visible = true;
      }
      
      protected function __openBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._openSp.visible = true;
         this._closeSp.visible = false;
      }
      
      public function update(info:RescueRoomInfo) : void
      {
         if(info.sceneId != this._sceneId)
         {
            ObjectUtils.disposeObject(this._sceneImg);
            this._sceneImg = null;
            this._sceneImg = ComponentFactory.Instance.creat("rescue.scene" + info.sceneId);
            PositionUtils.setPos(this._sceneImg,"rescue.room.sceneImgPos");
            this._openSp.addChild(this._sceneImg);
            this._sceneId = info.sceneId;
         }
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         this._scoreTxt = ImgNumConverter.instance.convertToImg(info.score,"rescue.room.num",11);
         PositionUtils.setPos(this._scoreTxt,"rescue.room.scoreTxtPos");
         this._openSp.addChild(this._scoreTxt);
         ObjectUtils.disposeObject(this._arrowTxt);
         this._arrowTxt = null;
         this._arrowTxt = ImgNumConverter.instance.convertToImg(info.defaultArrow,"rescue.room.num",11);
         PositionUtils.setPos(this._arrowTxt,"rescue.room.arrowTxtPos");
         this._openSp.addChild(this._arrowTxt);
         ObjectUtils.disposeObject(this._arrowTxt2);
         this._arrowTxt2 = null;
         this._arrowTxt2 = ImgNumConverter.instance.convertToImg(info.arrow,"rescue.room.num",11);
         PositionUtils.setPos(this._arrowTxt2,"rescue.room.arrowTxt2Pos");
         this._openSp.addChild(this._arrowTxt2);
         ObjectUtils.disposeObject(this._bloodBagTxt);
         this._bloodBagTxt = null;
         this._bloodBagTxt = ImgNumConverter.instance.convertToImg(info.bloodBag,"rescue.room.num",11);
         PositionUtils.setPos(this._bloodBagTxt,"rescue.room.bloodBagTxtPos");
         this._openSp.addChild(this._bloodBagTxt);
      }
      
      private function removeEvents() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openBtnClick);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeBtnClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this._openSp = null;
         this._closeSp = null;
         this._openBg = null;
         this._closeBg = null;
         this._openBtn = null;
         this._closeBtn = null;
         this._sceneImg = null;
         this._scoreTxt = null;
         this._arrowTxt = null;
         this._arrowTxt2 = null;
         this._bloodBagTxt = null;
      }
   }
}

