package rescue.components
{
   import catchInsect.data.RescueSceneInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class RescueSceneItem extends Sprite implements Disposeable
   {
      
      private var _light:Bitmap;
      
      private var _bg:ScaleFrameImage;
      
      private var _sceneNum:Bitmap;
      
      private var _star:Bitmap;
      
      private var _hBox:HBox;
      
      private var _sceneId:int;
      
      private var _info:RescueSceneInfo;
      
      public function RescueSceneItem(id:int)
      {
         this._sceneId = id;
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("rescue.sceneItemBg");
         addChild(this._bg);
         this._light = ComponentFactory.Instance.creat("rescue.selectedLight");
         addChild(this._light);
         this._light.visible = false;
         this._bg.setFrame(1);
      }
      
      private function initEvents() : void
      {
      }
      
      public function setData(isOpen:Boolean, info:RescueSceneInfo = null) : void
      {
         var i:int = 0;
         if(isOpen)
         {
            this._info = info;
            this._bg.setFrame(1);
            if(!this._sceneNum)
            {
               this._sceneNum = ComponentFactory.Instance.creat("rescue.scene" + this._sceneId);
               PositionUtils.setPos(this._sceneNum,"rescue.sceneNumPos" + this._sceneId);
               addChild(this._sceneNum);
            }
            if(!this._hBox)
            {
               this._hBox = ComponentFactory.Instance.creatComponentByStylename("rescue.starHBox");
               addChild(this._hBox);
            }
            this._hBox.removeAllChild();
            for(i = 1; i <= this._info.starCount; i++)
            {
               this._star = ComponentFactory.Instance.creat("rescue.star");
               this._hBox.addChild(this._star);
            }
            this._hBox.refreshChildPos();
         }
         else
         {
            this._bg.setFrame(2);
            ObjectUtils.disposeObject(this._sceneNum);
            this._sceneNum = null;
            ObjectUtils.disposeObject(this._hBox);
            this._hBox = null;
         }
      }
      
      public function setSelected(flag:Boolean) : void
      {
         this._light.visible = flag;
      }
      
      private function removeEvents() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._light);
         this._light = null;
         ObjectUtils.disposeObject(this._sceneNum);
         this._sceneNum = null;
         ObjectUtils.disposeObject(this._star);
         this._star = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
      }
      
      public function get info() : RescueSceneInfo
      {
         return this._info;
      }
      
      public function get sceneId() : int
      {
         return this._sceneId;
      }
   }
}

