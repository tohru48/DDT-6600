package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StarBar extends Sprite implements Disposeable
   {
      
      public static var SPACE:int = 0.2;
      
      public static var TOTAL_STAR:int = 5;
      
      private var _starImgVec:Vector.<Bitmap>;
      
      public function StarBar()
      {
         super();
         this._starImgVec = new Vector.<Bitmap>();
      }
      
      public function starNum(num:int, assetResource:String = "assets.petsBag.star") : void
      {
         var img:Bitmap = null;
         if(num > 0)
         {
            if(num > TOTAL_STAR)
            {
               num = TOTAL_STAR;
            }
            this.remove();
            while(Boolean(num--))
            {
               img = ComponentFactory.Instance.creatBitmap(assetResource);
               this._starImgVec.push(img);
            }
            this.update();
         }
         else
         {
            this.remove();
         }
      }
      
      private function update() : void
      {
         var count:int = int(this._starImgVec.length);
         for(var index:int = 0; index < count; index++)
         {
            addChild(this._starImgVec[index]);
            this._starImgVec[index].x = index * (this._starImgVec[index].width - 3) + SPACE;
         }
      }
      
      private function remove() : void
      {
         var count:int = int(this._starImgVec.length);
         for(var index:int = 0; index < count; index++)
         {
            ObjectUtils.disposeObject(this._starImgVec[index]);
         }
         this._starImgVec.splice(0,this._starImgVec.length);
      }
      
      public function dispose() : void
      {
         this.remove();
         this._starImgVec = null;
      }
   }
}

