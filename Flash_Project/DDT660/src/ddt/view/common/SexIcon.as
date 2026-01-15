package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import flash.display.Sprite;
   
   public class SexIcon extends Sprite implements Disposeable
   {
      
      private var _sexIcon:ScaleFrameImage;
      
      private var _sex:Boolean;
      
      public function SexIcon(sex:Boolean = true)
      {
         super();
         this._sexIcon = ComponentFactory.Instance.creat("sex_icon");
         this._sexIcon.setFrame(sex ? 1 : 2);
         addChild(this._sexIcon);
      }
      
      public function setSex(sex:Boolean) : void
      {
         this._sexIcon.setFrame(sex ? 2 : 1);
      }
      
      public function set size(value:Number) : void
      {
         this._sexIcon.scaleX = this._sexIcon.scaleY = value;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sexIcon))
         {
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

