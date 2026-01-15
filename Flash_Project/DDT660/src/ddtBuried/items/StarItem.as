package ddtBuried.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class StarItem extends Sprite
   {
      
      private var _list:Vector.<MovieClip>;
      
      public function StarItem()
      {
         super();
         this.initStarList();
      }
      
      private function initStarList() : void
      {
         var _starMc:MovieClip = null;
         this._list = new Vector.<MovieClip>();
         for(var i:int = 0; i < 5; i++)
         {
            _starMc = ComponentFactory.Instance.creat("buried.core.improveEffect");
            _starMc.x = (_starMc.width + 2) * i;
            _starMc.stop();
            addChild(_starMc);
            this._list.push(_starMc);
         }
      }
      
      private function clearMc() : void
      {
         var mc:MovieClip = null;
         for(var i:int = 0; i < 5; i++)
         {
            this._list[i].stop();
            while(Boolean(this._list[i].numChildren))
            {
               if(this._list[i].getChildAt(0) is MovieClip)
               {
                  mc = this._list[i].getChildAt(0) as MovieClip;
                  while(Boolean(mc.numChildren))
                  {
                     ObjectUtils.disposeObject(mc.getChildAt(0));
                  }
               }
               ObjectUtils.disposeObject(this._list[i].getChildAt(0));
            }
         }
      }
      
      public function setStarList(num:int) : void
      {
         for(var i:int = 0; i < num; )
         {
            this._list[i].play();
            i++;
         }
      }
      
      public function updataStarLevel(num:int) : void
      {
         this._list[num - 1].play();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._list))
         {
            this.clearMc();
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._list = null;
      }
   }
}

