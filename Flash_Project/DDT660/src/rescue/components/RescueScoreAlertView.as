package rescue.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import hall.hallInfo.playerInfo.ImgNumConverter;
   
   public class RescueScoreAlertView extends Sprite implements Disposeable
   {
      
      private var _addBmp:Bitmap;
      
      private var _numSprite:Sprite;
      
      public function RescueScoreAlertView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._addBmp = ComponentFactory.Instance.creat("rescue.room.addIcon");
         addChild(this._addBmp);
      }
      
      public function setData(num:int) : void
      {
         ObjectUtils.disposeObject(this._numSprite);
         this._numSprite = null;
         this._numSprite = ImgNumConverter.instance.convertToImg(num,"rescue.room.num",11);
         PositionUtils.setPos(this._numSprite,"rescue.numSpritePos");
         addChild(this._numSprite);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._addBmp);
         this._addBmp = null;
         ObjectUtils.disposeObject(this._numSprite);
         this._numSprite = null;
      }
   }
}

